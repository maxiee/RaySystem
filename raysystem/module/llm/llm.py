import os
from typing import List, Optional, Dict, Any, Tuple, Union, cast, TypedDict
from openai import AsyncOpenAI, OpenAIError
from openai.types.chat import (
    ChatCompletionMessageParam,
    ChatCompletionSystemMessageParam,
    ChatCompletionUserMessageParam,
    ChatCompletionAssistantMessageParam,
    ChatCompletionToolMessageParam,
)
from .schemas import (
    ChatCompletionRequest,
    ChatCompletionResponse,
    ChatMessageOutput,
    ModelInfo,
)
from module.llm.middleware import LLMMiddleware, ChatContext, apply_middleware
from utils.config import load_config_file


class ModelConfig:
    """Configuration for a specific LLM model."""

    def __init__(
        self,
        name: str,
        base_url: str,
        api_key: str,
        model_name: str,
        display_name: str = "",
        description: str = "",
    ):
        self.name = name  # Config name/identifier
        self.base_url = base_url
        self.api_key = api_key
        self.model_name = model_name  # Actual model identifier to send to API
        self.display_name = display_name or name
        self.description = description
        self.client = None  # Will be initialized when needed

    def get_client(self) -> AsyncOpenAI:
        """Get or create the AsyncOpenAI client for this model configuration."""
        if self.client is None:
            self.client = AsyncOpenAI(base_url=self.base_url, api_key=self.api_key)
        return self.client


class LLMService:
    """Handles interaction with multiple OpenAI-compatible LLM services."""

    def __init__(
        self,
        config_dict: Dict = {},
        default_model_name: str = "",
        middleware: Optional[List[LLMMiddleware]] = None,
    ):
        """Initialize LLM service with multiple model configurations.

        Args:
            config_dict: Optional dictionary with model configurations.
                         If not provided, will load from RaySystemConfig.yaml.
            default_model_name: Optional name of the default model.
                                If not provided, will use the first model in the config.
            middleware: Optional list of middleware functions to apply.
        """
        self.model_configs: Dict[str, ModelConfig] = {}
        self.middleware = middleware or []

        # Load config from RaySystemConfig.yaml if not provided
        if config_dict is None:
            config_dict = load_config_file()

        # Extract LLM configurations
        llm_config = config_dict.get("llm", {})
        models_config = llm_config.get("models", {})

        # Set up the configured models
        for model_name, model_cfg in models_config.items():
            self.model_configs[model_name] = ModelConfig(
                name=model_name,
                base_url=model_cfg.get("base_url"),
                api_key=model_cfg.get("api_key"),
                model_name=model_cfg.get("model_name"),
                display_name=model_cfg.get("display_name", model_name),
                description=model_cfg.get("description"),
            )

        # Set default model
        self.default_model_name = default_model_name or llm_config.get("default_model")

        # If default not specified or invalid, use the first model
        if (
            not self.default_model_name
            or self.default_model_name not in self.model_configs
        ):
            self.default_model_name = next(iter(self.model_configs.keys()))

        print(
            f"LLM Service Initialized: {len(self.model_configs)} models configured. "
            f"Default: {self.default_model_name}, Middleware Count: {len(self.middleware)}"
        )

    def _setup_from_environment(self):
        """Set up a single model configuration from environment variables (fallback)."""
        # Using environment variables as fallback
        base_url = os.getenv("LLM_SERVICE_URL", "http://localhost:8000/v1")
        api_key = os.getenv("LLM_API_KEY", "not-needed-for-local")
        model_name = os.getenv("LLM_MODEL_NAME", "local-model")

        if not base_url:
            raise ValueError("LLM_SERVICE_URL must be configured.")
        if not model_name:
            raise ValueError("LLM_MODEL_NAME must be configured.")

        # Create a default model config
        self.model_configs["default"] = ModelConfig(
            name="default",
            base_url=base_url,
            api_key=api_key,
            model_name=model_name,
            display_name="Default Model",
            description="Default model from environment variables",
        )
        self.default_model_name = "default"

    def get_model_config(self, model_name: Optional[str] = None) -> ModelConfig:
        """Get model configuration by name, or the default if not specified."""
        name_to_use = model_name or self.default_model_name

        if name_to_use not in self.model_configs:
            raise ValueError(f"Model '{name_to_use}' not found in configuration.")

        return self.model_configs[name_to_use]

    def get_available_models(self) -> Tuple[List[ModelInfo], str]:
        """Get list of available models and the default model name."""
        models = []
        for name, config in self.model_configs.items():
            models.append(
                ModelInfo(
                    name=name,
                    display_name=config.display_name,
                    description=config.description,
                )
            )
        return models, self.default_model_name

    async def create_chat_completion(
        self, request: ChatCompletionRequest
    ) -> ChatCompletionResponse:
        """
        Generates a chat completion using the configured LLM service,
        applying any registered middleware.

        Args:
            request: Chat completion request containing messages and optional model name

        Returns:
            Response containing the generated message and model used
        """
        # Get the requested model or default
        model_config = self.get_model_config(request.model_name)

        # Prepare context for middleware
        context: ChatContext = {
            "request_messages": [msg.model_dump() for msg in request.messages],
            "model": model_config.model_name,
            "model_config_name": model_config.name,
            "response_message": None,
            "raw_openai_response": None,
            "error": None,
            "metadata": {},  # For middleware communication
        }

        try:
            # Convert message dicts to properly typed ChatCompletionMessageParam objects
            messages: List[ChatCompletionMessageParam] = []

            # Process each message based on its role
            for msg in context["request_messages"]:
                role = msg.get("role", "")
                content = msg.get("content", "")

                # Create properly typed messages based on role
                if role == "system":
                    # Type hint for the type checker
                    system_msg: ChatCompletionSystemMessageParam = {
                        "role": "system",
                        "content": content,
                    }
                    messages.append(system_msg)

                elif role == "user":
                    user_msg: ChatCompletionUserMessageParam = {
                        "role": "user",
                        "content": content,
                    }
                    messages.append(user_msg)

                elif role == "assistant":
                    assistant_msg: ChatCompletionAssistantMessageParam = {
                        "role": "assistant",
                        "content": content,
                    }
                    messages.append(assistant_msg)

                elif role == "tool":
                    # Tool messages require tool_call_id and name
                    tool_msg: ChatCompletionToolMessageParam = {
                        "role": "tool",
                        "content": content,
                        "tool_call_id": msg.get(
                            "tool_call_id", ""
                        ),  # Required for tool messages
                    }

                    messages.append(tool_msg)

                else:
                    # Fallback for any other role types
                    # Note: This should not normally happen with properly validated input
                    print(f"Warning: Unexpected message role: {role}")
                    # Use generic type and cast it
                    generic_msg: Dict[str, str] = {"role": role, "content": content}
                    messages.append(cast(ChatCompletionMessageParam, generic_msg))

            # Make the async call to the OpenAI compatible API using the specific client
            client = model_config.get_client()
            response = await client.chat.completions.create(
                model=context["model"],
                messages=messages,
                # Add other parameters like temperature, max_tokens if needed
            )

            context["raw_openai_response"] = response.model_dump()

            # Process the response - adapt based on actual API response structure
            if response.choices and len(response.choices) > 0:
                message_data = response.choices[0].message
                output_content = getattr(message_data, "content", None) or ""
                output_role = getattr(message_data, "role", "assistant")

                output_message = ChatMessageOutput(
                    role=output_role, content=output_content
                )
                context["response_message"] = output_message
            else:
                raise ValueError("LLM response did not contain expected choices.")

        except OpenAIError as e:
            print(f"OpenAI API Error: {e}")
            context["error"] = e
        except Exception as e:
            print(f"Error during LLM interaction: {e}")
            context["error"] = e

        # Apply middleware
        await apply_middleware(self.middleware, context)

        # Check for errors
        if context["error"]:
            raise context["error"]

        # If successful, return the response from the context
        if context["response_message"]:
            return ChatCompletionResponse(
                message=context["response_message"],
                model_used=context["model_config_name"],
                # usage=context.get("metadata", {}).get("token_usage")  # If available
            )
        else:
            raise ValueError("LLM call finished without a response or error.")


# --- Example Middleware (define here or import from middleware.py) ---
async def logging_middleware(context: ChatContext):
    """简化的日志中间件，记录请求和响应信息。"""
    import uuid
    from datetime import datetime

    # 生成或获取请求ID
    req_id = context.get("metadata", {}).get("request_id")
    if not req_id:
        req_id = str(uuid.uuid4())[:8]
        if "metadata" not in context:
            context["metadata"] = {}
        context["metadata"]["request_id"] = req_id

    # 打印基本请求信息
    print(f"=== LLM请求 [{req_id}] ===")
    print(f"模型: {context.get('model')}")
    print(f"模型配置: {context.get('model_config_name')}")
    print(f"请求消息数量: {len(context.get('request_messages', []))}")

    # 打印响应信息
    if response := context.get("response_message"):
        print(f"=== LLM响应 [{req_id}] ===")
        print(f"响应角色: {response.role}")
        print(f"响应内容长度: {len(response.content)}")

        # 检查内容是否为空
        if not response.content:
            print(f"警告: 响应内容为空")

    # 打印错误信息
    if error := context.get("error"):
        print(f"=== LLM错误 [{req_id}] ===")
        print(f"错误类型: {type(error).__name__}")
        print(f"错误信息: {error}")

    # 打印使用统计
    if raw_response := context.get("raw_openai_response"):
        usage = raw_response.get("usage")
        if usage:
            print(f"使用统计: {usage}")

    print(f"=== LLM交互结束 [{req_id}] ===")
