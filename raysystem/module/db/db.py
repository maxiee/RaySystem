from pathlib import Path
from typing import AsyncGenerator, Union

from module.base.constants import DB_MODULE_NAME
from module.db.base import Base
from module.fs.fs import fs_get_module_data_path, fs_make_sure_module_data_path_exists
from sqlalchemy.ext.asyncio import AsyncEngine, create_async_engine, async_sessionmaker
from sqlalchemy.ext.asyncio import AsyncSession


DB_ENGINE: Union[AsyncEngine, None] = None

def db_get_db_path() -> Path:
    return fs_get_module_data_path(DB_MODULE_NAME) / "db.sqlite3"

async def get_db_session() -> AsyncGenerator[AsyncSession, None]:
    session = db_async_session()
    try:
        yield session
    finally:
        await session.close()

def db_async_session() -> AsyncSession:
    return async_sessionmaker(DB_ENGINE, class_=AsyncSession, expire_on_commit=False)()


async def init_db():
    global DB_ENGINE
    # Create the data directory if it doesn't exist
    fs_make_sure_module_data_path_exists(DB_MODULE_NAME)
    DB_ENGINE = create_async_engine(f"sqlite+aiosqlite:///{db_get_db_path()}")
    async with DB_ENGINE.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    print("DB module initialized")
    # async with db_async_session() as session:
    #     site = Site(name="新浪微博", url="https://weibo.com")
    #     session.add(site)
    #     await session.commit()
    #     print("Site added")
