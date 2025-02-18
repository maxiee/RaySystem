import pytest
from module.info.model import Site
from sqlalchemy import select
from module.info.schemas import SiteCreate

@pytest.mark.asyncio
async def test_create_site(test_session):
    """测试直接通过 SQLAlchemy 创建站点"""
    # 准备测试数据
    site = Site(
        name="Test Site",
        description="Test Description",
        host="test.com"
    )
    
    test_session.add(site)
    await test_session.flush()
    await test_session.commit()
    
    # 验证
    result = await test_session.execute(select(Site).where(Site.host == "test.com"))
    saved_site = result.scalar_one()
    
    assert saved_site.name == "Test Site"
    assert saved_site.description == "Test Description"
    assert saved_site.host == "test.com"

@pytest.mark.asyncio
async def test_create_site_api(app, async_client):
    """测试通过 API 创建站点"""
    # 准备测试数据
    site_data = SiteCreate(
        name="API Test Site",
        description="API Test Description",
        host="apitest.com",
        favicon=None,
        rss=None
    )
    
    # 发送请求
    response = await async_client.post("/sites/", json=site_data.model_dump())
    
    # 验证响应状态码和数据
    assert response.status_code == 200
    created_site = response.json()
    assert created_site["name"] == site_data.name
    assert created_site["description"] == site_data.description
    assert created_site["host"] == site_data.host
    assert "id" in created_site

@pytest.mark.asyncio
async def test_get_sites(app, async_client):
    """测试获取站点列表"""
    # 发送请求
    response = await async_client.get("/sites/")
    
    # 验证响应
    assert response.status_code == 200
    sites_list = response.json()
    assert len(sites_list) > 0  # 至少应该有一个站点
    
    # 验证返回的数据结构
    site = sites_list[0]
    assert "id" in site
    assert "name" in site
    assert "host" in site

@pytest.mark.asyncio
async def test_get_site_by_id(app, async_client, test_session):
    """测试通过 ID 获取单个站点"""
    # 准备测试数据
    site = Site(name="Test Get Site", host="testget.com")
    test_session.add(site)
    await test_session.commit()
    
    # 发送请求
    response = await async_client.get(f"/sites/{site.id}")
    
    # 验证响应
    assert response.status_code == 200
    fetched_site = response.json()
    assert fetched_site["id"] == site.id
    assert fetched_site["name"] == site.name
    assert fetched_site["host"] == site.host

@pytest.mark.asyncio
async def test_get_nonexistent_site(app, async_client):
    """测试获取不存在的站点"""
    # 使用一个不可能存在的 ID
    response = await async_client.get("/sites/99999")
    assert response.status_code == 404
    assert response.json()["detail"] == "Site not found"

@pytest.mark.asyncio
async def test_delete_site(app, async_client, test_session):
    """测试删除站点"""
    # 准备测试数据
    site = Site(name="Test Delete Site", host="testdelete.com")
    test_session.add(site)
    await test_session.commit()
    site_id = site.id
    
    # 发送删除请求
    response = await async_client.delete(f"/sites/{site_id}")
    assert response.status_code == 200
    assert response.json()["ok"] is True
    
    # 验证站点已被删除
    result = await test_session.execute(select(Site).where(Site.id == site_id))
    assert result.first() is None