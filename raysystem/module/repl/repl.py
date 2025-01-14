import asyncio
from module.storage.storage import storage_get_file_by_protocol
from module.task_queue.task_queue import (
    task_queue_submit_task,
    task_queue_print_status,
    task_queue_register_callback,
)
from module.early_sleeping.early_sleeping import early_sleeping_gen_diary
from module.browser.browser import browser_pagesnap, open_browser
from module.info.info import (
    info_get_by_id,
    info_is_site_exists_by_host,
    init_info_module,
)
import subprocess


async def run_repl():
    """Run the REPL in a separate task"""
    while True:
        try:
            line = await asyncio.to_thread(input, "Input> ")
            line = line.strip()
            # Split the input into command and arguments
            parts = line.split()
            if not parts:
                continue
            command = parts[0]
            args = parts[1:] if len(parts) > 1 else []
            await task_queue_submit_task("repl_command", command, *args)
        except EOFError:
            break


async def handle_repl_command(command: str, *args):
    print(f"处理REPL命令: {command}, 参数: {args}")
    if command == "exit":
        # Signal the application to shut down gracefully
        import signal
        import os

        # Send SIGTERM to own process
        os.kill(os.getpid(), signal.SIGTERM)
        return "Shutting down..."
    elif command == "help":
        print("Available commands:")
        print("  exit - Exit the application")
        print("  help - Show this help message")
        print("  early-sleeping - Generate early sleeping diary")
        print("  task-queue-status - Show task queue status")
        print("  open-browser - Open browser")
        print("  is-site-exists <url> - Check if site exists")
    elif command == "early-sleeping":
        print(early_sleeping_gen_diary())
    elif command == "task-queue-status":
        task_queue_print_status()
    elif command == "open-browser":
        await open_browser()
    elif command == "is-site-exists":
        if not args:
            print("Error: URL argument is required")
            return
        url = args[0]
        print(f"Checking if site exists: {url}")
        ret = await info_is_site_exists_by_host(url)
        print(f"Site exists: {ret}")
    elif command == "browser-pagesnap":
        if not args:
            print("Error: URL argument is required")
            return
        url = args[0]
        print(f"Checking if site exists: {url}")
        ret = await browser_pagesnap(url)
        print(f"page saved path: {ret}")
    elif command == "launch-chrome":
        port = args[0] if args else "9222"
        try:
            # Arch Linux
            subprocess.Popen(
                ["google-chrome-stable", f"--remote-debugging-port={port}"]
            )
            print(f"Chrome launched with remote debugging port {port}")
        except Exception as e:
            print(f"Failed to launch Chrome: {e}")
    elif command == "convert_info_snap_to_markdown":
        info_id = args[0]
        info = await info_get_by_id(info_id)
        if not info.storage_html:
            print("Error: Info does not have a storage_html field")
            return
        html_path = storage_get_file_by_protocol(info.storage_html)
        if not html_path:
            print("Error: Failed to get HTML file")
            return
        with open(html_path) as f:
            html_content = f.read()
            from markdownify import markdownify as md

            markdown = md(html_content)
            with open("info.md", "w") as f:
                f.write(markdown)


def init_repl():
    task_queue_register_callback("repl_command", handle_repl_command)
    asyncio.create_task(run_repl())
