from playwright.async_api import async_playwright
from pagesnap.pagesnap import hook_page, page_snap

from module.info.model import Info
from module.info.utils import info_extract_host_from_url
from module.storage.storage import storage_add_file_from_bytes_protocol


async def open_browser():
    async with async_playwright() as p:
        browser = await p.chromium.connect_over_cdp(
            "http://localhost:9222",
        )
        page = await browser.new_page()
        print("ready to open page")
        await page.goto("https://maxieewong.com/")
        print("page opened")
        await page.wait_for_load_state("domcontentloaded")
        print(await page.title())
        # sleep 10 seconds, then close the browser
        await page.wait_for_timeout(10000)


async def browser_pagesnap(url: str) -> str:
    """
    Save the page as a single file.

    :param url: URL of the page.
    :return: SHA256ed protocol with bucket.
    """
    from module.info.info import (
        info_is_site_exists_by_host,
        info_get_site_by_host,
        info_create_site_by_host,
        info_create_info,
        info_is_info_exists_by_url
    )
    
    if await info_is_info_exists_by_url(url):
        raise ValueError(f"Info already exists for URL: {url}")

    async with async_playwright() as p:
        browser = await p.chromium.connect_over_cdp(
            "http://localhost:9222",
        )
        page = await browser.new_page()
        # pagesanp hook page
        await hook_page(page)
        await page.goto(url)
        await page.wait_for_load_state("networkidle")

        host = info_extract_host_from_url(url)
        if await info_is_site_exists_by_host(host):
            site = await info_get_site_by_host(host)
        else:
            site = await info_create_site_by_host(host)

        offline_html = await page_snap(page)
        
        storage_html = storage_add_file_from_bytes_protocol(
            offline_html.encode(),
            bucket="offline_html",
            extension=".html")
        
        title = await page.title()
        
        info = Info(
            site_id=site.id,
            title=title,
            url=url,
            storage_html=storage_html,
        )
        
        await info_create_info(info)
        
        return storage_html 
