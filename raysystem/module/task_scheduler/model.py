from datetime import datetime
from enum import Enum
from module.db.base import Base
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy import (
    JSON,
    Integer,
    String,
    ForeignKey,
    DateTime,
    Boolean,
    LargeBinary,
    Enum as SQLAlchemyEnum,
)


class TaskScheduleType(str, Enum):
    """任务调度类型"""
    INTERVAL = "INTERVAL"  # 按时间间隔执行
    CRON = "CRON"  # 按cron表达式定时执行
    EVENT = "EVENT"  # 事件驱动执行
    MANUAL = "MANUAL"  # 手动触发执行


class ScheduledTask(Base):
    """定时任务存储表"""

    __tablename__ = "scheduled_task"
    # 任务 id
    id: Mapped[str] = mapped_column(String, primary_key=True, index=True)
    # 任务类型
    task_type: Mapped[str] = mapped_column(String, index=True)
    # 任务调度类型
    schedule_type: Mapped[TaskScheduleType] = mapped_column(
        SQLAlchemyEnum(TaskScheduleType),
        nullable=True,
        server_default=TaskScheduleType.INTERVAL.value,
    )
    # 对于INTERVAL类型，间隔秒数
    interval: Mapped[int] = mapped_column(Integer)
    # 对于CRON类型，存储cron表达式
    cron_expression: Mapped[str] = mapped_column(String, nullable=True)
    # 对于EVENT类型，存储事件类型
    event_type: Mapped[str] = mapped_column(String, nullable=True)
    # 下次执行时间戳
    next_run: Mapped[datetime] = mapped_column(DateTime)
    # 限流标记
    tag: Mapped[str] = mapped_column(String, index=True)
    # 任务参数，json 格式
    parameters: Mapped[dict] = mapped_column(JSON, nullable=True)
    # 是否启用
    enabled: Mapped[bool] = mapped_column(Boolean, default=True, server_default="1")


class TaskTagSate(Base):
    """任务标签状态表"""

    __tablename__ = "task_tag_state"
    # 限流标记
    tag: Mapped[str] = mapped_column(String, primary_key=True, index=True)
    # 上次执行时间戳
    last_run: Mapped[datetime] = mapped_column(DateTime)
