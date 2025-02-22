from fastapi import Depends
from typing import List
from pydantic import BaseModel
from datetime import datetime

from module.http.http import APP
from module.task_scheduler.task_scheduler import kTaskScheduler

class ScheduledTaskResponse(BaseModel):
    id: str
    task_type: str
    interval: int
    tag: str
    next_run: datetime
    parameters: dict

@APP.get("/scheduler_tasks/", response_model=List[ScheduledTaskResponse])
async def get_scheduled_tasks():
    """
    Get all scheduled tasks information including:
    - Task ID
    - Task type
    - Interval
    - Tag
    - Next run time
    - Task parameters
    """
    tasks = []
    for task in kTaskScheduler.tasks.values():
        tasks.append(
            ScheduledTaskResponse(
                id=task.id,
                task_type=task.task_type,
                interval=task.interval,
                tag=task.tag,
                next_run=task.next_run,
                parameters=task.parameters
            )
        )
    return tasks

def init_task_scheduler_api():
    """Initialize task scheduler API endpoints"""
    print("Task scheduler API initialized")