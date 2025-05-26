from typing import List, Optional, Tuple
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import joinedload
from sqlalchemy import func, desc
from module.people.model import People, PeopleName
from module.people.schemas import PeopleCreate, PeopleUpdate


class PeopleManager:
    @staticmethod
    async def create_people(people_data: PeopleCreate, session: AsyncSession) -> People:
        new_people = People(**people_data.dict())
        session.add(new_people)
        await session.commit()
        await session.refresh(new_people)
        return new_people

    @staticmethod
    async def get_people(people_id: int, session: AsyncSession) -> Optional[People]:
        result = await session.execute(
            select(People)
            .options(joinedload(People.names))
            .where(People.id == people_id)
        )
        return result.unique().scalar_one_or_none()

    @staticmethod
    async def get_people_paginated(
        page: int, page_size: int, session: AsyncSession
    ) -> Tuple[List[People], int]:
        """
        分页获取人物列表，按主键倒序排列

        Args:
            page: 页码，从1开始
            page_size: 每页大小
            session: 数据库会话

        Returns:
            Tuple[List[People], int]: (人物列表, 总数)
        """
        # 计算偏移量
        offset = (page - 1) * page_size

        # 查询总数
        count_result = await session.execute(select(func.count(People.id)))
        total = count_result.scalar() or 0

        # 查询分页数据，按id倒序
        result = await session.execute(
            select(People).order_by(desc(People.id)).offset(offset).limit(page_size)
        )
        people_list = list(result.scalars().all())

        return people_list, total

    @staticmethod
    async def update_people(
        people_id: int, people_data: PeopleUpdate, session: AsyncSession
    ) -> Optional[People]:
        people = await PeopleManager.get_people(people_id, session)
        if not people:
            return None
        for key, value in people_data.dict(exclude_unset=True).items():
            setattr(people, key, value)
        await session.commit()
        await session.refresh(people)
        return people

    @staticmethod
    async def delete_people(people_id: int, session: AsyncSession) -> bool:
        people = await PeopleManager.get_people(people_id, session)
        if not people:
            return False
        await session.delete(people)
        await session.commit()
        return True
