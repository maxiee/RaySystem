from playwright.async_api import async_playwright

async def open_browser():
    playwright = await async_playwright().start()  # 手动启动 Playwright
    browser = await playwright.chromium.launch(
        channel="msedge", 
        headless=False,
        )
    page = await browser.new_page()
    await page.goto("https://maxieewong.com/")
