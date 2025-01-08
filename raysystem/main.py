import asyncio

import uvicorn
from module.browser.browser import open_browser
from module.db.db import init_db
from module.early_sleeping.early_sleeping import early_sleeping_gen_diary
from module.http.http import APP
from module.info.info import init_info_module
from module.people.people import init_people_module
from module.storage.storage import init_storage_module
from module.task_queue.task_queue import init_task_queue, task_queue_print_status, task_queue_register_callback, task_queue_submit_task
from utils.config import load_config_file
from module.fs.fs import init_fs_module, fs_set_data_path


@APP.get("/")
async def root():
    return {"message": "Welcome to RaySystem API"}

def init_config():
    config_file = load_config_file()
    print(config_file)
    if "data_path" in config_file:
        fs_set_data_path(config_file["data_path"])

async def run_repl():
    """Run the REPL in a separate task"""    
    while True:
        try:
            line = await asyncio.to_thread(input, "Input> ")
            line = line.strip()
            await task_queue_submit_task("repl_command", line)
        except EOFError:
            break

async def handle_repl_command(command: str):
    print(f"处理REPL命令: {command}")
    if command == "exit":
        # Signal the application to shut down gracefully
        import signal
        import os
        # Send SIGTERM to own process
        os.kill(os.getpid(), signal.SIGTERM)
        return "Shutting down..."
    elif command == "help":
        print("help")
    elif command == 'early-sleeping':
        print(early_sleeping_gen_diary())
    elif command == 'task-queue-status':
        task_queue_print_status()
    elif command == 'open-browser':
        await open_browser()
    
def init_repl():
    task_queue_register_callback("repl_command", handle_repl_command)
    asyncio.create_task(run_repl())

@APP.on_event("startup")
async def startup_event():
    print("RaySystem starting...")
    await init_task_queue()
    await init_db()
    init_repl()

def main():
    init_config()
    init_fs_module()
    init_storage_module()
    init_info_module()
    init_people_module()
    uvicorn.run(APP, host="0.0.0.0", port=8000)

if __name__ == "__main__":
    main()