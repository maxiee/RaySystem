import asyncio
from datetime import datetime, timedelta
import logging
import time
from typing import Dict, Callable, List, Optional
from sqlalchemy import select
from croniter import croniter
from module.crawler.ddg.ddg import ddg_crawler_task
from module.crawler.rss.rss_collector import create_rss_job
from module.crawler.test.test_crawler import crawler_test_task
from module.db.db import db_async_session
from module.info.info import info_create_site_if_not_exists_by_host
from module.task_scheduler.model import ScheduledTask, TaskScheduleType, TaskTagSate


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

class EventEmitter:
    """简单的事件发射器，用于事件驱动任务"""
    def __init__(self):
        self._handlers: Dict[str, List[Callable]] = {}
        
    def on(self, event_type: str, handler: Callable):
        """注册事件处理程序"""
        if event_type not in self._handlers:
            self._handlers[event_type] = []
        self._handlers[event_type].append(handler)
        
    def emit(self, event_type: str, *args, **kwargs):
        """触发事件"""
        if event_type in self._handlers:
            for handler in self._handlers[event_type]:
                asyncio.create_task(handler(*args, **kwargs))

class RaySchedular:
    def __init__(self) -> None:
        self.tasks: Dict[str, ScheduledTask] = {}
        self.tag_states: Dict[str, TaskTagSate] = {}
        self.running = False
        self.task_cooldown = 300  # 默认5分钟冷却时间
        self.debug = False  # 添加调试模式标志

        # 任务注册表（类型到处理函数的映射）
        self.task_registry: Dict[str, Callable] = {}

        # 事件系统
        self.event_emitter = EventEmitter()
        self.event_tasks: Dict[str, List[str]] = {}  # 事件类型 -> 任务ID列表

        # 日志记录器
        self.logger = logging.getLogger("RaySchedular")

    async def initialize(self):
        """初始化数据库和内存状态"""
        # 加载任务和标签状态
        tasks = await task_scheduler_load_scheduled_tasks()
        self.tasks = {task.id: task for task in tasks}

        # 构建事件任务映射
        for task in self.tasks.values():
            if task.schedule_type == TaskScheduleType.EVENT and task.event_type:
                if task.event_type not in self.event_tasks:
                    self.event_tasks[task.event_type] = []
                self.event_tasks[task.event_type].append(task.id)

        # 加载标签状态
        self.tag_states = {
            tag_state.tag: tag_state
            for tag_state in await task_scheduler_load_tag_states()
        }

    def register_task_type(self, task_type: str, handler: Callable):
        """注册任务类型"""
        self.task_registry[task_type] = handler

    async def add_interval_task(
        self, task_id: str, task_type: str, interval: int, tag: str, parameters: Dict
    ):
        """添加间隔执行任务"""
        await self._add_task(
            task_id=task_id,
            task_type=task_type,
            schedule_type=TaskScheduleType.INTERVAL,
            interval=interval,
            cron_expression=None,
            event_type=None,
            tag=tag,
            parameters=parameters,
        )
    
    async def add_cron_task(
        self, task_id: str, task_type: str, cron_expression: str, tag: str, parameters: Dict
    ):
        """添加定时任务（使用cron表达式）"""
        # 验证cron表达式
        if not croniter.is_valid(cron_expression):
            raise ValueError(f"Invalid cron expression: {cron_expression}")
            
        next_run = croniter(cron_expression, datetime.now()).get_next(datetime)
        
        await self._add_task(
            task_id=task_id,
            task_type=task_type,
            schedule_type=TaskScheduleType.CRON,
            interval=0,
            cron_expression=cron_expression,
            event_type=None,
            tag=tag,
            parameters=parameters,
            next_run=next_run,
        )
    
    async def add_event_task(
        self, task_id: str, task_type: str, event_type: str, tag: str, parameters: Dict
    ):
        """添加事件驱动任务"""
        # 注册这个事件类型
        if event_type not in self.event_tasks:
            self.event_tasks[event_type] = []
        self.event_tasks[event_type].append(task_id)
        
        await self._add_task(
            task_id=task_id,
            task_type=task_type,
            schedule_type=TaskScheduleType.EVENT,
            interval=0,
            cron_expression=None,
            event_type=event_type,
            tag=tag,
            parameters=parameters,
        )
    
    async def add_manual_task(
        self, task_id: str, task_type: str, tag: str, parameters: Dict
    ):
        """添加手动触发任务"""
        await self._add_task(
            task_id=task_id,
            task_type=task_type,
            schedule_type=TaskScheduleType.MANUAL,
            interval=0,
            cron_expression=None,
            event_type=None,
            tag=tag,
            parameters=parameters,
        )

    async def _add_task(
        self,
        task_id: str,
        task_type: str,
        schedule_type: TaskScheduleType,
        interval: int = 0,
        cron_expression: Optional[str] = None,
        event_type: Optional[str] = None,
        tag: str = "",
        parameters: Dict = {},
        next_run: Optional[datetime] = None,
    ):
        """内部方法：添加任务"""
        if task_type not in self.task_registry:
            raise ValueError(f"Unregistered task type: {task_type}")
            
        if next_run is None:
            next_run = datetime.now()
            
        new_task = ScheduledTask(
            id=task_id,
            task_type=task_type,
            schedule_type=schedule_type,
            interval=interval,
            cron_expression=cron_expression,
            event_type=event_type,
            next_run=next_run,
            tag=tag,
            parameters=parameters,
        )
        
        await task_scheduler_add_scheduled_task(new_task)
        self.tasks[task_id] = new_task
        
        self._debug_print(f"Added {schedule_type.value} task: {task_id}")
    
    async def emit_event(self, event_type: str, **context):
        """触发事件，执行关联的任务"""
        if event_type not in self.event_tasks:
            self._debug_print(f"No tasks registered for event: {event_type}")
            return
            
        task_ids = self.event_tasks[event_type]
        self._debug_print(f"Event {event_type} triggered. Running {len(task_ids)} tasks.")
        
        for task_id in task_ids:
            if task_id in self.tasks:
                task = self.tasks[task_id]
                # 合并上下文和任务参数
                merged_params = {**task.parameters, **context}
                await self._execute_task(task, merged_params)
            else:
                self._debug_print(f"Task {task_id} not found for event {event_type}")
    
    async def trigger_task(self, task_id: str, **additional_params):
        """手动触发特定任务"""
        if task_id not in self.tasks:
            raise ValueError(f"Task not found: {task_id}")
            
        task = self.tasks[task_id]
        # 合并附加参数和任务参数
        merged_params = {**task.parameters, **additional_params}
        await self._execute_task(task, merged_params)
    

    async def _execute_task(self, task: ScheduledTask, parameters: Dict = {}):
        """执行单个任务"""
        current_time = datetime.now()
        handler = self.task_registry[task.task_type]
        params = parameters or task.parameters

        try:
            self._debug_print(f"执行任务 {task.id} ({task.task_type})")
            await handler(**params)
        except Exception as e:
            self._debug_print(f"任务 {task.id} 失败: {str(e)}")
        finally:
            # 更新任务状态和标签状态
            self._update_next_run_time(task, current_time)
            self._update_tag_state(task.tag, current_time)
            
            # 持久化更新
            await task_scheduler_merge_tag_state(self.tag_states[task.tag])
    
    def _update_next_run_time(self, task: ScheduledTask, current_time: datetime):
        """更新任务的下次执行时间"""
        if task.schedule_type == TaskScheduleType.INTERVAL:
            task.next_run = current_time + timedelta(seconds=task.interval)
        elif task.schedule_type == TaskScheduleType.CRON and task.cron_expression:
            task.next_run = croniter(task.cron_expression, current_time).get_next(datetime)
        # EVENT和MANUAL类型的任务不需要设置下次执行时间
    
    def _update_tag_state(self, tag: str, current_time: datetime):
        """更新标签状态"""
        if tag in self.tag_states:
            self.tag_states[tag].last_run = current_time
        else:
            self.tag_states[tag] = TaskTagSate(tag=tag, last_run=current_time)

    async def _scheduler_loop(self):
        """核心调度循环"""
        while self.running:
            now = datetime.now()
            candidates = []

            # 第一阶段：收集时间触发的候选任务（间隔任务和定时任务）
            for task in self.tasks.values():
                if (task.schedule_type in [TaskScheduleType.INTERVAL, TaskScheduleType.CRON] 
                    and task.next_run <= now
                    and task.enabled):
                    candidates.append(task)
            
            self._debug_print(f"[调度器] 发现 {len(candidates)} 个到期任务")

            # 第二阶段：筛选可执行任务（考虑冷却时间）
            executable = []
            for task in candidates:
                tag_state = self.tag_states.get(task.tag)
                if (tag_state is None or 
                    (now - tag_state.last_run).total_seconds() >= self.task_cooldown):
                    executable.append(task)
            
            # 第三阶段：选择并执行最早到期的任务
            if executable:
                executable.sort(key=lambda x: x.next_run)
                selected = executable[0]
                self._debug_print(f"[调度器] 执行任务: {selected.id}, 类型: {selected.task_type}")
                await self._execute_task(selected)

            await asyncio.sleep(1)

    async def start(self):
        """启动调度器"""
        if not self.running:
            self.running = True
            self.logger.info("Task scheduler starting")
            asyncio.create_task(self._scheduler_loop())

    async def stop(self):
        """停止调度器"""
        self.running = False
        self.logger.info("Task scheduler stopped")
    
    def _debug_print(self, message: str):
        """调试模式下打印信息"""
        if self.debug:
            print(message)


kTaskScheduler = RaySchedular()


async def init_task_scheduler():
    await kTaskScheduler.initialize()
    kTaskScheduler.debug = False  # 确保调度器以非调试模式启动
    
    # 注册任务处理程序
    kTaskScheduler.register_task_type("test_crawler", crawler_test_task)
    kTaskScheduler.register_task_type("ddg", ddg_crawler_task)

    one_day_in_seconds = 86400

    ddg_ai_agents = "ai agents"
    if not await task_scheduler_is_schedule_task_exists(ddg_ai_agents):
        await kTaskScheduler.add_interval_task(
            ddg_ai_agents, "ddg", one_day_in_seconds, "ddg", {"query": "ai agents"}
        )

    ddg_webassembly = "webassembly"
    if not await task_scheduler_is_schedule_task_exists(ddg_webassembly):
        await kTaskScheduler.add_interval_task(
            ddg_webassembly, "ddg", one_day_in_seconds, "ddg", {"query": "webassembly"}
        )

    ddg_smolagents = "smolagents"
    if not await task_scheduler_is_schedule_task_exists(ddg_smolagents):
        await kTaskScheduler.add_interval_task(
            ddg_smolagents, "ddg", one_day_in_seconds, "ddg", {"query": "smolagents"}
        )
    
    ddg_flutter = "flutter"
    if not await task_scheduler_is_schedule_task_exists(ddg_flutter):
        await kTaskScheduler.add_interval_task(
            ddg_flutter, "ddg", one_day_in_seconds, "ddg", {"query": "flutter"}
        )

    # 添加间隔执行任务 - 每5秒执行一次测试爬虫
    task_id = "test_crawler_1"
    if not await task_scheduler_is_schedule_task_exists(task_id):
        await kTaskScheduler.add_interval_task(
            "test_crawler_1", "test_crawler", 5, "test_crawler", {"message": "Hello"}
        )
    
    # 添加定时任务 - 每天凌晨2点执行数据清理
    # if not await task_scheduler_is_schedule_task_exists("daily_cleanup"):
    #     await kTaskScheduler.add_cron_task(
    #         "daily_cleanup", "data_cleanup", "0 2 * * *", "maintenance", {}
    #     )
    
    # 添加事件驱动任务 - 当新文章发布时执行社交媒体推送
    # if not await task_scheduler_is_schedule_task_exists("social_media_push"):
    #     await kTaskScheduler.add_event_task(
    #         "social_media_push", "social_push", "new_article_published", "social", {}
    #     )

    # site_36Kr = await info_create_site_if_not_exists_by_host("https://36kr.com/feed")
    # await create_rss_job(
    #     kTaskScheduler, "https://36kr.com/feed", site_36Kr, interval=3600
    # )

    await kTaskScheduler.start()
    print("Task scheduler initialized")  # 这个初始化消息保留，因为它只会打印一次


async def dispose_task_scheduler():
    await kTaskScheduler.stop()
    print("Task scheduler disposed")
