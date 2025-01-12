from module.base.constants import INFO_MODULE_NAME
from module.db.db import db_async_session
from module.fs.fs import fs_make_sure_module_data_path_exists
from module.info.api import init_info_api
from module.info.model import Site

async def info_is_site_exists_by_host(host: str) -> bool:
    """
    Check if a site exists by its host
    """
    async with db_async_session() as session:
        db_site = await session.get(Site, host)
        return db_site is not None    

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
        db_site = await session.get(Site, host)
        if db_site is None:
            raise ValueError(f"No site found for host: {host}")
        return db_site

async def info_create_site_by_host(host: str) -> Site:
    """
    Create a site by its host
    
    Args:
        host: The hostname to create
        
    Returns:
        Site: The created site object
    """
    async with db_async_session() as session:
        db_site = Site(
            name=host,
            host=host)
        session.add(db_site)
        await session.commit()
        return db_site

def init_info_module():
    # fs_make_sure_module_data_path_exists(INFO_MODULE_NAME)
    init_info_api()
    print("Info module initialized")