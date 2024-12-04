from peewee import *

from module.base.constants import INFO_MODULE_NAME
from module.data.data import get_module_data_path

info_db = None


class BaseModel(Model):
    class Meta:
        database = info_db


def init_info_model():
    info_db = SqliteDatabase(get_module_data_path(INFO_MODULE_NAME) / "info.db")
    info_db.connect()
