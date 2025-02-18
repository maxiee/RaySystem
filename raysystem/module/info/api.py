# Site CRUD operations
from sqlalchemy import select
from module.http.http import APP
import module.info.schemas as schemas
from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import HTTPException, Depends
from module.db.db import get_db_session
from typing import List
from module.http.http import APP
from module.info.model import Site

@APP.post("/sites/", response_model=schemas.Site)
async def create_site(
    site: schemas.SiteCreate, async_session: AsyncSession = Depends(get_db_session)
):
    async with async_session as session:
        db_site = Site(**site.dict())
        session.add(db_site)
        await session.commit()
        await session.refresh(db_site)
        return schemas.Site.from_orm(db_site)


@APP.get("/sites/", response_model=List[schemas.Site])
async def read_sites(
    skip: int = 0,
    limit: int = 100,
    async_session: AsyncSession = Depends(get_db_session),
):
    async with async_session as session:
        result = await session.execute(select(Site).offset(skip).limit(limit))
        sites = result.all()
        return sites


@APP.get("/sites/{site_id}", response_model=schemas.Site)
async def read_site(
    site_id: int, async_session: AsyncSession = Depends(get_db_session)
):
    async with async_session as session:
        site = session.get(Site, site_id)
        if not site:
            raise HTTPException(status_code=404, detail="Site not found")
        return site


# @APP.put("/sites/{site_id}", response_model=schemas.Site)
# async def update_site(
#     site: schemas.SiteUpdate, async_session: AsyncSession = Depends(get_db_session)
# ):
#     async with async_session as session:
#         db_site = session.get(Site, site_id)
#         if not db_site:
#             raise HTTPException(status_code=404, detail="Site not found")

#         site_data = site.dict(exclude_unset=True)ﬁ
#         for key, value in site_data.items():
#             setattr(db_site, key, value)

#         session.add(db_site)
#         await session.commit()
#         await session.refresh(db_site)
#         return db_site


@APP.delete("/sites/{site_id}")
async def delete_site(
    site_id: int, async_session: AsyncSession = Depends(get_db_session)
):
    async with async_session as session:
        site = session.get(Site, site_id)
        if not site:
            raise HTTPException(status_code=404, detail="Site not found")

        await session.delete(site)
        await session.commit()
        return {"ok": True}

def init_info_api():
    print("Info API initialized")