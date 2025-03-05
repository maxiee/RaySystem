import asyncio
import pytest
import pytest_asyncio
import time
from datetime import datetime, timedelta
from unittest.mock import AsyncMock, MagicMock, patch

from module.task_scheduler.model import ScheduledTask, TaskScheduleType, TaskTagSate
from module.task_scheduler.task_scheduler import RayScheduler
from sqlalchemy import delete


class TestRayScheduler:
    """RayScheduler 类的单元测试"""

    @pytest_asyncio.fixture
    async def scheduler(self):
        """创建一个测试用的调度器实例"""
        scheduler = RayScheduler()
        
        # 使用Mock对象替换数据库相关函数调用
        with patch('module.task_scheduler.task_scheduler.task_scheduler_load_scheduled_tasks', new_callable=AsyncMock) as mock_load_tasks, \
             patch('module.task_scheduler.task_scheduler.task_scheduler_load_tag_states', new_callable=AsyncMock) as mock_load_states, \
             patch('module.task_scheduler.task_scheduler.task_scheduler_add_scheduled_task', new_callable=AsyncMock) as mock_add_task, \
             patch('module.task_scheduler.task_scheduler.task_scheduler_merge_tag_state', new_callable=AsyncMock) as mock_merge_state, \
             patch('module.task_scheduler.task_scheduler.task_scheduler_update_tag_state', new_callable=AsyncMock) as mock_update_tag, \
             patch('module.task_scheduler.task_scheduler.task_scheduler_update_scheduled_task', new_callable=AsyncMock) as mock_update_task:
            
            # 配置初始空数据
            mock_load_tasks.return_value = []
            mock_load_states.return_value = []
            
            # 设置调试模式以输出日志
            scheduler.debug = True
            
            # 初始化调度器
            await scheduler.initialize()
            
            yield scheduler
            
            # 测试结束后停止调度器
            await scheduler.stop()

    @pytest.mark.asyncio
    async def test_register_task_type(self, scheduler):
        """测试注册任务类型"""
        # 创建测试任务处理函数
        async def test_handler(**kwargs):
            return True
        
        # 注册任务类型
        scheduler.register_task_type("test_task", test_handler)
        
        # 验证是否成功注册
        assert "test_task" in scheduler.task_registry
        assert scheduler.task_registry["test_task"] == test_handler

    @pytest.mark.asyncio
    async def test_add_interval_task(self, scheduler):
        """测试添加间隔执行任务"""
        # 注册测试任务类型
        mock_handler = AsyncMock()
        scheduler.register_task_type("test_task", mock_handler)
        
        # 添加间隔执行任务
        with patch('module.task_scheduler.task_scheduler.task_scheduler_add_scheduled_task', new_callable=AsyncMock) as mock_add_task:
            await scheduler.add_interval_task(
                task_id="test_interval",
                task_type="test_task",
                interval=60,
                tag="test",
                parameters={"key": "value"}
            )
            
            # 验证任务是否成功添加到内存中
            assert "test_interval" in scheduler.tasks
            task = scheduler.tasks["test_interval"]
            assert task.schedule_type == TaskScheduleType.INTERVAL
            assert task.interval == 60
            assert task.tag == "test"
            assert task.parameters == {"key": "value"}
            
            # 验证是否调用了持久化函数
            mock_add_task.assert_called_once()

    @pytest.mark.asyncio
    async def test_add_cron_task(self, scheduler):
        """测试添加Cron定时任务"""
        # 注册测试任务类型
        mock_handler = AsyncMock()
        scheduler.register_task_type("test_task", mock_handler)
        
        # 添加Cron定时任务
        with patch('module.task_scheduler.task_scheduler.task_scheduler_add_scheduled_task', new_callable=AsyncMock) as mock_add_task:
            await scheduler.add_cron_task(
                task_id="test_cron",
                task_type="test_task",
                cron_expression="0 * * * *",  # 每小时执行一次
                tag="test",
                parameters={"key": "value"}
            )
            
            # 验证任务是否成功添加到内存中
            assert "test_cron" in scheduler.tasks
            task = scheduler.tasks["test_cron"]
            assert task.schedule_type == TaskScheduleType.CRON
            assert task.cron_expression == "0 * * * *"
            assert task.tag == "test"
            assert task.parameters == {"key": "value"}
            
            # 验证是否调用了持久化函数
            mock_add_task.assert_called_once()

    @pytest.mark.asyncio
    async def test_add_event_task(self, scheduler):
        """测试添加事件驱动任务"""
        # 注册测试任务类型
        mock_handler = AsyncMock()
        scheduler.register_task_type("test_task", mock_handler)
        
        # 添加事件驱动任务
        with patch('module.task_scheduler.task_scheduler.task_scheduler_add_scheduled_task', new_callable=AsyncMock) as mock_add_task:
            await scheduler.add_event_task(
                task_id="test_event",
                task_type="test_task",
                event_type="test_event",
                tag="test",
                parameters={"key": "value"}
            )
            
            # 验证任务是否成功添加到内存中
            assert "test_event" in scheduler.tasks
            task = scheduler.tasks["test_event"]
            assert task.schedule_type == TaskScheduleType.EVENT
            assert task.event_type == "test_event"
            assert task.tag == "test"
            assert task.parameters == {"key": "value"}
            
            # 验证是否在事件映射中注册了该任务
            assert "test_event" in scheduler.event_tasks
            assert "test_event" in scheduler.event_tasks["test_event"]
            
            # 验证是否调用了持久化函数
            mock_add_task.assert_called_once()

    @pytest.mark.asyncio
    async def test_add_manual_task(self, scheduler):
        """测试添加手动触发任务"""
        # 注册测试任务类型
        mock_handler = AsyncMock()
        scheduler.register_task_type("test_task", mock_handler)
        
        # 添加手动触发任务
        with patch('module.task_scheduler.task_scheduler.task_scheduler_add_scheduled_task', new_callable=AsyncMock) as mock_add_task:
            await scheduler.add_manual_task(
                task_id="test_manual",
                task_type="test_task",
                tag="test",
                parameters={"key": "value"}
            )
            
            # 验证任务是否成功添加到内存中
            assert "test_manual" in scheduler.tasks
            task = scheduler.tasks["test_manual"]
            assert task.schedule_type == TaskScheduleType.MANUAL
            assert task.tag == "test"
            assert task.parameters == {"key": "value"}
            
            # 验证是否调用了持久化函数
            mock_add_task.assert_called_once()

    @pytest.mark.asyncio
    async def test_emit_event(self, scheduler):
        """测试事件发射"""
        # 注册测试任务类型
        mock_handler = AsyncMock()
        scheduler.register_task_type("test_task", mock_handler)
        
        # 添加事件驱动任务
        with patch('module.task_scheduler.task_scheduler.task_scheduler_add_scheduled_task', new_callable=AsyncMock) as mock_add_task:
            await scheduler.add_event_task(
                task_id="test_event",
                task_type="test_task",
                event_type="article_published",
                tag="test",
                parameters={"base_param": "value"}
            )
        
        # 触发事件，提供额外的上下文参数
        with patch('module.task_scheduler.task_scheduler.task_scheduler_update_tag_state', new_callable=AsyncMock) as mock_update_tag:
            await scheduler.emit_event(
                event_type="article_published",
                article_id=123,
                title="Test Article"
            )
            
            # 等待任务执行
            await asyncio.sleep(0.1)
            
            # 验证任务是否被执行
            mock_handler.assert_called_once()
            
            # 验证参数是否正确合并
            call_args = mock_handler.call_args[1]
            assert call_args["base_param"] == "value"
            assert call_args["article_id"] == 123
            assert call_args["title"] == "Test Article"
            
            # 验证是否更新了标签状态
            mock_update_tag.assert_called_once()

    @pytest.mark.asyncio
    async def test_trigger_task(self, scheduler):
        """测试手动触发任务"""
        # 注册测试任务类型
        mock_handler = AsyncMock()
        scheduler.register_task_type("test_task", mock_handler)
        
        # 添加手动触发任务
        with patch('module.task_scheduler.task_scheduler.task_scheduler_add_scheduled_task', new_callable=AsyncMock) as mock_add_task:
            await scheduler.add_manual_task(
                task_id="test_manual",
                task_type="test_task",
                tag="test",
                parameters={"base_param": "value"}
            )
        
        # 手动触发任务，提供额外的参数
        with patch('module.task_scheduler.task_scheduler.task_scheduler_update_tag_state', new_callable=AsyncMock) as mock_update_tag:
            await scheduler.trigger_task(
                task_id="test_manual",
                extra_param="extra_value"
            )
            
            # 验证任务是否被执行
            mock_handler.assert_called_once()
            
            # 验证参数是否正确合并
            call_args = mock_handler.call_args[1]
            assert call_args["base_param"] == "value"
            assert call_args["extra_param"] == "extra_value"
            
            # 验证是否更新了标签状态
            mock_update_tag.assert_called_once()

    @pytest.mark.asyncio
    async def test_scheduler_loop_interval_task(self, scheduler):
        """测试调度器循环 - 间隔任务"""
        # 注册测试任务类型
        mock_handler = AsyncMock()
        scheduler.register_task_type("test_task", mock_handler)
        
        # 设置短冷却时间，便于测试
        scheduler.task_cooldown = 0
        
        # 创建已到期的间隔任务
        base_time = datetime.now() - timedelta(seconds=10)  # 10秒前到期
        task = ScheduledTask(
            id="test_interval",
            task_type="test_task",
            schedule_type=TaskScheduleType.INTERVAL,
            interval=60,
            next_run=base_time,
            tag="test",
            parameters={},
            enabled=True
        )
        
        # 添加任务到内存中
        scheduler.tasks[task.id] = task
        
        # 启动调度器并等待一小段时间
        with patch('module.task_scheduler.task_scheduler.task_scheduler_update_tag_state', new_callable=AsyncMock) as mock_update_tag:
            await scheduler.start()
            
            # 等待足够的时间让调度器执行任务
            await asyncio.sleep(2)
            
            # 验证任务是否被执行
            mock_handler.assert_called()
            
            # 验证是否更新了下次执行时间
            assert task.next_run > base_time
            
            # 验证是否更新了标签状态
            mock_update_tag.assert_called()
            
            # 停止调度器
            await scheduler.stop()

    @pytest.mark.asyncio
    async def test_cooldown_period(self, scheduler):
        """测试任务冷却时间"""
        # 注册测试任务类型
        mock_handler = AsyncMock()
        scheduler.register_task_type("test_task", mock_handler)
        
        # 设置冷却时间
        scheduler.task_cooldown = 5  # 5秒冷却时间
        
        # 创建两个使用相同标签的任务
        base_time = datetime.now() - timedelta(seconds=10)  # 10秒前到期
        task1 = ScheduledTask(
            id="test_task1",
            task_type="test_task",
            schedule_type=TaskScheduleType.INTERVAL,
            interval=60,
            next_run=base_time,
            tag="same_tag",
            parameters={},
            enabled=True
        )
        
        task2 = ScheduledTask(
            id="test_task2",
            task_type="test_task",
            schedule_type=TaskScheduleType.INTERVAL,
            interval=60,
            next_run=base_time,
            tag="same_tag",
            parameters={},
            enabled=True
        )
        
        # 添加任务到内存中
        scheduler.tasks[task1.id] = task1
        scheduler.tasks[task2.id] = task2
        
        # 创建标签状态 - 任务刚执行过
        tag_state = TaskTagSate(
            tag="same_tag",
            last_run=datetime.now()
        )
        scheduler.tag_states["same_tag"] = tag_state
        
        # 保存原始方法引用
        original_execute_task = scheduler._execute_task
        
        try:
            # 替换为Mock对象
            mock_execute_task = AsyncMock()
            scheduler._execute_task = mock_execute_task
            
            await scheduler.start()
            
            # 等待一小段时间
            await asyncio.sleep(2)
            
            # 验证冷却期间任务不会执行
            mock_execute_task.assert_not_called()
            
            # 模拟冷却时间已过
            scheduler.tag_states["same_tag"].last_run = datetime.now() - timedelta(seconds=10)
            
            # 再等待一段时间
            await asyncio.sleep(2)
            
            # 验证冷却时间过后任务会执行
            mock_execute_task.assert_called()
        finally:
            # 恢复原始方法
            scheduler._execute_task = original_execute_task
            
            # 停止调度器
            await scheduler.stop()

    @pytest.mark.asyncio
    async def test_task_error_handling(self, scheduler):
        """测试任务执行错误处理"""
        # 注册一个会抛出异常的测试任务处理函数
        async def failing_handler(**kwargs):
            raise ValueError("Task failed deliberately")
        
        scheduler.register_task_type("failing_task", failing_handler)
        
        # 添加任务
        task = ScheduledTask(
            id="failing_test",
            task_type="failing_task",
            schedule_type=TaskScheduleType.MANUAL,
            interval=0,
            next_run=datetime.now(),
            tag="test",
            parameters={},
            enabled=True
        )
        
        scheduler.tasks[task.id] = task
        
        # 执行任务，验证异常被正确捕获（不会导致测试失败）
        with patch('module.task_scheduler.task_scheduler.task_scheduler_update_tag_state', new_callable=AsyncMock) as mock_update_tag:
            await scheduler.trigger_task("failing_test")
            
            # 验证即使任务失败，标签状态也会更新
            mock_update_tag.assert_called_once()

    @pytest.mark.asyncio
    async def test_cron_task_next_run_calculation(self, scheduler):
        """测试Cron任务的下次执行时间计算"""
        # 注册测试任务类型
        mock_handler = AsyncMock()
        scheduler.register_task_type("test_task", mock_handler)
        
        # 添加使用特定时间表达式的Cron定时任务
        with patch('module.task_scheduler.task_scheduler.task_scheduler_add_scheduled_task', new_callable=AsyncMock) as mock_add_task:
            await scheduler.add_cron_task(
                task_id="test_cron",
                task_type="test_task",
                cron_expression="*/5 * * * *",  # 每5分钟执行一次
                tag="test",
                parameters={}
            )
        
        # 获取任务对象
        task = scheduler.tasks["test_cron"]
        original_next_run = task.next_run
        
        # 手动设置current_time为当前时间+2分钟，应该推进到下一个5分钟间隔
        current_time = datetime.now() + timedelta(minutes=2)
        
        # 保存原始时间并手动更新
        await scheduler._update_next_run_time(task, current_time)
        
        # 验证下次执行时间是否按照cron表达式计算
        assert task.next_run != original_next_run
        
        # 验证下次执行时间是否正确计算（应该是下一个5分钟的间隔）
        from croniter import croniter
        expected_next_run = croniter("*/5 * * * *", current_time).get_next(datetime)
        assert abs((task.next_run - expected_next_run).total_seconds()) < 1  # 允许1秒误差