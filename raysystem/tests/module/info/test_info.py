import pytest
from datetime import datetime, timedelta
from module.info.model import Info, Site
from sqlalchemy import select, delete

@pytest.mark.asyncio
async def test_get_infos_empty(app, async_client, test_session):
    """测试获取空的信息列表"""
    # 清理数据库
    await test_session.execute(delete(Info))
    await test_session.execute(delete(Site))
    await test_session.commit()
    
    response = await async_client.get("/infos/")
    assert response.status_code == 200
    data = response.json()
    assert data["total"] == 0
    assert data["items"] == []
    assert data["has_more"] == False

@pytest.mark.asyncio
async def test_get_infos_pagination(app, async_client, test_session):
    """测试信息列表分页"""
    # 清理数据库
    await test_session.execute(delete(Info))
    await test_session.execute(delete(Site))
    await test_session.commit()
    
    # 准备测试数据
    site = Site(name="Test Pagination Site", host="test-pagination.com")
    test_session.add(site)
    await test_session.flush()
    
    # 创建25条测试数据，时间间隔1分钟
    base_time = datetime.now()
    for i in range(25):
        info = Info(
            title=f"Test Info {i}",
            url=f"https://test-pagination.com/info/{i}",
            site_id=site.id,
            created_at=base_time - timedelta(minutes=i),
            is_new=True,
            is_mark=False
        )
        test_session.add(info)
    await test_session.commit()
    
    # 测试第一页（默认20条）
    response = await async_client.get("/infos/")
    assert response.status_code == 200
    data = response.json()
    assert len(data["items"]) == 20
    assert data["total"] == 25
    assert data["has_more"] == True
    
    # 验证返回的数据格式
    first_item = data["items"][0]
    assert isinstance(first_item["id"], int)
    assert isinstance(first_item["title"], str)
    assert isinstance(first_item["url"], str)
    assert isinstance(first_item["created_at"], str)
    
    # 获取最后一条数据的创建时间
    last_created_at = data["items"][-1]["created_at"]
    
    # 测试第二页
    response = await async_client.get(f"/infos/?created_before={last_created_at}")
    assert response.status_code == 200
    data = response.json()
    assert len(data["items"]) == 5
    assert data["total"] == 25
    assert data["has_more"] == False

@pytest.mark.asyncio
async def test_get_infos_limit(app, async_client, test_session):
    """测试自定义限制数量"""
    # 清理数据库
    await test_session.execute(delete(Info))
    await test_session.execute(delete(Site))
    await test_session.commit()
    
    # 准备测试数据
    site = Site(name="Test Limit Site", host="test-limit.com")
    test_session.add(site)
    await test_session.flush()
    
    # 创建10条测试数据
    base_time = datetime.now()
    for i in range(10):
        info = Info(
            title=f"Test Info {i}",
            url=f"https://test-limit.com/info/{i}",
            site_id=site.id,
            created_at=base_time - timedelta(minutes=i),
            is_new=True,
            is_mark=False
        )
        test_session.add(info)
    await test_session.commit()
    
    # 测试限制返回5条数据
    response = await async_client.get("/infos/?limit=5")
    assert response.status_code == 200
    data = response.json()
    assert len(data["items"]) == 5
    assert data["total"] == 10
    assert data["has_more"] == True
    
    # 验证数据排序（按创建时间降序）
    items = data["items"]
    for i in range(len(items) - 1):
        curr_time = datetime.fromisoformat(items[i]["created_at"])
        next_time = datetime.fromisoformat(items[i + 1]["created_at"])
        assert curr_time > next_time

@pytest.mark.asyncio
async def test_get_infos_invalid_limit(app, async_client):
    """测试无效的limit参数"""
    # 测试超出最大限制
    response = await async_client.get("/infos/?limit=101")
    assert response.status_code == 422  # FastAPI validation error
    
    # 测试负数限制
    response = await async_client.get("/infos/?limit=-1")
    assert response.status_code == 422  # FastAPI validation error
    
    # 测试零值限制
    response = await async_client.get("/infos/?limit=0")
    assert response.status_code == 422  # FastAPI validation error

@pytest.mark.asyncio
async def test_get_info_stats_empty(app, async_client, test_session):
    """测试空数据库的统计信息"""
    # 清理数据库
    await test_session.execute(delete(Info))
    await test_session.execute(delete(Site))
    await test_session.commit()
    
    response = await async_client.get("/infos/stats")
    assert response.status_code == 200
    data = response.json()
    assert data["total_count"] == 0
    assert data["unread_count"] == 0
    assert data["marked_count"] == 0

@pytest.mark.asyncio
async def test_get_info_stats_with_data(app, async_client, test_session):
    """测试包含数据时的统计信息"""
    # 清理数据库
    await test_session.execute(delete(Info))
    await test_session.execute(delete(Site))
    await test_session.commit()
    
    # 准备测试数据
    site = Site(name="Test Stats Site", host="test-stats.com")
    test_session.add(site)
    await test_session.flush()
    
    # 创建10条测试数据，包括:
    # - 5条未读，5条已读
    # - 3条收藏，7条未收藏
    base_time = datetime.now()
    for i in range(10):
        info = Info(
            title=f"Test Info {i}",
            url=f"https://test-stats.com/info/{i}",
            site_id=site.id,
            created_at=base_time - timedelta(minutes=i),
            is_new=(i < 5),  # 前5条是未读
            is_mark=(i < 3)  # 前3条是收藏
        )
        test_session.add(info)
    await test_session.commit()
    
    # 测试统计结果
    response = await async_client.get("/infos/stats")
    assert response.status_code == 200
    data = response.json()
    assert data["total_count"] == 10
    assert data["unread_count"] == 5
    assert data["marked_count"] == 3