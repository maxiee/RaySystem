from module.base.constants import INFO_MODULE_NAME
from module.fs.fs import fs_make_sure_module_data_path_exists
from module.info.model import init_info_model


def init_info_module():
    fs_make_sure_module_data_path_exists(INFO_MODULE_NAME)
    init_info_model()
    print("Info module initialized")
