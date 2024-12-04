from datetime import datetime
from peewee import *

from module.base.constants import INFO_MODULE_NAME
from module.data.data import get_module_data_path

info_db = SqliteDatabase(None)


class BaseModel(Model):
    class Meta:
        database = info_db


class Site(BaseModel):
    name = CharField()
    url = CharField()
    favicon = BlobField(null=True)


class Info(BaseModel):
    title = CharField()
    url = CharField()
    published = DateTimeField(null=True)
    created_at = DateTimeField(default=datetime.now)
    description = TextField(null=True)
    image = BlobField(null=True)
    site = ForeignKeyField(Site, backref="infos")
    # is_new: True if the info is new
    is_new = BooleanField(default=True)
    # is_mark: True if the info is marked
    is_mark = BooleanField(default=False)


def init_info_model():
    global info_db
    info_db.init(get_module_data_path(INFO_MODULE_NAME) / "info.db")
    info_db.connect()
    info_db.create_tables([Site, Info])
