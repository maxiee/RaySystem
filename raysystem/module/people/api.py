from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from sqlalchemy.orm import joinedload
from typing import List
from module.db.db import get_db_session
from module.people.core import PeopleManager
from module.people.schemas import (
    PeopleCreate,
    PeopleResponse,
    PeopleUpdate,
    PeopleNameCreate,
    PeopleNameResponse,
)
from module.people.model import People, PeopleName

router = APIRouter(prefix="/people", tags=["people"])


@router.post("/", response_model=PeopleResponse)
async def create_people(
    people_data: PeopleCreate, session: AsyncSession = Depends(get_db_session)
):
    new_people = await PeopleManager.create_people(people_data, session)
    # 新创建的人物对象还没有名称，直接使用空列表
    # 创建一个字典，排除names字段以避免重复参数
    people_dict = {k: v for k, v in new_people.__dict__.items() if k != "names"}
    return PeopleResponse(**people_dict, names=[])


@router.get("/search", response_model=List[PeopleResponse])
async def search_people(name: str, session: AsyncSession = Depends(get_db_session)):
    # Step 1: Perform a case-insensitive search in PeopleName table
    result = await session.execute(
        select(PeopleName).where(PeopleName.name.ilike(f"%{name}%"))
    )
    people_name_results = result.scalars().all()

    # Step 2: Extract unique People IDs from the search results
    people_ids = {name.people_id for name in people_name_results}

    if not people_ids:
        return []

    # Step 3: Query People table without joinedload
    result = await session.execute(select(People).where(People.id.in_(people_ids)))
    people_results = result.scalars().all()

    # Step 4: Construct the response
    response = []
    for person in people_results:
        # 获取每个人物的名称记录
        person_names_result = await session.execute(
            select(PeopleName).where(PeopleName.people_id == person.id)
        )
        name_records = person_names_result.scalars().all()
        names_list = []
        for name_record in name_records:
            names_list.append(
                PeopleNameResponse(
                    id=name_record.id,
                    people_id=name_record.people_id,
                    name=name_record.name,
                )
            )

        # 创建一个字典，排除names字段以避免重复参数
        person_dict = {k: v for k, v in person.__dict__.items() if k != "names"}
        response.append(PeopleResponse(**person_dict, names=names_list))

    return response


@router.get("/{people_id}", response_model=PeopleResponse)
async def get_people(people_id: int, session: AsyncSession = Depends(get_db_session)):
    people = await PeopleManager.get_people(people_id, session)
    if not people:
        raise HTTPException(status_code=404, detail="People not found")

    # 单独查询名称以避免延迟加载错误
    result = await session.execute(
        select(PeopleName).where(PeopleName.people_id == people_id)
    )
    name_records = result.scalars().all()
    names_list = []
    for name in name_records:
        names_list.append(
            PeopleNameResponse(id=name.id, people_id=name.people_id, name=name.name)
        )

    # 创建一个字典，排除names字段以避免重复参数
    people_dict = {k: v for k, v in people.__dict__.items() if k != "names"}
    return PeopleResponse(**people_dict, names=names_list)


@router.put("/{people_id}", response_model=PeopleResponse)
async def update_people(
    people_id: int,
    people_data: PeopleUpdate,
    session: AsyncSession = Depends(get_db_session),
):
    updated_people = await PeopleManager.update_people(people_id, people_data, session)
    if not updated_people:
        raise HTTPException(status_code=404, detail="People not found")

    # 单独查询名称以避免延迟加载错误
    result = await session.execute(
        select(PeopleName).where(PeopleName.people_id == people_id)
    )
    name_records = result.scalars().all()
    names_list = []
    for name in name_records:
        names_list.append(
            PeopleNameResponse(id=name.id, people_id=name.people_id, name=name.name)
        )

    # 创建一个字典，排除names字段以避免重复参数
    people_dict = {k: v for k, v in updated_people.__dict__.items() if k != "names"}
    return PeopleResponse(**people_dict, names=names_list)


@router.delete("/{people_id}", response_model=bool)
async def delete_people(
    people_id: int, session: AsyncSession = Depends(get_db_session)
):
    success = await PeopleManager.delete_people(people_id, session)
    if not success:
        raise HTTPException(status_code=404, detail="People not found")
    return success


@router.post("/{people_id}/names", response_model=PeopleNameResponse)
async def create_people_name(
    people_id: int,
    name_data: PeopleNameCreate,
    session: AsyncSession = Depends(get_db_session),
):
    new_name = PeopleName(people_id=people_id, **name_data.dict())
    session.add(new_name)
    await session.commit()
    await session.refresh(new_name)
    return new_name


@router.get("/{people_id}/names", response_model=List[PeopleNameResponse])
async def get_people_names(
    people_id: int, session: AsyncSession = Depends(get_db_session)
):
    result = await session.execute(
        select(PeopleName).where(PeopleName.people_id == people_id)
    )
    return result.scalars().all()


@router.delete("/names/{name_id}", response_model=bool)
async def delete_people_name(
    name_id: int, session: AsyncSession = Depends(get_db_session)
):
    result = await session.execute(select(PeopleName).where(PeopleName.id == name_id))
    name = result.scalar_one_or_none()
    if not name:
        raise HTTPException(status_code=404, detail="Name not found")
    await session.delete(name)
    await session.commit()
    return True


@router.put("/names/{name_id}", response_model=PeopleNameResponse)
async def update_people_name(
    name_id: int,
    name_data: PeopleNameCreate,
    session: AsyncSession = Depends(get_db_session),
):
    result = await session.execute(select(PeopleName).where(PeopleName.id == name_id))
    name = result.scalar_one_or_none()
    if not name:
        raise HTTPException(status_code=404, detail="Name not found")
    for key, value in name_data.dict(exclude_unset=True).items():
        setattr(name, key, value)
    await session.commit()
    await session.refresh(name)
    return name
