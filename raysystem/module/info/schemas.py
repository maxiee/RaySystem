from typing import Optional, List
from pydantic import BaseModel
from datetime import datetime

class InfoBase(BaseModel):
    title: str
    url: str
    published: Optional[datetime]
    description: Optional[str]
    image: Optional[str]
    is_new: bool
    is_mark: bool

class InfoCreate(InfoBase):
    site_id: int
    channel_id: Optional[int]
    subchannel_id: Optional[int]

class InfoUpdate(InfoBase):
    title: Optional[str]
    url: Optional[str]
    published: Optional[datetime]
    description: Optional[str]
    image: Optional[str]
    is_new: Optional[bool]
    is_mark: Optional[bool]

class Info(InfoBase):
    id: int
    created_at: datetime
    site_id: int
    channel_id: Optional[int]
    subchannel_id: Optional[int]

    class Config:
        orm_mode: True

class SubChannelBase(BaseModel):
    name: str
    url: Optional[str]
    rss: Optional[str]

class SubChannelCreate(SubChannelBase):
    channel_id: int

class SubChannelUpdate(SubChannelBase):
    name: Optional[str]
    url: Optional[str]
    rss: Optional[str]

class SubChannel(SubChannelBase):
    id: int
    channel_id: int

    class Config:
        orm_mode: True

class ChannelBase(BaseModel):
    name: str
    url: Optional[str]
    rss: Optional[str]

class ChannelCreate(ChannelBase):
    site_id: int

class ChannelUpdate(ChannelBase):
    name: Optional[str]
    url: Optional[str]
    rss: Optional[str]

class Channel(ChannelBase):
    id: int
    site_id: int

    class Config:
        orm_mode: True

class SiteBase(BaseModel):
    name: str
    description: Optional[str]
    url: str
    favicon: Optional[str]
    rss: Optional[str]

class SiteCreate(SiteBase):
    pass

class SiteUpdate(SiteBase):
    id: int
    name: Optional[str]
    description: Optional[str]
    url: Optional[str]
    favicon: Optional[str]
    rss: Optional[str]

class Site(SiteBase):
    id: int

    class Config:
        orm_mode: True

