from typing import Protocol, Any, Dict, List, Coroutine, Callable, Awaitable

# Context dictionary passed to middleware
ChatContext = Dict[str, Any]
# Example keys: 'request_messages', 'model', 'response_message', 'raw_openai_response', 'error', 'metadata'


# Define the middleware callable type using a Protocol for type checking
class LLMMiddleware(Protocol):
    async def __call__(self, context: ChatContext) -> None:
        """
        An async callable that processes the chat context.
        It can inspect or modify the context before or after the LLM call.
        """
        ...


# Helper function to apply middleware (can be used in the service)
async def apply_middleware(middleware_list: List[LLMMiddleware], context: ChatContext):
    """Applies a list of middleware functions sequentially to the context."""
    for middleware in middleware_list:
        await middleware(context)
