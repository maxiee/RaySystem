#!/bin/bash

# 确保脚本在当前目录执行
SCRIPT_DIR=$(dirname "$(realpath "$0")")
cd "$SCRIPT_DIR"

# 运行 RayRepo 下的 main.py
python3 projects/RayRepo/main.py "$@"
