import yaml
import os.path


def load_config() -> dict:
    """Load configuration from ~/.RaySystemConfig.yaml"""
    config_path = os.path.expanduser("~/.RaySystemConfig.yaml")
    try:
        with open(config_path, "r") as f:
            return yaml.safe_load(f)
    except FileNotFoundError:
        return {}
    except yaml.YAMLError as e:
        print(f"Error parsing config file: {e}")
        return {}
