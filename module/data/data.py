from pathlib import Path

# Where the data of RaySystem is stored
# Default data path
data_path = Path("~/RaySystem")


def set_data_path(path: str):
    global data_path
    data_path = Path(path)


def get_data_path() -> Path:
    return data_path


def init_data_module():
    # Create the data directory if it doesn't exist
    data_path.mkdir(exist_ok=True)
    print("Data module initialized")
