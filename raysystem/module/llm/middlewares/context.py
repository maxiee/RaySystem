# Type for chat context dictionary
from typing import Any, Dict, List, Optional, TypedDict


class ChatContext(TypedDict, total=False):
    """Context passed through middleware chain during LLM operations."""

    request_messages: List[Dict[str, Any]]  # List of message dictionaries
    model: str  # Model identifier to send to the API
    model_config_name: str  # Name of model config in our system
    response_message: Any  # The response message object
    raw_openai_response: Optional[Dict[str, Any]]  # Full raw response from OpenAI
    error: Optional[Exception]  # Any error that occurred
    metadata: Dict[str, Any]  # Metadata for middleware communication
