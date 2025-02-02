from typing import List
from sqlalchemy import select
from module.base.constants import INFO_MODULE_NAME
from module.db.db import db_async_session
from module.fs.fs import fs_make_sure_module_data_path_exists
from module.info.api import init_info_api
from module.info.model import Info, Site


async def info_is_site_exists_by_host(host: str) -> bool:
    """
    Check if a site exists by its host
    """
    async with db_async_session() as session:
        result = await session.execute(select(Site).where(Site.host == host))
        return result.scalar() is not None


async def info_create_site_if_not_exists_by_host(host: str) -> Site:
    """
    Create a site if not exists by its host
    """
    async with db_async_session() as session:
        result = await session.execute(select(Site).where(Site.host == host))
        site = result.scalar()
        if site is None:
            site = Site(name=host, host=host)
            session.add(site)
            await session.commit()
        return site


async def info_get_site_by_host(host: str) -> Site:
    """
    Get a site by its host

    Args:
        host: The hostname to look up

    Returns:
        Site: The found site object

    Raises:
        ValueError: If no site found for the given host
    """
    async with db_async_session() as session:
        result = await session.execute(select(Site).where(Site.host == host))
        site = result.scalar()
        if site is None:
            raise ValueError(f"No site found for host: {host}")
        return site


async def info_create_site_by_host(host: str) -> Site:
    """
    Create a site by its host

    Args:
        host: The hostname to create

    Returns:
        Site: The created site object
    """
    async with db_async_session() as session:
        db_site = Site(name=host, host=host)
        session.add(db_site)
        await session.commit()
        return db_site


async def info_is_info_exists_by_url(url: str) -> bool:
    """
    Check if an info exists by its URL
    """
    async with db_async_session() as session:
        result = await session.execute(select(Info).where(Info.url == url))
        return result.scalar() is not None


async def info_create_info(info: Info):
    async with db_async_session() as session:
        session.add(info)
        await session.commit()
        await session.refresh(info)
        return info


async def info_create_info_buck(info_list: List[Info]):
    """
    Create multiple info objects in a single transaction
    """
    async with db_async_session() as session:
        session.add_all(info_list)
        await session.commit()
        return info_list


async def info_get_by_id(info_id: int) -> Info:
    async with db_async_session() as session:
        result = await session.execute(select(Info).where(Info.id == info_id))
        info = result.scalar()
        if info is None:
            raise ValueError(f"No info found for id: {info_id}")
        return info


def init_info_module():
    # fs_make_sure_module_data_path_exists(INFO_MODULE_NAME)
    init_info_api()
    print("Info module initialized")
