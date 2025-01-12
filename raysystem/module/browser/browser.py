from playwright.async_api import async_playwright

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
