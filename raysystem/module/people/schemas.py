from typing import List, Optional
from pydantic import BaseModel, validator
from datetime import date


class PeopleNameBase(BaseModel):
    name: str


class PeopleNameCreate(PeopleNameBase):
    pass


class PeopleNameResponse(PeopleNameBase):
    id: int
    people_id: int

    class Config:
        from_attributes = True


class PeopleBase(BaseModel):
    description: Optional[str] = None
    avatar: Optional[str] = None
    birth_date: Optional[date] = None


class PeopleCreate(PeopleBase):
    pass


class PeopleUpdate(PeopleBase):
    pass


class PeopleResponse(PeopleBase):
    id: int
    names: List[PeopleNameResponse] = []

    class Config:
        from_attributes = True
