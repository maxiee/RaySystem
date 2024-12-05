import hashlib


def compute_sha256_from_file(file_path: str) -> str:
    """
    Compute the SHA256 hash of a file.

    :param file_path: Path to the file.
    :return: SHA256 hash as a hex string.
    """
    sha256 = hashlib.sha256()
    with open(file_path, "rb") as f:
        for byte_block in iter(lambda: f.read(4096), b""):
            sha256.update(byte_block)
    return sha256.hexdigest()


def compute_sha256_from_bytes(data: bytes) -> str:
    """
    Compute the SHA256 hash of a byte array.

    :param data: Byte array.
    :return: SHA256 hash as a hex string.
    """
    sha256 = hashlib.sha256()
    sha256.update(data)
    return sha256.hexdigest()


def get_file_extension_from_path(file_path: str) -> str:
    """
    Get the file extension from a file path.

    :param file_path: Path to the file.
    :return: File extension.
    """
    return file_path.split(".")[-1]
