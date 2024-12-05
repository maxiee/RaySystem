import os
from pathlib import Path
from module.base.constants import STORAGE_MODULE_NAME
from module.data.data import get_module_data_path, make_sure_module_data_path_exists

# Layers of directories to create for storage
N = 5


def _get_root_path() -> Path:
    return get_module_data_path(STORAGE_MODULE_NAME)


def get_storage_path(bucket: str, sha256_filename: str):
    """
    Get the storage path for a given SHA256 hash.

    :param bucket: The bucket name.
    :param sha256_filename: SHA256ed File name with file extension.
    :return: Full path where the file should be stored.
    """
    path_parts = [_get_root_path().absolute(), bucket] + list(sha256_filename[:N])
    dir_path = os.path.join(*path_parts)
    if not os.path.exists(dir_path):
        os.makedirs(dir_path)
    return os.path.join(dir_path, sha256_filename)


def init_storage_module():
    make_sure_module_data_path_exists(STORAGE_MODULE_NAME)
    print("Storage module initialized")
