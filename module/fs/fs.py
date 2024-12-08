from pathlib import Path

# Where the data of RaySystem is stored
# Default data path
data_path = Path.home() / "RaySystem"


def fs_set_data_path(path: str):
    global data_path
    data_path = Path(path).expanduser()


def fs_get_data_path() -> Path:
    return data_path


def fs_get_module_data_path(module_name: str) -> Path:
    return data_path / module_name


def fs_make_sure_module_data_path_exists(module_name: str):
    module_data_path = fs_get_module_data_path(module_name)
    module_data_path.mkdir(exist_ok=True)


def init_fs_module():
    # Create the data directory if it doesn't exist
    data_path.mkdir(exist_ok=True)
    print("Data module initialized")
