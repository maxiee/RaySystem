from datetime import datetime
from module.db.base import Base
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy import JSON, Integer, String, ForeignKey, DateTime, Boolean, LargeBinary


class ScheduledTask(Base):
    """定时任务存储表"""

    __tablename__ = "scheduled_task"
    # 任务 id
    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    # 任务类型
    task_type: Mapped[str] = mapped_column(String, index=True)
    # 执行间隔（秒）
    interval: Mapped[int] = mapped_column(Integer)
    # 下次执行时间戳
    next_run: Mapped[datetime] = mapped_column(DateTime)
    # 限流标记
    tag: Mapped[str] = mapped_column(String, index=True)
    # 任务参数，json 格式
    parameters: Mapped[dict] = mapped_column(JSON, nullable=True)


class TaskTagSate(Base):
    """任务标签状态表"""

    __tablename__ = "task_tag_state"
    # 任务 id
    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    # 限流标记
    tag: Mapped[str] = mapped_column(String, index=True)
    # 上次执行时间戳
    last_run: Mapped[datetime] = mapped_column(DateTime)
