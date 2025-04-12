from fastapi import APIRouter, Depends, HTTPException, status
from typing import List
from openai import OpenAIError

from .schemas import ChatCompletionRequest, ChatCompletionResponse, ListModelsResponse
from .llm import LLMService, logging_middleware  # Import service and example middleware
from .middleware import LLMMiddleware
from utils.config import load_config_file


# --- Dependency Injection Setup ---
def get_llm_service() -> LLMService:
    """
    Provides the LLMService instance to the endpoints.
    Loads configuration from RaySystemConfig.yaml.
    """
    # Define middleware list (can be loaded/configured dynamically)
    configured_middleware: List[LLMMiddleware] = [
        logging_middleware,
        # Add other middleware here (e.g., token counting, db logging)
    ]

    # Load config directly from RaySystemConfig.yaml
    try:
        config = load_config_file()
        # Create service with config, middleware will be applied to all LLM requests
        service = LLMService(config_dict=config, middleware=configured_middleware)
        return service
    except ValueError as e:
        # Handle configuration errors during startup or first request
        print(f"FATAL: LLM Service configuration error: {e}")
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

    The model_name parameter in the request allows selecting which configured model to use.
    If not specified, the default model will be used.
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


@router.get(
    "/models",
    response_model=ListModelsResponse,
    summary="List Available LLM Models",
    description="Returns a list of available LLM models that can be used for chat completions.",
    status_code=status.HTTP_200_OK,
)
async def list_models_endpoint(
    llm_service: LLMService = Depends(get_llm_service),  # Inject the service
):
    """
    Lists all available LLM models that can be used with the /chat endpoint.
    Also indicates which model is the default.
    """
    try:
        models, default_model = llm_service.get_available_models()
        return ListModelsResponse(models=models, default_model=default_model)
    except Exception as e:
        print(f"Error in list_models_endpoint: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Unable to retrieve model list: {e}",
        )
