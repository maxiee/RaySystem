from fastapi import APIRouter
from module.http.http import APP
from module.system.system import get_system_metrics, SystemMetrics
from typing import Dict, Union

@APP.get("/system/metrics")
async def get_metrics() -> Union[SystemMetrics, Dict[str, str]]:
    """
    Get current system metrics including:
    - CPU usage
    - Memory usage (including swap)
    - Disk usage and IO speeds
    - Network speeds
    
    :return: SystemMetrics object containing all system metrics
    """
    try:
        metrics = get_system_metrics()
        print("\n=== System Metrics ===")
        print(f"{metrics}")
        return metrics
    except Exception as e:
        return {"error": str(e)}

def init_system_api():
    print("System monitoring API initialized")