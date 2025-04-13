from fastapi import APIRouter, Depends, HTTPException, status
from typing import List
from openai import OpenAIError

from module.llm.llm import LLMService
from module.llm.middlewares.http import http_tracking_middleware
from module.llm.middlewares.logging import logging_middleware

from .schemas import ChatCompletionRequest, ChatCompletionResponse, ListModelsResponse
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
        http_tracking_middleware,  # Track HTTP-related issues
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
    import uuid
    import traceback
    from datetime import datetime

    # 生成请求ID用于跟踪
    req_id = str(uuid.uuid4())[:8]
    start_time = datetime.now()
    print(f"[{req_id}] API请求开始: {start_time.strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"[{req_id}] 请求模型: {request.model_name or '默认'}")
    print(f"[{req_id}] 请求消息数量: {len(request.messages)}")

    try:
        # 调用LLM服务处理请求
        response = await llm_service.create_chat_completion(request)

        end_time = datetime.now()
        duration = (end_time - start_time).total_seconds()
        print(f"[{req_id}] API请求成功完成，耗时: {duration:.2f}秒")

        # 验证响应是否有效
        if (
            response
            and hasattr(response, "message")
            and hasattr(response.message, "content")
        ):
            content_length = len(response.message.content)
            print(f"[{req_id}] 响应内容长度: {content_length}")
            if content_length == 0:
                print(f"[{req_id}] 警告: 响应内容为空")

        return response
    except OpenAIError as e:
        # 处理OpenAI SDK特定错误
        end_time = datetime.now()
        duration = (end_time - start_time).total_seconds()
        print(f"[{req_id}] LLM API错误，耗时: {duration:.2f}秒，错误: {e}")
        print(f"[{req_id}] 错误类型: {type(e).__name__}")

        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail=(f"LLM服务错误: {e}"),
        )
    except ValueError as e:
        # 处理验证错误或内部逻辑错误
        end_time = datetime.now()
        duration = (end_time - start_time).total_seconds()
        print(f"[{req_id}] 值错误，耗时: {duration:.2f}秒，错误: {e}")
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))
    except Exception as e:
        # 处理所有其他未预期错误
        end_time = datetime.now()
        duration = (end_time - start_time).total_seconds()
        print(
            f"[{req_id}] 未预期错误，耗时: {duration:.2f}秒，类型: {type(e).__name__}，错误: {e}"
        )
        # 记录完整堆栈跟踪
        print(f"[{req_id}] 完整堆栈跟踪:")
        print(traceback.format_exc())

        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="处理聊天请求时发生意外错误",
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
