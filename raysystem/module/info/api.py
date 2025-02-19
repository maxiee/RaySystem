# Site CRUD operations
from datetime import datetime
from sqlalchemy import select, desc, func
from module.http.http import APP
import module.info.schemas as schemas
from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import HTTPException, Depends, Query
from module.db.db import get_db_session
from typing import List, Optional
from module.http.http import APP
from module.info.model import Site, Info  # Added Info import

# Site endpoints
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

# Info endpoints
@APP.get("/infos/", response_model=schemas.InfoList)
async def get_infos(
    created_before: Optional[datetime] = Query(None, description="Optional timestamp to get items created before this time"),
    limit: int = Query(20, ge=1, le=100, description="Number of items to return per page"),
    session: AsyncSession = Depends(get_db_session)
):
    """
    Get a paginated list of info items.
    
    Args:
        created_before: Optional timestamp to get items created before this time
        limit: Number of items to return (max 100)
        session: Database session
    
    Returns:
        InfoList containing the items, total count, and whether there are more items
    """
    # Build base query
    query = select(Info).order_by(desc(Info.created_at))
    
    # Add created_before filter if provided
    if created_before:
        query = query.where(Info.created_at < created_before)
    
    # Execute query with limit
    result = await session.execute(query.limit(limit + 1))  # Get one extra to check if there are more
    items = result.scalars().all()
    
    # Check if there are more items
    has_more = len(items) > limit
    if has_more:
        items = items[:limit]  # Remove the extra item
        
    # Get total count
    count_query = select(func.count()).select_from(Info)
    total_result = await session.execute(count_query)
    total = total_result.scalar() or 0  # Ensure total is not None
    
    return schemas.InfoList(
        items=[schemas.InfoResponse.from_orm(item) for item in items],
        total=total,
        has_more=has_more
    )

def init_info_api():
    print("Info API initialized")