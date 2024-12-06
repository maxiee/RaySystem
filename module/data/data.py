from pathlib import Path

# Where the data of RaySystem is stored
# Default data path
data_path = Path.home() / "RaySystem"


def set_data_path(path: str):
    global data_path
    data_path = Path(path).expanduser()


def get_data_path() -> Path:
    return data_path


def get_module_data_path(module_name: str) -> Path:
    return data_path / module_name


def make_sure_module_data_path_exists(module_name: str):
    module_data_path = get_module_data_path(module_name)
    module_data_path.mkdir(exist_ok=True)


def init_data_module():
    # Create the data directory if it doesn't exist
    data_path.mkdir(exist_ok=True)
    print("Data module initialized")
