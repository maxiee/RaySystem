import os
import logging
from datetime import datetime
from logging.handlers import TimedRotatingFileHandler

# Create logs directory if it doesn't exist
def ensure_logs_directory():
    logs_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 'logs')
    if not os.path.exists(logs_dir):
        os.makedirs(logs_dir)
    return logs_dir

# Configure IP logger
def get_ip_logger():
    logs_dir = ensure_logs_directory()
    
    # Create a logger for IP addresses
    ip_logger = logging.getLogger('ip_logger')
    ip_logger.setLevel(logging.INFO)
    
    # Avoid adding handlers multiple times
    if not ip_logger.handlers:
        # Get current date for the log filename
        current_date = datetime.now().strftime('%Y-%m-%d')
        log_file = os.path.join(logs_dir, f'ip_log_{current_date}.log')
        
        # Create a handler that creates a new log file each day at midnight
        file_handler = TimedRotatingFileHandler(
            log_file,
            when='midnight',
            interval=1,
            backupCount=30,  # Keep logs for 30 days
            utc=False
        )
        
        # Set the format for the log entries
        formatter = logging.Formatter('%(asctime)s - %(message)s')
        file_handler.setFormatter(formatter)
        
        # Add the handler to the logger
        ip_logger.addHandler(file_handler)
    
    return ip_logger

# Log an IP address with timestamp and status code
def log_ip_address(ip_address, path=None, method=None, status_code=None):
    logger = get_ip_logger()
    message = f"IP: {ip_address}"
    if path:
        message += f" | Path: {path}"
    if method:
        message += f" | Method: {method}"
    if status_code is not None:
        message += f" | Status: {status_code}"
    logger.info(message)