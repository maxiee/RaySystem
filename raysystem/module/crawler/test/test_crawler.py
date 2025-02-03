import asyncio
import time


async def test_crawler_task(**kwargs):
    print("Test crawler task executed at {}".format(time.time()))
    print(kwargs)
    await asyncio.sleep(1)
    print("Test crawler task finished at {}".format(time.time()))
