from playwright.async_api import async_playwright
from pagesnap.pagesnap import hook_page, page_snap

from module.storage.storage import storage_add_file_from_bytes_protocol

async def open_browser():
    async with async_playwright() as p:
        browser = await p.chromium.connect_over_cdp(
            "http://localhost:9222",
        )
        page = await browser.new_page()
        print('ready to open page')
        await page.goto("https://maxieewong.com/")
        print('page opened')
        await page.wait_for_load_state("domcontentloaded")
        print(await page.title())
        # sleep 10 seconds, then close the browser
        await page.wait_for_timeout(10000)

async def browser_pagesnap(url:str) -> str:
    """
    Save the page as a single file.
    
    :param url: URL of the page.
    :return: SHA256ed protocol with bucket.
    """
    async with async_playwright() as p:
        browser = await p.chromium.connect_over_cdp(
            "http://localhost:9222",
        )
        page = await browser.new_page()
        # pagesanp hook page
        await hook_page(page)
        await page.goto(url)
        await page.wait_for_load_state("networkidle")
        offline_html = await page_snap(page)
        return storage_add_file_from_bytes_protocol(
            offline_html.encode(), 
            bucket="offline_html", 
            extension=".html")
        