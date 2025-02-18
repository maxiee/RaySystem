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
    site: schemas.SiteCreate, session: AsyncSession = Depends(get_db_session)
):
    db_site = Site(**site.model_dump())
    session.add(db_site)
    await session.commit()
    await session.refresh(db_site)
    return db_site

@APP.get("/sites/", response_model=List[schemas.Site])
async def read_sites(
    skip: int = 0,
    limit: int = 100,
    session: AsyncSession = Depends(get_db_session),
):
    result = await session.execute(select(Site).offset(skip).limit(limit))
    return result.scalars().all()

@APP.get("/sites/{site_id}", response_model=schemas.Site)
async def read_site(
    site_id: int, session: AsyncSession = Depends(get_db_session)
):
    result = await session.execute(select(Site).where(Site.id == site_id))
    site = result.scalar_one_or_none()
    if not site:
        raise HTTPException(status_code=404, detail="Site not found")
    return site

@APP.delete("/sites/{site_id}")
async def delete_site(
    site_id: int, session: AsyncSession = Depends(get_db_session)
):
    result = await session.execute(select(Site).where(Site.id == site_id))
    site = result.scalar_one_or_none()
    if not site:
        raise HTTPException(status_code=404, detail="Site not found")
    await session.delete(site)
    await session.commit()
    return {"ok": True}

def init_info_api():
    print("Info API initialized")