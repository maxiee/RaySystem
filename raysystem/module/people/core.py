from typing import List, Optional
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
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
        result = await session.execute(select(People).where(People.id == people_id))
        return result.scalar_one_or_none()

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
