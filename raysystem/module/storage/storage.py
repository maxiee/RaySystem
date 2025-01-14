import os
from pathlib import Path
import shutil
from urllib.parse import urlparse
from module.base.constants import STORAGE_MODULE_NAME
from module.fs.fs import fs_get_module_data_path, fs_make_sure_module_data_path_exists
from utils.file import (
    compute_sha256_from_bytes,
    compute_sha256_from_file,
    get_file_extension_from_path,
)

# Layers of directories to create for storage
N = 5


def _get_root_path() -> Path:
    """
    Get the root path for the storage module.
    """
    return fs_get_module_data_path(STORAGE_MODULE_NAME)


def _get_storage_path(bucket: str, sha256: str):
    """
    Get the storage path for a given SHA256 hash.

    :param bucket: The bucket name.
    :param sha256: The SHA256 hash.
    :return: The storage path.
    """
    path_parts = [_get_root_path().absolute(), bucket] + list(sha256[:N])
    dir_path = os.path.join(*path_parts)
    if not os.path.exists(dir_path):
        os.makedirs(dir_path, exist_ok=True)
    return dir_path


def storage_add_file_from_path(file_path: str, bucket="default") -> str:
    """
    Add a file to the storage from a file path.

    :param file_path: Path to the file.
    :param bucket: Bucket name.
    :return: SHA256ed file name.
    """
    sha256 = compute_sha256_from_file(file_path)
    dir_path = _get_storage_path(bucket, sha256)

    sha256_filename = sha256 + get_file_extension_from_path(file_path)
    new_full_path = os.path.join(dir_path, sha256_filename)
    if not os.path.exists(new_full_path):
        shutil.copy2(file_path, new_full_path)
    return sha256_filename


def storage_add_file_from_path_protocol(file_path: str, bucket="default"):
    """
    Add a file to the storage from a file path.

    :param file_path: Path to the file.
    :param bucket: Bucket name.
    :return: SHA256ed file name.
    """
    sha256_filename = storage_add_file_from_path(file_path, bucket)
    return "storage://" + bucket + ":" + sha256_filename


def storage_add_file_from_bytes(data: bytes, bucket="default", extension=".bin"):
    """
    Add a file to the storage from a byte array.

    :param data: Byte array.
    :param bucket: Bucket name.
    :return: SHA256ed file name.
    """
    sha256 = compute_sha256_from_bytes(data)
    sha256_filename = sha256 + extension
    dir_path = _get_storage_path(bucket, sha256_filename)
    new_full_path = os.path.join(dir_path, sha256_filename)
    if not os.path.exists(new_full_path):
        with open(new_full_path, "wb") as f:
            f.write(data)
    return sha256_filename


def storage_add_file_from_bytes_protocol(
    data: bytes, bucket="default", extension=".bin"
):
    """
    Add a file to the storage from a byte array.

    :param data: Byte array.
    :param bucket: Bucket name.
    :return: SHA256ed file name.
    """
    sha256_filename = storage_add_file_from_bytes(data, bucket, extension)
    return "storage://" + bucket + ":" + sha256_filename


def storage_get_file_by_sha256ed_filename(
    sha256ed_filename: str, bucket="default"
) -> str | None:
    """
    Retrieve a file from storage.

    :param sha256ed_filename: SHA256ed file name.
    :param bucket: Bucket name.
    :return: Path to the retrieved file or None if not found.
    """
    storage_path = _get_storage_path(bucket, sha256ed_filename)
    if os.path.exists(storage_path):
        return os.path.join(storage_path, sha256ed_filename)
    else:
        return None


def storage_get_file_by_protocol(uri: str) -> str | None:
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

    return storage_get_file_by_sha256ed_filename(sha256ed_filename, bucket)


def storage_delete_file_by_sha256ed_filename(sha256ed_filename: str, bucket="default"):
    """
    Delete a file from storage.

    :param sha256ed_filename: SHA256ed file name.
    :param bucket: Bucket name.
    """
    storage_path = _get_storage_path(bucket, sha256ed_filename)
    if os.path.exists(storage_path):
        os.remove(storage_path)


def storgae_delete_file_by_protocol(uri: str):
    """
    Delete a file using the 'storage://bucket:sha256.extension' protocol.

    :param uri: URI in the format 'storage://bucket:sha256.extension'.
    """
    parsed = urlparse(uri)
    if parsed.scheme != "storage":
        raise ValueError("Invalid URI scheme")

    parts = parsed.netloc.split(":", 1)
    if len(parts) == 2:
        bucket = parts[0]
        sha256ed_filename = parts[1]
    else:
        bucket = "default"
        sha256ed_filename = parsed.netloc

    storage_delete_file_by_sha256ed_filename(sha256ed_filename, bucket)


def init_storage_module():
    fs_make_sure_module_data_path_exists(STORAGE_MODULE_NAME)
    print("Storage module initialized")
