# filepath: /Volumes/ssd/Code/RaySystem/raysystem/module/llm/api.py
from fastapi import APIRouter, Depends, HTTPException, status, Query
import asyncio
from typing import AsyncGenerator, List, Optional
from fastapi.responses import StreamingResponse
from openai import OpenAIError
from sqlalchemy.ext.asyncio import AsyncSession

from module.llm.llm import LLMService
from module.llm.chat_session import kChatSessionManager
from module.db.db import get_db_session
from .schemas import (
    ChatCompletionRequest,
    ChatCompletionResponse,
    ListModelsResponse,
    ChatSessionCreate,
    ChatSessionUpdate,
    ChatSessionResponse,
    ChatSessionsListResponse,
)

from utils.config import load_config_file


# --- Dependency Injection Setup ---
def get_llm_service() -> LLMService:
    """
    Provides the LLMService instance to the endpoints.
    Loads configuration from RaySystemConfig.yaml.
    """
    # Load config directly from RaySystemConfig.yaml
    try:
        config = load_config_file()
        # Create service with config
        service = LLMService(config_dict=config)
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


# Chat Session CRUD Endpoints
@router.post(
    "/chat-sessions/", response_model=ChatSessionResponse, tags=["chat-sessions"]
)
async def create_chat_session(
    chat_session: ChatSessionCreate, session: AsyncSession = Depends(get_db_session)
):
    """
    Create a new chat session with the specified title, model name, and content
    """
    async with session:
        new_session = await kChatSessionManager.create_chat_session(
            title=chat_session.title,
            model_name=chat_session.model_name or "",  # Provide default model
            content_json=chat_session.content_json,
            session=session,
        )
    return ChatSessionResponse.model_validate(new_session, from_attributes=True)


@router.get(
    "/chat-sessions/{session_id}",
    response_model=ChatSessionResponse,
    tags=["chat-sessions"],
)
async def get_chat_session(
    session_id: int, session: AsyncSession = Depends(get_db_session)
):
    """
    Get a specific chat session by ID
    """
    async with session:
        chat_session = await kChatSessionManager.get_chat_session_by_id(
            session_id, session
        )

    if not chat_session:
        raise HTTPException(status_code=404, detail="Chat session not found")

    return ChatSessionResponse.model_validate(chat_session, from_attributes=True)


@router.put(
    "/chat-sessions/{session_id}",
    response_model=ChatSessionResponse,
    tags=["chat-sessions"],
)
async def update_chat_session(
    session_id: int,
    update_data: ChatSessionUpdate,
    session: AsyncSession = Depends(get_db_session),
):
    """
    Update an existing chat session
    """
    async with session:
        updated_session = await kChatSessionManager.update_chat_session(
            session_id=session_id, update_data=update_data, session=session
        )

    if not updated_session:
        raise HTTPException(status_code=404, detail="Chat session not found")

    return ChatSessionResponse.model_validate(updated_session, from_attributes=True)


@router.delete(
    "/chat-sessions/{session_id}", response_model=bool, tags=["chat-sessions"]
)
async def delete_chat_session(
    session_id: int, session: AsyncSession = Depends(get_db_session)
):
    """
    Delete a chat session by ID
    """
    async with session:
        result = await kChatSessionManager.delete_chat_session(session_id, session)

    if not result:
        raise HTTPException(status_code=404, detail="Chat session not found")

    return True


@router.get(
    "/chat-sessions/", response_model=ChatSessionsListResponse, tags=["chat-sessions"]
)
async def list_chat_sessions(
    limit: int = Query(20, description="Maximum number of chat sessions to return"),
    offset: int = Query(0, description="Number of chat sessions to skip"),
    session: AsyncSession = Depends(get_db_session),
):
    """
    List recently updated chat sessions sorted by update time (newest first)
    """
    async with session:
        chat_sessions, total = await kChatSessionManager.get_recent_chat_sessions(
            limit=limit, offset=offset, session=session
        )

    return ChatSessionsListResponse(
        total=total,
        items=[
            ChatSessionResponse.model_validate(session, from_attributes=True)
            for session in chat_sessions
        ],
    )


@router.post("/chat_stream")
async def chat_stream_endpoint(
    request: ChatCompletionRequest,
    llm_service: LLMService = Depends(get_llm_service),  # Inject the service
):
    """
    Stream chat completions as SSE events.

    Returns a real-time stream of partial completion results as they're generated.
    """
    import json
    from datetime import datetime

    # Stream response using Server-Sent Events (SSE)
    async def event_generator() -> AsyncGenerator[str, None]:
        """Generate SSE events from LLM streaming responses."""
        content_so_far = ""
        start_time = datetime.now()

        try:
            # Use the streaming endpoint with our request
            async for chunk_str in llm_service.create_streaming_chat_completion(
                request
            ):
                content_so_far += chunk_str

                # Format the chunk as a JSON event
                event_data = json.dumps({"content": chunk_str, "done": False})
                yield f"data: {event_data}\n\n"
                await asyncio.sleep(0)  # Force yield to client

            # Send completion event with full content
            complete_data = json.dumps(
                {
                    "content": content_so_far,
                    "done": True,
                    "model": request.model_name or llm_service.default_model_name,
                }
            )
            yield f"event: complete\ndata: {complete_data}\n\n"

            # Log completion
            end_time = datetime.now()
            duration = (end_time - start_time).total_seconds()
            print(f"[LLM] Streaming completion finished in {duration:.2f} seconds")

        except Exception as e:
            print(f"Error during LLM streaming: {e}")
            # Send error event to client
            error_data = json.dumps(
                {"error": "处理流式请求时发生意外错误", "done": True}
            )
            yield f"event: error\ndata: {error_data}\n\n"

    # Return the server-sent events response
    return StreamingResponse(
        event_generator(),
        media_type="text/event-stream",
        headers={
            "Cache-Control": "no-cache, no-transform",
            "Connection": "keep-alive",
            "X-Accel-Buffering": "no",  # Disable proxy buffering
            "Content-Type": "text/event-stream",  # Explicitly set content type
        },
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
    import uuid
    import traceback
    from datetime import datetime

    # Generate request ID for tracking
    req_id = str(uuid.uuid4())[:8]
    start_time = datetime.now()
    print(f"[{req_id}] API request started: {start_time.strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"[{req_id}] Requested model: {request.model_name or 'default'}")
    print(f"[{req_id}] Number of messages: {len(request.messages)}")

    try:
        # Call the LLM service to process the request
        response = await llm_service.create_chat_completion(request)

        end_time = datetime.now()
        duration = (end_time - start_time).total_seconds()
        print(f"[{req_id}] API request successful, time: {duration:.2f} seconds")

        # Validate the response is valid
        if (
            response
            and hasattr(response, "message")
            and hasattr(response.message, "content")
        ):
            content_length = len(response.message.content)
            print(f"[{req_id}] Response content length: {content_length}")
            if content_length == 0:
                print(f"[{req_id}] Warning: Response content is empty")

        return response
    except OpenAIError as e:
        # Handle OpenAI SDK specific errors
        end_time = datetime.now()
        duration = (end_time - start_time).total_seconds()
        print(f"[{req_id}] LLM API error, time: {duration:.2f} seconds, error: {e}")
        print(f"[{req_id}] Error type: {type(e).__name__}")

        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail=(f"LLM service error: {e}"),
        )
    except ValueError as e:
        # Handle validation errors or internal logic errors
        end_time = datetime.now()
        duration = (end_time - start_time).total_seconds()
        print(f"[{req_id}] Value error, time: {duration:.2f} seconds, error: {e}")
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))
    except Exception as e:
        # Handle all other unexpected errors
        end_time = datetime.now()
        duration = (end_time - start_time).total_seconds()
        print(
            f"[{req_id}] Unexpected error, time: {duration:.2f} seconds, type: {type(e).__name__}, error: {e}"
        )
        # Log full stack trace
        print(f"[{req_id}] Full stack trace:")
        print(traceback.format_exc())

        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="An unexpected error occurred while processing the chat request",
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
