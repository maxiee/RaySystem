from module.base.constants import STORAGE_MODULE_NAME
from module.data.data import make_sure_module_data_path_exists


def init_storage_module():
    make_sure_module_data_path_exists(STORAGE_MODULE_NAME)
    print("Storage module initialized")
