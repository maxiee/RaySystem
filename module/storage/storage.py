import os
from pathlib import Path
import shutil
from urllib.parse import urlparse
from module.base.constants import STORAGE_MODULE_NAME
from module.data.data import get_module_data_path, make_sure_module_data_path_exists
from utils.file import compute_sha256_from_bytes, compute_sha256_from_file

# Layers of directories to create for storage
N = 5


def _get_root_path() -> Path:
    return get_module_data_path(STORAGE_MODULE_NAME)


def _get_storage_path(bucket: str, sha256_filename: str):
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


def add_file_from_path(file_path: str, bucket="default"):
    """
    Add a file to the storage from a file path.

    :param file_path: Path to the file.
    :param bucket: Bucket name.
    :return: SHA256ed file name.
    """
    sha256 = compute_sha256_from_file(file_path)
    sha256_filename = sha256 + os.path.splitext(file_path)[1]
    storage_path = _get_storage_path(bucket, sha256_filename)
    if not os.path.exists(storage_path):
        shutil.copy2(file_path, storage_path)
    return sha256_filename


def add_file_from_path_protocol(file_path: str, bucket="default"):
    """
    Add a file to the storage from a file path.

    :param file_path: Path to the file.
    :param bucket: Bucket name.
    :return: SHA256ed file name.
    """
    sha256_filename = add_file_from_path(file_path, bucket)
    return "storage://" + bucket + ":" + sha256_filename


def add_file_from_bytes(data: bytes, bucket="default", extension=".bin"):
    """
    Add a file to the storage from a byte array.

    :param data: Byte array.
    :param bucket: Bucket name.
    :return: SHA256ed file name.
    """
    sha256 = compute_sha256_from_bytes(data)
    sha256_filename = sha256 + extension
    storage_path = _get_storage_path(bucket, sha256_filename)
    if not os.path.exists(storage_path):
        with open(storage_path, "wb") as f:
            f.write(data)
    return sha256_filename


def add_file_from_bytes_protocol(data: bytes, bucket="default", extension=".bin"):
    """
    Add a file to the storage from a byte array.

    :param data: Byte array.
    :param bucket: Bucket name.
    :return: SHA256ed file name.
    """
    sha256_filename = add_file_from_bytes(data, bucket, extension)
    return "storage://" + bucket + ":" + sha256_filename


def get_file(self, sha256ed_filename: str, bucket="default"):
    """
    Retrieve a file from storage.

    :param sha256ed_filename: SHA256ed file name.
    :param bucket: Bucket name.
    :return: Path to the retrieved file or None if not found.
    """
    storage_path = _get_storage_path(bucket, sha256ed_filename)
    if os.path.exists(storage_path):
        return storage_path
    else:
        return None


def delete_file(sha256ed_filename: str, bucket="default"):
    """
    Delete a file from storage.

    :param sha256ed_filename: SHA256ed file name.
    :param bucket: Bucket name.
    """
    storage_path = _get_storage_path(bucket, sha256ed_filename)
    if os.path.exists(storage_path):
        os.remove(storage_path)


def storage_protocol(self, uri: str):
    """
    Retrieve a file using the 'storage://bucket:sha256.extension' protocol.

    :param uri: URI in the format 'storage://bucket:sha256.extension'.
    :param bucket: Default bucket if not specified in URI.
    :return: Path to the retrieved file or None if not found.
    """
    bucket = "default"
    parsed = urlparse(uri)
    if parsed.scheme != "storage":
        raise ValueError("Invalid URI scheme")

    parts = parsed.netloc.split(":", 1)
    if len(parts) == 2:
        bucket = parts[0]
        sha256ed_filename = parts[1]
    else:
        sha256ed_filename = parsed.netloc

    return self.get_file(sha256ed_filename, bucket)


def init_storage_module():
    make_sure_module_data_path_exists(STORAGE_MODULE_NAME)
    print("Storage module initialized")
