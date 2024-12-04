from utils.config import load_config_file
from module.data.data import init_data_module, set_data_path


def main():
    print("RaySystem starting...")
    init_config()
    # module initialization
    init_data_module()


def init_config():
    config_file = load_config_file()
    print(config_file)
    if "data_path" in config_file:
        set_data_path(config_file["data_path"])


if __name__ == "__main__":
    main()
