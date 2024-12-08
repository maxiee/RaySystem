from datetime import datetime
from typing import Optional

from sqlmodel import Field, SQLModel, Relationship

# from peewee import *

from module.base.constants import INFO_MODULE_NAME
from module.fs.fs import fs_get_module_data_path

# info_db = SqliteDatabase(None)


# class BaseModel(Model):
#     class Meta:
#         database = info_db


# class Site(BaseModel):
#     name = CharField()
#     url = CharField()
#     favicon = BlobField(null=True)


class Site(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    name: str
    url: str
    favicon: Optional[str] = None

    infos: list["Info"] = Relationship(back_populates="site")


class Info(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    title: str
    url: str
    published: Optional[datetime] = None
    created_at: datetime = Field(default_factory=datetime.now)
    description: Optional[str] = None
    image: Optional[bytes] = None
    site_id: Optional[int] = Field(default=None, foreign_key="site.id")
    is_new: bool = Field(default=True)
    is_mark: bool = Field(default=False)

    site: Optional["Site"] = Relationship(back_populates="infos")


def init_info_model():
    pass
    # global info_db
    # info_db.init(fs_get_module_data_path(INFO_MODULE_NAME) / "info.db")
    # info_db.connect()
    # info_db.create_tables([Site, Info])
