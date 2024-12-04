# Data Module

The data module handles the data storage location management for RaySystem.

## Features

- Manages the default data storage location (`~/RaySystem`)
- Provides functions to get and set the data storage path
- Ensures the data directory exists during initialization

## API Reference

### `data_path`

The global variable that stores the current data storage path. By default, it points to `~/RaySystem`.

### `set_data_path(path: str)`

Sets a custom data storage path.

- `path`: A string representing the new data storage path

### `get_data_path() -> Path`

Returns the current data storage path as a `Path` object.

### `init_data_module()`

Initializes the data module by creating the data directory if it doesn't exist.
