import pytest
from datetime import datetime, timedelta
from module.task_scheduler.model import ScheduledTask, TaskScheduleType
from module.task_scheduler.task_scheduler import kTaskScheduler
from sqlalchemy import delete

@pytest.mark.asyncio
async def test_get_scheduled_tasks_empty(app, async_client, test_session):
    """测试获取空的定时任务列表"""
    # 清理数据库
    await test_session.execute(delete(ScheduledTask))
    await test_session.commit()
    
    # 重置调度器的任务列表
    kTaskScheduler.tasks = {}
    
    response = await async_client.get("/scheduler_tasks/")
    assert response.status_code == 200
    data = response.json()
    assert len(data) == 0

@pytest.mark.asyncio
async def test_get_scheduled_tasks_with_interval_tasks(app, async_client, test_session):
    """测试包含间隔执行的定时任务列表"""
    # 清理数据库
    await test_session.execute(delete(ScheduledTask))
    await test_session.commit()
    
    # 重置调度器的任务列表
    kTaskScheduler.tasks = {}
    
    # 创建测试数据
    base_time = datetime.now()
    test_tasks = [
        ScheduledTask(
            id="test_task_1",
            task_type="test_crawler",
            schedule_type=TaskScheduleType.INTERVAL,
            interval=300,
            next_run=base_time,
            tag="test",
            parameters={"message": "Test 1"},
            enabled=True
        ),
        ScheduledTask(
            id="test_task_2",
            task_type="ddg",
            schedule_type=TaskScheduleType.INTERVAL,
            interval=86400,
            next_run=base_time + timedelta(hours=1),
            tag="ddg",
            parameters={"query": "test query"},
            enabled=True
        )
    ]
    
    # 添加测试数据到数据库和调度器
    for task in test_tasks:
        test_session.add(task)
        kTaskScheduler.tasks[task.id] = task
    await test_session.commit()
    
    # 测试API响应
    response = await async_client.get("/scheduler_tasks/")
    assert response.status_code == 200
    data = response.json()
    
    # 验证返回数据数量
    assert len(data) == 2
    
    # 验证返回数据格式和内容
    for task_data in data:
        assert isinstance(task_data["id"], str)
        assert isinstance(task_data["task_type"], str)
        assert isinstance(task_data["interval"], int)
        assert isinstance(task_data["tag"], str)
        assert isinstance(task_data["next_run"], str)
        assert isinstance(task_data["parameters"], dict)
    
    # 验证具体任务数据
    assert any(task["id"] == "test_task_1" and task["task_type"] == "test_crawler" for task in data)
    assert any(task["id"] == "test_task_2" and task["task_type"] == "ddg" for task in data)

@pytest.mark.asyncio
async def test_get_scheduled_tasks_with_cron_tasks(app, async_client, test_session):
    """测试包含CRON定时任务的列表"""
    # 清理数据库
    await test_session.execute(delete(ScheduledTask))
    await test_session.commit()
    
    # 重置调度器的任务列表
    kTaskScheduler.tasks = {}
    
    # 创建测试数据
    base_time = datetime.now()
    test_task = ScheduledTask(
        id="cron_task_1",
        task_type="test_crawler",
        schedule_type=TaskScheduleType.CRON,
        interval=0,
        cron_expression="0 2 * * *",  # 每天凌晨2点
        next_run=base_time + timedelta(hours=1),
        tag="cron",
        parameters={"message": "CRON task"},
        enabled=True
    )
    
    # 添加测试数据到数据库和调度器
    test_session.add(test_task)
    kTaskScheduler.tasks[test_task.id] = test_task
    await test_session.commit()
    
    # 测试API响应
    response = await async_client.get("/scheduler_tasks/")
    assert response.status_code == 200
    data = response.json()
    
    # 验证返回数据数量
    assert len(data) == 1
    
    # 验证具体任务数据
    task_data = data[0]
    assert task_data["id"] == "cron_task_1"
    assert task_data["task_type"] == "test_crawler"
    assert task_data["interval"] == 0
    assert task_data["tag"] == "cron"
    assert isinstance(task_data["next_run"], str)
    assert task_data["parameters"] == {"message": "CRON task"}

@pytest.mark.asyncio
async def test_get_scheduled_tasks_with_event_tasks(app, async_client, test_session):
    """测试包含事件驱动任务的列表"""
    # 清理数据库
    await test_session.execute(delete(ScheduledTask))
    await test_session.commit()
    
    # 重置调度器的任务列表
    kTaskScheduler.tasks = {}
    
    # 创建测试数据
    base_time = datetime.now()
    test_task = ScheduledTask(
        id="event_task_1",
        task_type="test_crawler",
        schedule_type=TaskScheduleType.EVENT,
        interval=0,
        event_type="new_article",
        next_run=base_time,
        tag="event",
        parameters={"message": "Event task"},
        enabled=True
    )
    
    # 添加测试数据到数据库和调度器
    test_session.add(test_task)
    kTaskScheduler.tasks[test_task.id] = test_task
    await test_session.commit()
    
    # 测试API响应
    response = await async_client.get("/scheduler_tasks/")
    assert response.status_code == 200
    data = response.json()
    
    # 验证返回数据数量
    assert len(data) == 1
    
    # 验证具体任务数据
    task_data = data[0]
    assert task_data["id"] == "event_task_1"
    assert task_data["task_type"] == "test_crawler"
    assert task_data["interval"] == 0
    assert task_data["tag"] == "event"
    assert isinstance(task_data["next_run"], str)
    assert task_data["parameters"] == {"message": "Event task"}

@pytest.mark.asyncio
async def test_get_scheduled_tasks_with_manual_tasks(app, async_client, test_session):
    """测试包含手动触发任务的列表"""
    # 清理数据库
    await test_session.execute(delete(ScheduledTask))
    await test_session.commit()
    
    # 重置调度器的任务列表
    kTaskScheduler.tasks = {}
    
    # 创建测试数据
    base_time = datetime.now()
    test_task = ScheduledTask(
        id="manual_task_1",
        task_type="test_crawler",
        schedule_type=TaskScheduleType.MANUAL,
        interval=0,
        next_run=base_time,
        tag="manual",
        parameters={"message": "Manual task"},
        enabled=True
    )
    
    # 添加测试数据到数据库和调度器
    test_session.add(test_task)
    kTaskScheduler.tasks[test_task.id] = test_task
    await test_session.commit()
    
    # 测试API响应
    response = await async_client.get("/scheduler_tasks/")
    assert response.status_code == 200
    data = response.json()
    
    # 验证返回数据数量
    assert len(data) == 1
    
    # 验证具体任务数据
    task_data = data[0]
    assert task_data["id"] == "manual_task_1"
    assert task_data["task_type"] == "test_crawler"
    assert task_data["interval"] == 0
    assert task_data["tag"] == "manual"
    assert isinstance(task_data["next_run"], str)
    assert task_data["parameters"] == {"message": "Manual task"}

@pytest.mark.asyncio
async def test_get_scheduled_tasks_with_all_types(app, async_client, test_session):
    """测试所有类型的定时任务混合列表"""
    # 清理数据库
    await test_session.execute(delete(ScheduledTask))
    await test_session.commit()
    
    # 重置调度器的任务列表
    kTaskScheduler.tasks = {}
    
    # 创建测试数据
    base_time = datetime.now()
    test_tasks = [
        ScheduledTask(
            id="interval_task",
            task_type="test_crawler",
            schedule_type=TaskScheduleType.INTERVAL,
            interval=300,
            next_run=base_time,
            tag="interval",
            parameters={"message": "Interval task"},
            enabled=True
        ),
        ScheduledTask(
            id="cron_task",
            task_type="test_crawler",
            schedule_type=TaskScheduleType.CRON,
            interval=0,
            cron_expression="0 2 * * *",
            next_run=base_time + timedelta(hours=1),
            tag="cron",
            parameters={"message": "CRON task"},
            enabled=True
        ),
        ScheduledTask(
            id="event_task",
            task_type="test_crawler",
            schedule_type=TaskScheduleType.EVENT,
            interval=0,
            event_type="new_article",
            next_run=base_time,
            tag="event",
            parameters={"message": "Event task"},
            enabled=True
        ),
        ScheduledTask(
            id="manual_task",
            task_type="test_crawler",
            schedule_type=TaskScheduleType.MANUAL,
            interval=0,
            next_run=base_time,
            tag="manual",
            parameters={"message": "Manual task"},
            enabled=True
        )
    ]
    
    # 添加测试数据到数据库和调度器
    for task in test_tasks:
        test_session.add(task)
        kTaskScheduler.tasks[task.id] = task
    await test_session.commit()
    
    # 测试API响应
    response = await async_client.get("/scheduler_tasks/")
    assert response.status_code == 200
    data = response.json()
    
    # 验证返回数据数量
    assert len(data) == 4
    
    # 验证数据中包含所有类型的任务
    task_ids = [task["id"] for task in data]
    assert "interval_task" in task_ids
    assert "cron_task" in task_ids
    assert "event_task" in task_ids
    assert "manual_task" in task_ids

@pytest.mark.asyncio
async def test_get_scheduled_tasks_parameters(app, async_client, test_session):
    """测试定时任务参数的正确性"""
    # 清理数据库
    await test_session.execute(delete(ScheduledTask))
    await test_session.commit()
    
    # 重置调度器的任务列表
    kTaskScheduler.tasks = {}
    
    # 创建具有复杂参数的测试任务
    test_task = ScheduledTask(
        id="test_task_params",
        task_type="test_crawler",
        schedule_type=TaskScheduleType.INTERVAL,
        interval=300,
        next_run=datetime.now(),
        tag="test",
        parameters={
            "message": "Test message",
            "count": 42,
            "flags": {"enabled": True, "debug": False},
            "items": ["item1", "item2", "item3"]
        },
        enabled=True
    )
    
    # 添加测试数据到数据库和调度器
    test_session.add(test_task)
    kTaskScheduler.tasks[test_task.id] = test_task
    await test_session.commit()
    
    # 测试API响应
    response = await async_client.get("/scheduler_tasks/")
    assert response.status_code == 200
    data = response.json()
    
    # 找到测试任务的数据
    task_data = next(task for task in data if task["id"] == "test_task_params")
    
    # 验证参数的完整性和类型
    assert task_data["parameters"]["message"] == "Test message"
    assert task_data["parameters"]["count"] == 42
    assert isinstance(task_data["parameters"]["flags"], dict)
    assert task_data["parameters"]["flags"]["enabled"] is True
    assert task_data["parameters"]["flags"]["debug"] is False
    assert isinstance(task_data["parameters"]["items"], list)
    assert len(task_data["parameters"]["items"]) == 3