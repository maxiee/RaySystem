from typing import Optional, List
from pydantic import BaseModel, ConfigDict
from datetime import datetime

class InfoBase(BaseModel):
    title: str
    url: str
    published: Optional[datetime] = None
    description: Optional[str] = None
    image: Optional[str] = None
    is_new: bool
    is_mark: bool

class InfoCreate(InfoBase):
    site_id: int
    channel_id: Optional[int] = None
    subchannel_id: Optional[int] = None

class InfoUpdate(BaseModel):
    title: Optional[str] = None
    url: Optional[str] = None
    published: Optional[datetime] = None
    description: Optional[str] = None
    image: Optional[str] = None
    is_new: Optional[bool] = None
    is_mark: Optional[bool] = None

    model_config = ConfigDict(from_attributes=True)

class InfoResponse(BaseModel):
    id: int
    title: str
    url: str
    published: Optional[datetime] = None
    created_at: datetime
    description: Optional[str] = None
    image: Optional[str] = None
    is_new: bool
    is_mark: bool
    site_id: int
    channel_id: Optional[int] = None
    subchannel_id: Optional[int] = None
    storage_html: Optional[str] = None

    model_config = ConfigDict(from_attributes=True)

class InfoList(BaseModel):
    items: List[InfoResponse]
    total: int
    has_more: bool

    model_config = ConfigDict(from_attributes=True)

class Info(InfoBase):
    id: int
    created_at: datetime
    site_id: int
    channel_id: Optional[int] = None
    subchannel_id: Optional[int] = None

    model_config = ConfigDict(from_attributes=True)

class InfoStats(BaseModel):
    total_count: int
    unread_count: int
    marked_count: int

    model_config = ConfigDict(from_attributes=True)

class SubChannelBase(BaseModel):
    name: str
    url: Optional[str] = None
    rss: Optional[str] = None

class SubChannelCreate(SubChannelBase):
    channel_id: int

class SubChannelUpdate(BaseModel):
    name: Optional[str] = None
    url: Optional[str] = None
    rss: Optional[str] = None

    model_config = ConfigDict(from_attributes=True)

class SubChannel(SubChannelBase):
    id: int
    channel_id: int

    model_config = ConfigDict(from_attributes=True)

class ChannelBase(BaseModel):
    name: str
    url: Optional[str] = None
    rss: Optional[str] = None

class ChannelCreate(ChannelBase):
    site_id: int

class ChannelUpdate(BaseModel):
    name: Optional[str] = None
    url: Optional[str] = None
    rss: Optional[str] = None

    model_config = ConfigDict(from_attributes=True)

class Channel(ChannelBase):
    id: int
    site_id: int

    model_config = ConfigDict(from_attributes=True)

class SiteBase(BaseModel):
    name: str
    description: Optional[str] = None
    host: str
    favicon: Optional[str] = None
    rss: Optional[str] = None

class SiteCreate(SiteBase):
    pass

class SiteUpdate(BaseModel):
    id: int
    name: Optional[str] = None
    description: Optional[str] = None
    url: Optional[str] = None
    favicon: Optional[str] = None
    rss: Optional[str] = None

class Site(SiteBase):
    id: int

    model_config = ConfigDict(from_attributes=True)

