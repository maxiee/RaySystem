import asyncio
from datetime import datetime, timedelta
import time
from typing import Dict, Callable
from sqlalchemy import select

from module.crawler.ddg.ddg import ddg_crawler_task
from module.crawler.rss.rss_collector import create_rss_job
from module.crawler.test.test_crawler import test_crawler_task
from module.db.db import db_async_session
from module.info.info import info_create_site_if_not_exists_by_host
from module.task_scheduler.model import ScheduledTask, TaskTagSate


async def task_scheduler_load_scheduled_tasks():
    """Load all scheduled tasks from the database"""
    async with db_async_session() as session:
        result = await session.execute(select(ScheduledTask))
        return result.scalars().all()


async def task_scheduler_is_schedule_task_exists(task_id: str):
    async with db_async_session() as session:
        result = await session.execute(
            select(ScheduledTask).where(ScheduledTask.id == task_id)
        )
        return result.scalar() is not None


async def task_scheduler_add_scheduled_task(task: ScheduledTask):
    """Add a new scheduled task to the database"""
    async with db_async_session() as session:
        session.add(task)
        await session.commit()


async def task_scheduler_load_tag_states():
    """Load all tag states from the database"""
    async with db_async_session() as session:
        result = await session.execute(select(TaskTagSate))
        return result.scalars().all()


async def task_scheduler_merge_tag_state(tag_state: TaskTagSate):
    """
    Merge a tag state to the database.
    If the tag_state exists, updates it. If not, creates a new record.
    """
    async with db_async_session() as session:
        # The merge() method intelligently inserts or updates a record in the database
        # - if the record exists, it updates it; if not, it creates a new one.
        await session.merge(tag_state)
        await session.commit()


class RaySchedular:
    def __init__(self) -> None:
        self.tasks: Dict[str, ScheduledTask] = {}
        self.tag_states: Dict[str, TaskTagSate] = {}
        self.running = False
        self.task_cooldown = 300  # 默认5分钟冷却时间
        self.debug = False  # 添加调试模式标志

        # 任务注册表（类型到处理函数的映射）
        self.task_registry: Dict[str, Callable] = {}

    async def initialize(self):
        """初始化数据库和内存状态"""
        # 加载任务
        self.tasks = {
            task.id: task for task in await task_scheduler_load_scheduled_tasks()
        }
        # 加载标签状态
        self.tag_states = {
            tag_state.tag: tag_state
            for tag_state in await task_scheduler_load_tag_states()
        }

    def register_task_type(self, task_type: str, handler: Callable):
        """注册任务类型"""
        self.task_registry[task_type] = handler

    async def add_task(
        self, task_id: str, task_type: str, interval: int, tag: str, parameters: Dict
    ):
        """
        Add a task to the scheduler.

        Args:
            task_id (str): Unique identifier for the task.
            task_type (str): Type of the task.
            interval (int): Time interval (in seconds) for task execution.
            tag (str): Tag to identify the task.
            parameters (Dict): Dictionary of parameters for the task.

        Raises:
            ValueError: If the task type is not registered.
        """
        if task_type not in self.task_registry:
            raise ValueError(f"Unregistered task type: {task_type}")

        new_task = ScheduledTask(
            id=task_id,
            task_type=task_type,
            interval=interval,
            next_run=datetime.now(),
            tag=tag,
            parameters=parameters,
        )
        await task_scheduler_add_scheduled_task(new_task)
        self.tasks[task_id] = new_task

    def _debug_print(self, message: str):
        """调试模式下打印信息"""
        if self.debug:
            print(message)

    async def _execute_task(self, task: ScheduledTask):
        """执行单个任务"""
        current_time = datetime.now()
        handler = self.task_registry[task.task_type]
        parameters = task.parameters

        try:
            self._debug_print(f"Executing task {task.id} ({task.task_type})")
            await handler(**parameters)  # 执行注册的处理函数
        except Exception as e:
            self._debug_print(f"Task {task.id} failed: {str(e)}")
        finally:
            # 更新任务状态
            task.next_run = current_time + timedelta(seconds=task.interval)
            # 更新标签状态
            if task.tag in self.tag_states:
                self.tag_states[task.tag].last_run = current_time
            else:
                self.tag_states[task.tag] = TaskTagSate(
                    tag=task.tag, last_run=current_time
                )
            # 持久化到数据库
            await task_scheduler_merge_tag_state(self.tag_states[task.tag])

    async def _scheduler_loop(self):
        """核心调度循环"""
        while self.running:
            now = datetime.now()
            candidates = []

            # 第一阶段：收集候选任务
            self._debug_print(f"[调度器] 开始检查待执行任务 - {now}")
            for task in self.tasks.values():
                if task.next_run <= now:
                    candidates.append(task)
            self._debug_print(f"[调度器] 发现 {len(candidates)} 个到期任务")

            # 第二阶段：筛选可执行任务
            executable = []
            for task in candidates:
                tag_state = self.tag_states.get(task.tag)
                if (
                    tag_state is None
                    or (now - tag_state.last_run).total_seconds() >= self.task_cooldown
                ):
                    executable.append(task)
                else:
                    cooldown_remaining = (
                        self.task_cooldown - (now - tag_state.last_run).total_seconds()
                    )
                    self._debug_print(
                        f"[调度器] 任务 {task.id} 仍在冷却中，剩余 {cooldown_remaining:.1f} 秒"
                    )
            self._debug_print(f"[调度器] 筛选出 {len(executable)} 个可执行任务")

            # 第三阶段：选择最老的任务
            if executable:
                executable.sort(key=lambda x: x.next_run)
                selected = executable[0]
                self._debug_print(
                    f"[调度器] 执行最早的任务: {selected.id}，类型: {selected.task_type}"
                )
                await self._execute_task(selected)
            else:
                self._debug_print(f"[调度器] 无可执行任务")

            await asyncio.sleep(1)

    async def start(self):
        """启动调度器"""
        if not self.running:
            self.running = True
            asyncio.create_task(self._scheduler_loop())

    async def stop(self):
        """停止调度器"""
        self.running = False


kTaskScheduler = RaySchedular()


async def init_task_scheduler():
    await kTaskScheduler.initialize()
    kTaskScheduler.debug = False  # 确保调度器以非调试模式启动
    
    # 注册任务处理程序
    kTaskScheduler.register_task_type("test_crawler", test_crawler_task)
    kTaskScheduler.register_task_type("ddg", ddg_crawler_task)

    one_day_in_seconds = 86400

    ddg_webassembly = "webassembly"
    if not await task_scheduler_is_schedule_task_exists(ddg_webassembly):
        await kTaskScheduler.add_task(
            ddg_webassembly, "ddg", one_day_in_seconds, "ddg", {"query": "webassembly"}
        )

    ddg_smolagents = "smolagents"
    if not await task_scheduler_is_schedule_task_exists(ddg_smolagents):
        await kTaskScheduler.add_task(
            ddg_smolagents, "ddg", one_day_in_seconds, "ddg", {"query": "smolagents"}
        )
    
    ddg_flutter = "flutter"
    if not await task_scheduler_is_schedule_task_exists(ddg_flutter):
        await kTaskScheduler.add_task(
            ddg_flutter, "ddg", one_day_in_seconds, "ddg", {"query": "flutter"}
        )

    task_id = "test_crawler_1"
    if not await task_scheduler_is_schedule_task_exists(task_id):
        await kTaskScheduler.add_task(
            task_id, "test_crawler", 5, "test_crawler", {"message": "Hello"}
        )

    # site_36Kr = await info_create_site_if_not_exists_by_host("https://36kr.com/feed")
    # await create_rss_job(
    #     kTaskScheduler, "https://36kr.com/feed", site_36Kr, interval=3600
    # )

    await kTaskScheduler.start()
    print("Task scheduler initialized")  # 这个初始化消息保留，因为它只会打印一次


async def dispose_task_scheduler():
    await kTaskScheduler.stop()
    print("Task scheduler disposed")
