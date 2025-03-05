from fastapi import Depends
from typing import List, Optional
from pydantic import BaseModel
from datetime import datetime

from module.http.http import APP
from module.task_scheduler.task_scheduler import kTaskScheduler, TaskScheduleType

class ScheduledTaskResponse(BaseModel):
    id: str
    task_type: str
    schedule_type: TaskScheduleType
    interval: int
    cron_expression: Optional[str] = None
    event_type: Optional[str] = None
    next_run: datetime
    tag: str
    parameters: dict
    enabled: bool

@APP.get("/scheduler_tasks/", response_model=List[ScheduledTaskResponse])
async def get_scheduled_tasks():
    """
    Get all scheduled tasks information including:
    - Task ID
    - Task type
    - Schedule type (INTERVAL, CRON, EVENT, MANUAL)
    - Interval (for INTERVAL type)
    - Cron expression (for CRON type)
    - Event type (for EVENT type)
    - Next run time
    - Tag
    - Task parameters
    - Enabled status
    """
    tasks = []
    for task in kTaskScheduler.tasks.values():
        tasks.append(
            ScheduledTaskResponse(
                id=task.id,
                task_type=task.task_type,
                schedule_type=task.schedule_type,
                interval=task.interval,
                cron_expression=task.cron_expression,
                event_type=task.event_type,
                next_run=task.next_run,
                tag=task.tag,
                parameters=task.parameters,
                enabled=task.enabled
            )
        )
    return tasks

def init_task_scheduler_api():
    """Initialize task scheduler API endpoints"""
    print("Task scheduler API initialized")