from fastapi import FastAPI
from module.llm import llm_router


APP = FastAPI()

APP.include_router(llm_router)


@APP.get("/hello")
async def heelo_world():
    return {"hello": "world"}
