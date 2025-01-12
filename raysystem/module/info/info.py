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


def init_info_module():
    # fs_make_sure_module_data_path_exists(INFO_MODULE_NAME)
    init_info_api()
    print("Info module initialized")