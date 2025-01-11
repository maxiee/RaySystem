from fastapi import FastAPI


APP = FastAPI()

@APP.get('/hello')
async def heelo_world():
    return {'hello': 'world'}