# Storage Module

This module provides functionalities for storing and retrieving files using SHA256 hashes. It supports adding files from paths and byte arrays, retrieving files by SHA256ed filenames or URIs, and deleting files.

## Functions

### `storage_add_file_from_path(file_path: str, bucket="default") -> str`

Adds a file to the storage from a file path.

### `storage_add_file_from_path_protocol(file_path: str, bucket="default")`

Adds a file to the storage from a file path and returns a URI.

### `storage_add_file_from_bytes(data: bytes, bucket="default", extension=".bin") -> str`

Adds a file to the storage from a byte array.

### `storage_add_file_from_bytes_protocol(data: bytes, bucket="default", extension=".bin")`

Adds a file to the storage from a byte array and returns a URI.

### `storage_get_file_by_sha256ed_filename(sha256ed_filename: str, bucket="default")`

Retrieves a file from storage by its SHA256ed filename.

### `storage_get_file_by_protocol(uri: str)`

Retrieves a file using the `storage://bucket:sha256.extension` protocol.

### `storage_delete_file_by_sha256ed_filename(sha256ed_filename: str, bucket="default")`

Deletes a file from storage by its SHA256ed filename.

### `storgae_delete_file_by_protocol(uri: str)`

Deletes a file using the `storage://bucket:sha256.extension` protocol.

### `init_storage_module()`

Initializes the storage module by ensuring the module data path exists.

## Usage

1. **Initialize the storage module:**
