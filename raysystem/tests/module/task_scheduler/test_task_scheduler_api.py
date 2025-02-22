import pytest
from datetime import datetime, timedelta
from module.task_scheduler.model import ScheduledTask
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
async def test_get_scheduled_tasks_with_data(app, async_client, test_session):
    """测试包含数据时的定时任务列表"""
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
            interval=300,
            next_run=base_time,
            tag="test",
            parameters={"message": "Test 1"}
        ),
        ScheduledTask(
            id="test_task_2",
            task_type="ddg",
            interval=86400,
            next_run=base_time + timedelta(hours=1),
            tag="ddg",
            parameters={"query": "test query"}
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
        interval=300,
        next_run=datetime.now(),
        tag="test",
        parameters={
            "message": "Test message",
            "count": 42,
            "flags": {"enabled": True, "debug": False},
            "items": ["item1", "item2", "item3"]
        }
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