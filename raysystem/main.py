import uvicorn
from module.db.db import init_db
from module.http.http import APP
from module.info.api import init_info_api
from module.ocr.api import init_ocr_api
from module.people.people import init_people_module
from module.repl.repl import init_repl
from module.storage.storage import init_storage_module
from module.system.api import init_system_api
from module.task_queue.task_queue import (
    init_task_queue,
)
from module.task_scheduler.task_scheduler import (
    dispose_task_scheduler,
    init_task_scheduler,
)
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


@APP.on_event("startup")
async def startup_event():
    print("RaySystem starting...")
    await init_task_queue()
    await init_db()
    init_repl()
    await init_task_scheduler()


@APP.on_event("shutdown")
async def shutdown_event():
    await dispose_task_scheduler()
    print("RaySystem shutting down...")


def main():
    init_config()
    init_fs_module()
    init_storage_module()
    init_info_api()
    init_people_module()
    init_ocr_api()
    init_system_api()
    uvicorn.run(APP, host="0.0.0.0", port=8000)


if __name__ == "__main__":
    main()
