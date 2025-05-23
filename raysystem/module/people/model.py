from typing import Optional
from sqlalchemy import Integer, String, Date, ForeignKey
from module.db.base import Base
from sqlalchemy.orm import Mapped, mapped_column, relationship
from datetime import date


class PeopleName(Base):
    """
    人物名称表
    """

    __tablename__ = "people_name"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    people_id: Mapped[int] = mapped_column(ForeignKey("people.id"), nullable=False)
    name: Mapped[str] = mapped_column(String, index=True, nullable=False)

    # Relationship with People
    people = relationship("People", back_populates="names")


class People(Base):
    """
    人物
    """

    __tablename__ = "people"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    description: Mapped[Optional[str]] = mapped_column(String, nullable=True)
    avatar: Mapped[Optional[str]] = mapped_column(String, nullable=True)
    birth_date: Mapped[Optional[date]] = mapped_column(Date, nullable=True)

    # Relationship with PeopleName
    names = relationship(
        "PeopleName", back_populates="people", cascade="all, delete-orphan"
    )
