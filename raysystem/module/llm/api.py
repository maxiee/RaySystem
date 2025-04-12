from fastapi import APIRouter, Depends, HTTPException, status
from typing import List
from openai import OpenAIError

from .schemas import ChatCompletionRequest, ChatCompletionResponse
from .llm import LLMService, logging_middleware  # Import service and example middleware
from .middleware import LLMMiddleware


# --- Dependency Injection Setup ---
# This function provides the LLMService instance to the endpoint.
# It should be configured to load settings (URL, key, model) from your
# central configuration system (e.g., RaySystemConfig.yaml).
# It also defines which middleware functions to use.
def get_llm_service() -> LLMService:
    # Define middleware list (can be loaded/configured dynamically)
    configured_middleware: List[LLMMiddleware] = [
        logging_middleware,
        # Add other middleware here (e.g., token counting, db logging)
    ]

    # In a real app, load base_url, api_key, default_model from your config
    # from raysystem.config import settings # Example
    # service = LLMService(
    #     base_url=settings.get("llm_service"),
    #     api_key=settings.get("llm_key"),
    #     default_model=settings.get("llm_model"),
    #     middleware=configured_middleware
    # )
    # Using placeholders from llm.py for now:
    try:
        # You might want a singleton pattern here if config loading is expensive
        service = LLMService(middleware=configured_middleware)
        return service
    except ValueError as e:
        # Handle configuration errors during startup or first request
        print(f"FATAL: LLM Service configuration error: {e}")
        # This exception will prevent the app from starting correctly if raised early,
        # or cause a 500 error if raised during a request.
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"LLM service not configured correctly: {e}",
        ) from e


# --- API Router Definition ---
router = APIRouter(
    prefix="/llm",
    tags=["LLM"],  # Tag for OpenAPI documentation grouping
)


@router.post(
    "/chat",
    response_model=ChatCompletionResponse,
    summary="Generate Chat Completion",
    description="Sends a conversation history to the configured LLM and returns the next message.",
    status_code=status.HTTP_200_OK,
)
async def chat_completion_endpoint(
    request: ChatCompletionRequest,
    llm_service: LLMService = Depends(get_llm_service),  # Inject the service
):
    """
    Receives chat messages, interacts with the LLM service via `LLMService`,
    and returns the assistant's response. Handles potential errors.
    """
    try:
        response = await llm_service.create_chat_completion(request)
        return response
    except OpenAIError as e:
        # Handle specific errors from the OpenAI SDK or compatible service
        # You might want to map different OpenAI errors to specific HTTP status codes
        print(f"LLM API Error in endpoint: {e}")
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,  # Or another appropriate code
            detail=(f"LLM service error: {e}"),
        )
    except ValueError as e:
        # Handle validation errors or internal logic errors
        print(f"Value Error in endpoint: {e}")
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST, detail=str(e)  # Or 500 if internal
        )
    except Exception as e:
        # Catch-all for unexpected errors
        print(f"Unexpected Error in /chat endpoint: {type(e).__name__}: {e}")
        # Log the full traceback here in a real application
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="An unexpected error occurred while processing the chat completion.",
        )
