import asyncio
from module.crawler.ddg.ddg import ddg_crawler_task
from module.ocr.ocr import ocr_text_from_image_path
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
from module.system.system import get_system_metrics
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
        print("  system-metrics - Show system metrics")
        print("  scheduler-debug <on/off> - Enable/disable scheduler debug mode")
    elif command == "early-sleeping":
        print(early_sleeping_gen_diary())
    elif command == "system-metrics":
        metrics = get_system_metrics()
        print("\n=== System Metrics ===")
        print(f"CPU Usage: {metrics.cpu_percent:.1f}%")
        
        print(f"\nMemory:")
        mem = metrics.memory
        print(f"  Physical Memory:")
        print(f"    Total:     {mem.total_gb:.1f} GB")
        print(f"    Used:      {mem.used_gb:.1f} GB")
        print(f"    Available: {mem.available_gb:.1f} GB")
        print(f"    Cached:    {mem.cached_gb:.1f} GB")
        print(f"    Usage:     {mem.percent:.1f}%")
        
        print(f"  Virtual Memory (Swap):")
        print(f"    Total:     {mem.swap_total_gb:.1f} GB")
        print(f"    Used:      {mem.swap_used_gb:.1f} GB")
        print(f"    Free:      {mem.swap_free_gb:.1f} GB")
        print(f"    Usage:     {mem.swap_percent:.1f}%")
        
        print("\nDisks:")
        for disk in metrics.disks:
            print(f"\n  {disk.volume_name} ({disk.mount_point}):")
            print(f"    Device:      {disk.device}")
            print(f"    Total:       {disk.total_gb:.1f} GB")
            print(f"    Used:        {disk.used_gb:.1f} GB")
            print(f"    Free:        {disk.free_gb:.1f} GB")
            print(f"    Usage:       {disk.usage_percent:.1f}%")
            print(f"    Read Speed:  {disk.read_speed_mb:.1f} MB/s")
            print(f"    Write Speed: {disk.write_speed_mb:.1f} MB/s")
        
        print("\nNetwork:")
        print(f"  Upload:   {metrics.network.upload_speed_mb:.1f} MB/s")
        print(f"  Download: {metrics.network.download_speed_mb:.1f} MB/s")
    elif command == "task-queue-status":
        task_queue_print_status()
    elif command == "open-browser":
        await open_browser()
    elif command == "ddg":
        if not args:
            print("Error: Search query is required")
            return
        query = " ".join(args)
        await ddg_crawler_task(query=query)
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
    elif command == "ocr-text-from-image-path":
        image_path = args[0]
        ret = ocr_text_from_image_path(image_path)
        # set to clipboard for macOS
        subprocess.run("pbcopy", text=True, input=ret, check=True)
        print(f"OCR text: \n{ret}")
    elif command == "scheduler-debug":
        if not args or args[0] not in ["on", "off"]:
            print("Usage: scheduler-debug <on/off>")
            return
        from module.task_scheduler.task_scheduler import kTaskScheduler
        kTaskScheduler.debug = args[0] == "on"
        print(f"Scheduler debug mode: {'enabled' if kTaskScheduler.debug else 'disabled'}")


def init_repl():
    task_queue_register_callback("repl_command", handle_repl_command)
    asyncio.create_task(run_repl())
