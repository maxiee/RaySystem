from typing import List, Callable, Awaitable

from module.llm.middlewares.context import ChatContext


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
