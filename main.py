import asyncio
from concurrent.futures import ThreadPoolExecutor
import sys
from module.info.info import init_info_module
from module.storage.storage import init_storage_module
from module.task_queue.task_queue import init_task_queue
from utils.config import load_config_file
from module.data.data import init_data_module, set_data_path

# 后台任务队列
task_queue = asyncio.Queue()

# 线程池
executor = ThreadPoolExecutor(max_workers=10)

# def main():
#     print("RaySystem starting...")
#     init_config()
#     # module initialization
#     init_data_module()
#     init_storage_module()
#     init_info_module()


# def init_config():
#     config_file = load_config_file()
#     print(config_file)
#     if "data_path" in config_file:
#         set_data_path(config_file["data_path"])


async def repl():
    while True:
        line = await asyncio.to_thread(input, "Input> ")
        line = line.strip()
        if line == "exit":
            break
        elif line == "help":
            print("help")


async def main():
    await init_task_queue()
    await repl()


if __name__ == "__main__":
    asyncio.run(main())
