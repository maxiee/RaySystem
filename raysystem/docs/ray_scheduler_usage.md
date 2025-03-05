# RayScheduler 使用指南

## 简介

RayScheduler 是一个灵活的任务调度器，用于管理和执行各种定时、间隔、事件驱动和手动触发的任务。它提供了简单易用的 API 来注册和管理不同类型的任务，支持基于时间的调度和事件驱动的执行机制。

## 初始化

在使用 RayScheduler 前，需要先初始化并启动调度器：

```python
from module.task_scheduler.task_scheduler import kTaskScheduler

# 初始化调度器
await kTaskScheduler.initialize()

# 设置调试模式（可选）
kTaskScheduler.debug = True  # 开启详细日志输出

# 启动调度器
await kTaskScheduler.start()
```

## 注册任务类型

在添加具体的任务之前，需要先注册任务处理函数：

```python
# 注册任务类型
async def my_custom_task(**params):
    # 处理任务逻辑
    print(f"执行任务，参数: {params}")

kTaskScheduler.register_task_type("my_task_type", my_custom_task)
```

## 添加任务

### 间隔任务

间隔任务会按照固定的时间间隔重复执行：

```python
# 添加一个每 300 秒执行一次的任务
await kTaskScheduler.add_interval_task(
    task_id="daily_data_sync",         # 任务唯一标识符
    task_type="my_task_type",          # 已注册的任务类型
    interval=300,                      # 间隔时间（秒）
    tag="data_operations",             # 任务标签（用于冷却时间控制）
    parameters={"source": "database"}  # 传递给任务处理函数的参数
)
```

### 定时任务 (Cron)

使用 cron 表达式定义的定时任务：

```python
# 添加一个每天凌晨 2 点执行的任务
await kTaskScheduler.add_cron_task(
    task_id="nightly_cleanup",           # 任务唯一标识符
    task_type="cleanup_task",            # 已注册的任务类型
    cron_expression="0 2 * * *",         # Cron 表达式
    tag="maintenance",                   # 任务标签
    parameters={"delete_temp": True}     # 传递给任务处理函数的参数
)
```

### 事件驱动任务

响应特定事件触发的任务：

```python
# 添加一个响应 "new_article" 事件的任务
await kTaskScheduler.add_event_task(
    task_id="notify_subscribers",       # 任务唯一标识符
    task_type="notification_task",      # 已注册的任务类型
    event_type="new_article",           # 事件类型
    tag="notifications",                # 任务标签
    parameters={"channel": "email"}     # 传递给任务处理函数的参数
)
```

### 手动触发任务

可以手动触发的任务：

```python
# 添加一个手动触发的任务
await kTaskScheduler.add_manual_task(
    task_id="generate_report",          # 任务唯一标识符
    task_type="report_task",            # 已注册的任务类型
    tag="reports",                      # 任务标签
    parameters={"format": "pdf"}        # 传递给任务处理函数的参数
)
```

## 触发任务和事件

### 触发事件

```python
# 触发事件，执行所有关联的事件任务
await kTaskScheduler.emit_event(
    "new_article",                     # 事件类型
    article_id=123,                    # 上下文参数（会合并到任务参数中）
    title="新文章标题"
)
```

### 手动触发任务

```python
# 手动触发特定任务
success = await kTaskScheduler.trigger_task(
    "generate_report",                 # 任务 ID
    report_type="月度",                # 额外参数（会合并到任务参数中）
    include_charts=True
)

if success:
    print("任务触发成功")
else:
    print("任务触发失败")
```

## 任务冷却时间

RayScheduler 使用标签（tag）来控制任务的冷却时间，避免相同类型的任务过于频繁地执行：

```python
# 设置全局冷却时间（秒）
kTaskScheduler.task_cooldown = 60  # 默认为 300 秒
```

具有相同标签的任务在上一次执行后的冷却时间内不会被再次执行，即使它们的调度时间已到。

## 停止调度器

在应用程序结束时，应该停止调度器：

```python
# 停止调度器
await kTaskScheduler.stop()
```

## 完整示例

```python
from module.task_scheduler.task_scheduler import kTaskScheduler

# 自定义任务处理函数
async def data_sync_task(**params):
    print(f"正在同步数据，参数: {params}")

# 初始化并配置
await kTaskScheduler.initialize()
kTaskScheduler.debug = True
kTaskScheduler.task_cooldown = 60

# 注册任务类型
kTaskScheduler.register_task_type("data_sync", data_sync_task)

# 添加任务
await kTaskScheduler.add_interval_task(
    "hourly_sync", "data_sync", 3600, "sync", {"mode": "incremental"}
)

# 启动调度器
await kTaskScheduler.start()

# 应用程序运行...

# 手动触发任务
await kTaskScheduler.trigger_task("hourly_sync", force=True)

# 应用程序结束时
await kTaskScheduler.stop()
```

## 注意事项

1. 确保注册的任务处理函数是异步函数（async def）
2. 任务 ID 必须唯一，否则会覆盖现有任务
3. 任务冷却时间是基于标签的，相同标签的任务共享冷却时间
4. 调度器初始化后会自动从数据库加载现有任务
