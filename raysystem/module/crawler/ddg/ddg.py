import asyncio
from math import e
import time

from duckduckgo_search import DDGS

from module.info.info import info_create_info_buck, info_create_site_by_host, info_get_site_by_host, info_is_info_exists_by_url, info_is_site_exists_by_host
from module.info.model import Info
from module.info.utils import info_extract_host_from_url


async def ddg_crawler_task(**kwargs):
    print("DuckDuckGo crawler task executed at {}".format(time.time()))
    results = DDGS().text(kwargs['query'], timelimit='w')

    new_items = []
    for result in results:
        # 检查是否存在
        existed = await info_is_info_exists_by_url(result['href'])
        if existed:
            print(f"Info already exists for url: {result['href']}")
            continue

        host = info_extract_host_from_url(result['href'])
        if await info_is_site_exists_by_host(host):
            site = await info_get_site_by_host(host)
        else:
            site = await info_create_site_by_host(host)
        
        # 构造Info对象
        info = Info(
            title=result['title'],
            url=result['href'],
            description=result['body'],
            site_id=site.id,
        )
        new_items.append(info)
    
    try:
        await info_create_info_buck(new_items)
        for info in new_items:
            print(f"Saved new info: {info.title}")
    except Exception as e:
        print(f"Error while saving new info: {e}")

    print("DuckDuckGo crawler task finished at {}".format(time.time()))


if __name__ == "__main__":
    asyncio.run(ddg_crawler_task())