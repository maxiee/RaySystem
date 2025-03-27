import os
from fastapi import Request, Response
from fastapi.responses import JSONResponse
from starlette.middleware.base import BaseHTTPMiddleware
import uvicorn
from module.db.db import init_db
from module.http.http import APP
from module.info.api import init_info_api
from module import note
from module.ocr.api import init_ocr_api
from module.people.people import init_people_module
from module.repl.repl import init_repl
from module.storage.storage import init_storage_module
from module.system.api import init_system_api
from module.task_queue.task_queue import (
    init_task_queue,
)
from module.task_scheduler.api import init_task_scheduler_api
from module.task_scheduler.task_scheduler import (
    dispose_task_scheduler,
    init_task_scheduler,
)
from utils.config import load_config_file
from utils.logger import log_ip_address
from module.fs.fs import init_fs_module, fs_set_data_path
import secrets

def get_api_key():
    return os.getenv('RAY_SYSTEM_KEY')

# Using BaseHTTPMiddleware to get access to response status code
class RequestIPLoggerMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        # Get client IP
        client_host = request.client.host if request.client else "unknown"
        
        # Process the request and get response
        response = await call_next(request)
        
        # Log IP with status code
        log_ip_address(
            client_host, 
            request.url.path, 
            request.method, 
            response.status_code
        )
        
        return response

class APIKeyMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        # 不需要验证的路径，如健康检查
        exclude_paths = []
        
        if request.url.path in exclude_paths:
            return await call_next(request)
        
        # 对来自于 127.0.0.1 的请求不校验 API Key
        client_host = request.client.host if request.client else None
        if client_host == "127.0.0.1":
            return await call_next(request)
        
        api_key = get_api_key()
        
        # 从请求头中获取API密钥
        request_api_key = request.headers.get("X-API-Key")
        
        # 比较API密钥，使用secrets.compare_digest防止时序攻击
        if not request_api_key or not secrets.compare_digest(str(api_key), str(request_api_key)):
            return JSONResponse(
                status_code=401,
                content={"message": "Invalid or missing API key"}
            )
        
        return await call_next(request)

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
    # 使用 FastAPI 的 add_middleware 方法添加中间件
    # 注意中间件的执行顺序：先添加的后执行，因此先验证 API KEY，再记录请求
    APP.add_middleware(RequestIPLoggerMiddleware)
    APP.add_middleware(APIKeyMiddleware)
    
    init_config()
    init_fs_module()
    init_storage_module()
    init_info_api()
    init_task_scheduler_api()
    init_people_module()
    init_ocr_api()
    init_system_api()
    note.init()
    uvicorn.run(APP, host="0.0.0.0", port=8000)


if __name__ == "__main__":
    main()
