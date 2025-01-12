from datetime import datetime
from typing import Optional, List

from sqlalchemy import Integer, String, ForeignKey, DateTime, Boolean, LargeBinary
from sqlalchemy.orm import Mapped, mapped_column, relationship

from module.db.base import Base

class Site(Base):
    """
    站点
    """
    __tablename__ = "site"
    # 站点 id
    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    # 站点名称
    name: Mapped[str] = mapped_column(String, index=True)
    # 站点描述
    description: Mapped[Optional[str]] = mapped_column(String, nullable=True)
    # 站点 host
    host: Mapped[str] = mapped_column(String, index=True)
    # 站点图标
    favicon: Mapped[Optional[str]] = mapped_column(String, nullable=True)
    # 站点 rss
    rss: Mapped[Optional[str]] = mapped_column(String, nullable=True)
    # 站点下的资讯
    infos: Mapped[list["Info"]] = relationship(
        back_populates="site",
        cascade="all, delete-orphan")
    # 站点下的频道
    channels: Mapped[list["Channel"]] = relationship(
        back_populates="site",
        cascade="all, delete-orphan")
    
class Channel(Base):
    """
    频道
    """
    __tablename__ = "channel"
    # 频道 id
    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    # 频道名称
    name: Mapped[str] = mapped_column(String, index=True)
    # 频道 url
    url: Mapped[Optional[str]] = mapped_column(String, nullable=True)
    # 频道对应的站点 id
    site_id: Mapped[int] = mapped_column(Integer, ForeignKey("site.id"))
    # 频道对应的站点
    site: Mapped["Site"] = relationship(back_populates="channels")
    # 频道 rss
    rss: Mapped[Optional[str]] = mapped_column(String, nullable=True)
    # 频道下的资讯
    infos: Mapped[list["Info"]] = relationship(
        back_populates="channel",
        cascade="all, delete-orphan")
    # 频道下的子频道
    subchannels: Mapped[list["SubChannel"]] = relationship(
        back_populates="channel",
        cascade="all, delete-orphan")

class SubChannel(Base):
    """
    子频道
    """
    __tablename__ = "subchannel"
    # 子频道 id
    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    # 子频道名称
    name: Mapped[str] = mapped_column(String, index=True)
    # 子频道 url
    url: Mapped[Optional[str]] = mapped_column(String, nullable=True)
    # 子频道对应的频道 id
    rss: Mapped[Optional[str]] = mapped_column(String, nullable=True)
    # 子频道对应的频道 id
    channel_id: Mapped[int] = mapped_column(Integer, ForeignKey("channel.id"))
    # 子频道对应的频道
    channel: Mapped[Optional["Channel"]] = relationship(back_populates="subchannels")
    # 子频道下的资讯
    infos: Mapped[list["Info"]] = relationship(
        back_populates="subchannel",
        cascade="all, delete-orphan")


class Info(Base):
    """
    资讯
    """
    __tablename__ = "info"
    # 资讯 id
    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    # 资讯标题
    title: Mapped[str] = mapped_column(String, index=True)
    # 资讯 url
    url: Mapped[str] = mapped_column(String, index=True)
    # 资讯发布时间
    published: Mapped[Optional[datetime]] = mapped_column(DateTime, nullable=True)
    # 资讯创建时间
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.now)
    # 资讯描述
    description: Mapped[Optional[str]] = mapped_column(String, nullable=True)
    # 资讯头图
    image: Mapped[Optional[str]] = mapped_column(String, nullable=True)
    # 是否是新资讯（未读）
    is_new: Mapped[bool] = mapped_column(Boolean, default=True)
    # 是否是收藏资讯
    is_mark: Mapped[bool] = mapped_column(Boolean, default=False)
    # 资讯对应站点 id
    site_id: Mapped[int] = mapped_column(Integer, ForeignKey("site.id"))
    # 资讯对应站点
    site: Mapped["Site"] = relationship(back_populates="infos")
    # 资讯对应频道 id
    channel_id: Mapped[Optional[int]] = mapped_column(Integer, ForeignKey("channel.id"), nullable=True)
    # 资讯对应频道
    channel: Mapped[Optional["Channel"]] = relationship(back_populates="infos")
    # 资讯对应子频道 id
    subchannel_id: Mapped[Optional[int]] = mapped_column(Integer, ForeignKey("subchannel.id"), nullable=True)
    # 资讯对应子频道
    subchannel: Mapped[Optional["SubChannel"]] = relationship(back_populates="infos")
    # storage 模块存储路径，协议 `"storage://" + bucket + ":" + sha256_filename`
    storage_html: Mapped[Optional[str]] = mapped_column(String, nullable=True)
