from module.data.data import make_sure_module_data_path_exists


INFO_MODULE_NAME = "info"


def init_info_module():
    make_sure_module_data_path_exists(INFO_MODULE_NAME)
    print("Info module initialized")
