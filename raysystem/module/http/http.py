from fastapi import FastAPI
from module.llm import llm_router
from module.people import router as people_router

APP = FastAPI()

APP.include_router(llm_router)
APP.include_router(people_router)


@APP.get("/hello")
async def heelo_world():
    return {"hello": "world"}
