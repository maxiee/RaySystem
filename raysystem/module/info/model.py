from datetime import datetime
from typing import Optional

from sqlalchemy import table
from sqlmodel import Field, SQLModel, Relationship


class Site(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    name: str
    description: Optional[str] = None
    url: str
    favicon: Optional[str] = None
    rss: Optional[str] = None

    infos: list["Info"] = Relationship(back_populates="site")
    channels: list["Channel"] = Relationship(back_populates="site")

class Channel(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    name: str
    url: Optional[str] = None
    site_id: Optional[int] = Field(default=None, foreign_key="site.id")
    rss: Optional[str] = None
    
    site: Optional["Site"] = Relationship(back_populates="channels")
    
    infos: list["Info"] = Relationship(back_populates="channel")


class Info(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    title: str
    url: str
    published: Optional[datetime] = None
    created_at: datetime = Field(default_factory=datetime.now)
    description: Optional[str] = None
    image: Optional[bytes] = None
    site_id: Optional[int] = Field(default=None, foreign_key="site.id")
    channel_id: Optional[int] = Field(default=None, foreign_key="channel.id")
    is_new: bool = Field(default=True)
    is_mark: bool = Field(default=False)

    site: Optional["Site"] = Relationship(back_populates="infos")
    channel: Optional["Channel"] = Relationship(back_populates="infos")


