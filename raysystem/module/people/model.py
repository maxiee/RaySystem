from typing import Optional
from sqlalchemy import Integer, String, Date
from module.db.base import Base
from sqlalchemy.orm import Mapped, mapped_column


class People(Base):
    """
    人物
    """
    __tablename__ = "people"
    # 人物 id
    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    # 人物名称
    name: Mapped[Optional[str]] = mapped_column(String, index=True, nullable=True)
    # 人物名称2
    name2: Mapped[Optional[str]] = mapped_column(String, index=True, nullable=True)
    # 人物名称3
    name3: Mapped[Optional[str]] = mapped_column(String, index=True, nullable=True)
    # 人物名称4
    name4: Mapped[Optional[str]] = mapped_column(String, index=True, nullable=True)
    # 人物名称5
    name5: Mapped[Optional[str]] = mapped_column(String, index=True, nullable=True)
    # 人物描述
    description: Mapped[Optional[str]] = mapped_column(String, nullable=True)
    # 人物头像
    avatar: Mapped[Optional[str]] = mapped_column(String, nullable=True)
    # 人物出生日期
    birth_date: Mapped[Optional[Date]] = mapped_column(Date, nullable=True)
