import asyncio
from concurrent.futures import ThreadPoolExecutor

from fastapi import FastAPI
import uvicorn
from module.db.db import init_db
from module.storage.storage import init_storage_module
from module.task_queue.task_queue import init_task_queue, task_queue_print_status
from utils.config import load_config_file
from module.fs.fs import init_fs_module, fs_set_data_path

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Welcome to RaySystem API"}

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


def init_config():
    config_file = load_config_file()
    print(config_file)
    if "data_path" in config_file:
        fs_set_data_path(config_file["data_path"])

async def process_tasks():
    while True:
        task = await task_queue.get()
        try:
            await task
        except Exception as e:
            print(f"Task error: {e}")
        finally:
            task_queue.task_done()

async def run_repl():
    """Run the REPL in a separate task"""
    task_processor = asyncio.create_task(process_tasks())
    
    while True:
        try:
            line = await asyncio.to_thread(input, "Input> ")
            line = line.strip()
            if line == "exit":
                exit(0)
            elif line == "help":
                print("help")
            elif line == 'task-queue-status':
                task_queue_print_status()
        except EOFError:
            break
    
    task_processor.cancel()
    try:
        await task_processor
    except asyncio.CancelledError:
        pass

@app.on_event("startup")
async def startup_event():
    print("RaySystem starting...")
    await init_task_queue()
    await init_db()
    asyncio.create_task(run_repl())

def main():
    init_config()
    init_fs_module()
    init_storage_module()
    uvicorn.run(app, host="0.0.0.0", port=8000)

if __name__ == "__main__":
    main()