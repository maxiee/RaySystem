import asyncio
from typing import AsyncGenerator, Generator
import pytest
import pytest_asyncio
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
from fastapi import FastAPI
from httpx import AsyncClient, ASGITransport
from module.db.base import Base
from module.http.http import APP
from module.db.db import get_db_session
from module.info.api import init_info_api

# 使用内存数据库进行测试
TEST_DATABASE_URL = "sqlite+aiosqlite:///:memory:"

@pytest_asyncio.fixture(scope="session")
async def app() -> FastAPI:
    """创建测试应用"""
    # 确保 API 路由已初始化
    init_info_api()
    return APP

@pytest_asyncio.fixture(scope="session")
async def test_engine():
    """创建测试引擎"""
    engine = create_async_engine(
        TEST_DATABASE_URL,
        echo=True,
        future=True
    )
    
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    
    yield engine
    
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)
    
    await engine.dispose()

@pytest_asyncio.fixture(scope="session")
async def test_session_maker(test_engine):
    """创建测试会话工厂"""
    async_session = sessionmaker(
        test_engine, 
        class_=AsyncSession, 
        expire_on_commit=False
    )
    return async_session

@pytest_asyncio.fixture
async def test_session(test_session_maker) -> AsyncGenerator[AsyncSession, None]:
    """创建测试会话"""
    async with test_session_maker() as session:
        yield session
        await session.rollback()

@pytest_asyncio.fixture
async def async_client(app: FastAPI, test_session_maker) -> AsyncGenerator[AsyncClient, None]:
    """创建异步测试客户端"""
    async def override_get_db():
        async with test_session_maker() as session:
            yield session

    app.dependency_overrides[get_db_session] = override_get_db
    
    transport = ASGITransport(app=app)
    async with AsyncClient(
        transport=transport,
        base_url="http://testserver",
        follow_redirects=True
    ) as ac:
        yield ac
    
    app.dependency_overrides.clear()