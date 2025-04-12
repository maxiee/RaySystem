from typing import Dict, List, Any, Callable, Awaitable, TypedDict, Optional, Union


# Type for chat context dictionary
class ChatContext(TypedDict, total=False):
    """Context passed through middleware chain during LLM operations."""

    request_messages: List[Dict[str, Any]]  # List of message dictionaries
    model: str  # Model identifier to send to the API
    model_config_name: str  # Name of model config in our system
    response_message: Any  # The response message object
    raw_openai_response: Optional[Dict[str, Any]]  # Full raw response from OpenAI
    error: Optional[Exception]  # Any error that occurred
    metadata: Dict[str, Any]  # Metadata for middleware communication


# Type for middleware function
LLMMiddleware = Callable[[ChatContext], Awaitable[None]]


async def apply_middleware(
    middleware_list: List[LLMMiddleware], context: ChatContext
) -> None:
    """
    Apply a list of middleware functions to the LLM context.

    Args:
        middleware_list: List of middleware functions to apply
        context: The context object to pass through the middleware chain
    """
    for middleware in middleware_list:
        try:
            await middleware(context)
        except Exception as e:
            print(f"Error in middleware {middleware.__name__}: {e}")
            # Only set the error if not already set
            if context.get("error") is None:
                context["error"] = e
