import asyncio
from typing import Callable, Dict, List

# 全局队列和注册表
TASK_QUEUE = asyncio.Queue()
TASK_CALLBACK_REGISTRY: Dict[str, List[Callable]] = {}


def task_queue_register_callback(task_name: str, callback: Callable):
    """
    Register a callback function for a task
    """
    if task_name not in TASK_CALLBACK_REGISTRY:
        TASK_CALLBACK_REGISTRY[task_name] = []
    if callback not in TASK_CALLBACK_REGISTRY[task_name]:
        TASK_CALLBACK_REGISTRY[task_name].append(callback)


def task_queue_unregister_callback(task_name: str, callback: Callable):
    """
    Unregister a callback function for a task
    """
    if task_name in TASK_CALLBACK_REGISTRY:
        if callback in TASK_CALLBACK_REGISTRY[task_name]:
            TASK_CALLBACK_REGISTRY[task_name].remove(callback)
            if not TASK_CALLBACK_REGISTRY[task_name]:
                del TASK_CALLBACK_REGISTRY[task_name]


async def task_queue_submit_task(task_name: str, *args, **kwargs):
    """
    Submit a task to the task queue
    """
    await TASK_QUEUE.put((task_name, args, kwargs))


async def task_queue_worker():
    """
    Task queue worker
    """
    while True:
        # 等待获取任务
        task_name, args, kwargs = await TASK_QUEUE.get()
        # 从注册表中找到对应的回调列表
        callbacks = TASK_CALLBACK_REGISTRY.get(task_name, [])
        if not callbacks:
            print(f"[警告] 无回调处理任务: {task_name}")

        # 执行所有回调
        for cb in callbacks:
            try:
                result = cb(*args, **kwargs)
                # 根据需要处理回调结果，这里只是打印
                print(
                    f"[回调执行] 任务: {task_name}, 回调: {cb.__name__}, 返回: {result}"
                )
            except Exception as e:
                print(f"[错误] 执行回调出错: {cb.__name__}, 错误信息: {e}")

        TASK_QUEUE.task_done()


def task_queue_print_status():
    """
    Print task queue status
    """
    # 打印当前队列情况
    print("=== 当前队列状态 ===")
    print(f"队列长度: {TASK_QUEUE.qsize()}")
    # 打印已注册的任务与回调对应情况
    print("=== 注册表映射 ===")
    if not TASK_CALLBACK_REGISTRY:
        print("无已注册的任务类型与回调")
    else:
        for tname, cbs in TASK_CALLBACK_REGISTRY.items():
            print(f"任务类型: {tname}")
            for cb in cbs:
                print(f"  回调函数: {cb.__name__}")


# 示例回调函数
def callback_print(*args, **kwargs):
    msg = f"打印参数: args={args}, kwargs={kwargs}"
    return msg


def callback_sum(*args, **kwargs):
    return f"参数求和结果: {sum(args)}"


async def init_task_queue():
    # 注册回调
    task_queue_register_callback("print_task", callback_print)
    task_queue_register_callback("sum_task", callback_sum)
    # 启动worker
    worker_task = asyncio.create_task(task_queue_worker())
    # 提交一些任务

    await task_queue_submit_task("print_task", 1, 2, 3, key="value")
    await task_queue_submit_task("sum_task", 10, 20, 30)
    await task_queue_submit_task("unknown_task", "无法处理的任务")

    # 自省状态
    task_queue_print_status()

    # # 等待队列处理完成
    # await TASK_QUEUE.join()
    # worker_task.cancel()
