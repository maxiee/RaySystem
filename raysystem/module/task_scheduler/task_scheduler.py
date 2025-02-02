import asyncio
from collections import defaultdict
import time
from apscheduler.schedulers.asyncio import AsyncIOScheduler

from module.crawler.test.test_crawler import test_crawler_task


class TaskScheduler:
    def __init__(self, max_concurrent_tasks=2, task_type_cooldown=300) -> None:
        """
        :param max_concurrent_tasks: Maximum number of tasks that can be executed concurrently
        :param task_type_cooldown: Cooldown time for a task type in seconds
        """
        self.max_concurrent = max_concurrent_tasks
        self.type_cooldown = task_type_cooldown
        self.semaphore = asyncio.Semaphore(max_concurrent_tasks)
        self.last_execution = defaultdict(float)
        self.tag_locks = defaultdict(asyncio.Lock)
        self.scheduler = AsyncIOScheduler()

    async def _wrap_job(self, tag, coro_func, *args, **kwargs):
        # The lock here is to prevent multiple jobs of the same type from running concurrently
        async with self.tag_locks[tag]:
            current_time = time.time()
            last_exec_time = self.last_execution.get(tag, 0)
            if current_time - last_exec_time < self.type_cooldown:
                print(f"Task {tag} skipped due to cooldown. Last run: {last_exec_time}")
                return

            # The semaphore here is to limit the number of concurrent tasks
            async with self.semaphore:
                print(f"Starting task {tag} at {current_time}")
                try:
                    await coro_func(*args, **kwargs)
                except Exception as e:
                    print(f"Task {tag} error: {e}")
                finally:
                    self.last_execution[tag] = time.time()
                    print(f"Task {tag} finished at {self.last_execution[tag]}")

    def add_job(
        self, coro_func, trigger, tag, id=None, args=None, kwargs=None, **job_kwargs
    ):
        """
        :param coro_func: Coroutine function to be executed
        :param trigger: Trigger to start the job
        :param tag: Task type identifier
        :param id: Job identifier
        :param args: Arguments to be passed to the coroutine function
        :param kwargs: Keyword arguments to be passed to the coroutine function
        :param job_kwargs: Additional keyword arguments to be passed to the job
        """
        job_args = [tag, coro_func]
        if args:
            job_args.extend(args)
        self.scheduler.add_job(
            self._wrap_job,
            trigger,
            args=job_args,
            kwargs=kwargs if kwargs else {},
            id=id,
            **job_kwargs,
        )

    def start(self):
        self.scheduler.start()
        print("Scheduler started")

    def shutown(self):
        self.scheduler.shutdown()
        print("Scheduler shutdown")


kTaskScheduler = TaskScheduler()


def init_task_scheduler():
    kTaskScheduler.start()

    kTaskScheduler.add_job(
        test_crawler_task,
        "interval",
        "test_crawler",
        seconds=5,
        args=("test", "args"),
        id="test_crawler_job_1",
    )

    kTaskScheduler.add_job(
        test_crawler_task,
        "interval",
        "test_crawler",
        seconds=10,
        args=("test", "args"),
        id="test_crawler_job_2",
    )

    print("Task scheduler initialized")


def dispose_task_scheduler():
    kTaskScheduler.shutown()
    print("Task scheduler disposed")
