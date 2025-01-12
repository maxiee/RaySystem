import asyncio

import uvicorn
from module.browser.browser import open_browser
from module.db.db import init_db
from module.early_sleeping.early_sleeping import early_sleeping_gen_diary
from module.http.http import APP
from module.info.info import info_is_site_exists_by_host, init_info_module
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
            # Split the input into command and arguments
            parts = line.split()
            if not parts:
                continue
            command = parts[0]
            args = parts[1:] if len(parts) > 1 else []
            await task_queue_submit_task("repl_command", command, *args)
        except EOFError:
            break

async def handle_repl_command(command: str, *args):
    print(f"处理REPL命令: {command}, 参数: {args}")
    if command == "exit":
        # Signal the application to shut down gracefully
        import signal
        import os
        # Send SIGTERM to own process
        os.kill(os.getpid(), signal.SIGTERM)
        return "Shutting down..."
    elif command == "help":
        print("Available commands:")
        print("  exit - Exit the application")
        print("  help - Show this help message")
        print("  early-sleeping - Generate early sleeping diary")
        print("  task-queue-status - Show task queue status")
        print("  open-browser - Open browser")
        print("  is-site-exists <url> - Check if site exists")
    elif command == 'early-sleeping':
        print(early_sleeping_gen_diary())
    elif command == 'task-queue-status':
        task_queue_print_status()
    elif command == 'open-browser':
        await open_browser()
    elif command == 'is-site-exists':
        if not args:
            print("Error: URL argument is required")
            return
        url = args[0]
        print(f"Checking if site exists: {url}")
        ret = await info_is_site_exists_by_host(url)
        print(f"Site exists: {ret}")
    
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