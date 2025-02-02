from typing import Optional

import aiohttp
import feedparser

from module.info.info import info_create_info_buck, info_is_info_exists_by_url
from module.info.model import Info, Site
from datetime import datetime


class RSSCollector:
    def __init__(
        self,
        rss_url: str,
        site_id: int,
        channel_id: Optional[int] = None,
        subchannel_id: Optional[int] = None,
    ) -> None:
        self.rss_url = rss_url
        self.site_id = site_id
        self.channel_id = channel_id
        self.subchannel_id = subchannel_id

    async def _fetch_feed(self) -> Optional[feedparser.FeedParserDict]:
        """
        获取RSS内容
        """
        timeout = aiohttp.ClientTimeout(total=10)

        try:
            async with aiohttp.ClientSession(timeout=timeout) as session:
                async with session.get(self.rss_url) as response:
                    content = await response.text()
                    return feedparser.parse(content)
        except Exception as e:
            print(f"Error fetching RSS feed: {e}")
            return None

    async def _process_entry(self, entry) -> Optional[Info]:
        """
        处理RSS中的每一项
        """
        # 提取基础信息
        url = getattr(entry, "link", "")
        if not url:
            return None

        # 检查是否已存在
        existed = await info_is_info_exists_by_url(url)
        if existed:
            return None

        # 构造Info对象
        published = None
        if hasattr(entry, "published_parsed"):
            published = datetime(*entry.published_parsed[:6])
        elif hasattr(entry, "updated_parsed"):
            published = datetime(*entry.updated_parsed[:6])

        # 处理多媒体内容
        image = None
        if hasattr(entry, "media_content"):
            image = entry.media_content[0]["url"] if entry.media_content else None
        elif hasattr(entry, "enclosures"):
            image = entry.enclosures[0]["href"] if entry.enclosures else None

        return Info(
            title=entry.title if hasattr(entry, "title") else "No Title",
            url=url,
            published=published,
            description=entry.description if hasattr(entry, "description") else None,
            image=image,
            site_id=self.site_id,
            channel_id=self.channel_id,
            subchannel_id=self.subchannel_id,
            is_new=True,
            is_mark=False,
        )

    async def fetch_and_save(self):
        feed = await self._fetch_feed()
        # feed.bozo is True if the feed is invalid
        if not feed or feed.bozo:
            print(f"Invalid RSS feed: {self.rss_url}")
            return

        entries = feed.entries if hasattr(feed, "entries") else []
        print(f"Found {len(entries)} entries in {self.rss_url}")

        new_items = []
        for entry in entries:
            info = await self._process_entry(entry)
            if info:
                new_items.append(info)

        try:
            await info_create_info_buck(new_items)
            for info in new_items:
                print(f"Saved new info: {info.title}")
        except Exception as e:
            print(f"Error saving new info: {e}")


# 集成到任务调度系统
async def create_rss_job(scheduler, rss_url: str, site: Site, interval: int = 3600):
    host = site.host

    async def rss_task_wrapper():
        print(f"Fetching RSS feed for {host}")
        collector = RSSCollector(rss_url, site.id)
        await collector.fetch_and_save()

    scheduler.add_job(
        coro_func=rss_task_wrapper,
        trigger="interval",
        seconds=interval,
        tag=host,
        id=f"rss_{host}_{site.id}",
    )
