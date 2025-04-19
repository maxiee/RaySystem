import os
from typing import List, Optional, Dict, Any, Tuple, Union, cast
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
        temperature: float = 0.7,
        top_p: float = 1.0,
    ):
        self.name = name  # Config name/identifier
        self.base_url = base_url
        self.api_key = api_key
        self.model_name = model_name  # Actual model identifier to send to API
        self.display_name = display_name or name
        self.description = description
        self.temperature = temperature
        self.top_p = top_p
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
    ):
        """Initialize LLM service with multiple model configurations.

        Args:
            config_dict: Optional dictionary with model configurations.
                         If not provided, will load from RaySystemConfig.yaml.
            default_model_name: Optional name of the default model.
                                If not provided, will use the first model in the config.
        """
        self.model_configs: Dict[str, ModelConfig] = {}

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
                temperature=model_cfg.get("temperature", 0.7),
                top_p=model_cfg.get("top_p", 1.0),
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
            f"Default: {self.default_model_name}"
        )

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
        Generates a chat completion using the configured LLM service.

        Args:
            request: Chat completion request containing messages and optional model name

        Returns:
            Response containing the generated message and model used
        """
        # Get the requested model or default
        model_config = self.get_model_config(request.model_name)

        try:
            # Convert message objects to properly typed ChatCompletionMessageParam objects
            messages: List[ChatCompletionMessageParam] = []

            # Process each message based on its role
            for msg in request.messages:
                role = msg.role
                content = msg.content

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
                    # Tool messages require tool_call_id
                    tool_msg: ChatCompletionToolMessageParam = {
                        "role": "tool",
                        "content": content,
                        "tool_call_id": getattr(msg, "tool_call_id", ""),
                    }
                    messages.append(tool_msg)

                else:
                    # Fallback for any other role types
                    print(f"Warning: Unexpected message role: {role}")
                    # Use generic type and cast it
                    generic_msg: Dict[str, str] = {"role": role, "content": content}
                    messages.append(cast(ChatCompletionMessageParam, generic_msg))

            # Make the async call to the OpenAI compatible API using the specific client
            client = model_config.get_client()
            response = await client.chat.completions.create(
                model=model_config.model_name,
                messages=messages,
                temperature=model_config.temperature,
                top_p=model_config.top_p,
            )

            # Process the response
            if response.choices and len(response.choices) > 0:
                message_data = response.choices[0].message
                output_content = getattr(message_data, "content", None) or ""
                output_role = getattr(message_data, "role", "assistant")

                output_message = ChatMessageOutput(
                    role=output_role, content=output_content
                )

                return ChatCompletionResponse(
                    message=output_message,
                    model_used=model_config.name,
                )
            else:
                raise ValueError("LLM response did not contain expected choices.")

        except OpenAIError as e:
            print(f"OpenAI API Error: {e}")
            raise e
        except Exception as e:
            print(f"Error during LLM interaction: {e}")
            raise e

    async def create_streaming_chat_completion(self, request: ChatCompletionRequest):
        """
        Generates a streaming chat completion using the configured LLM service.

        Args:
            request: Chat completion request containing messages and optional model name

        Yields:
            Chunks of the generated response as they become available
        """
        # Get the requested model or default
        model_config = self.get_model_config(request.model_name)

        try:
            # Convert message objects to properly typed ChatCompletionMessageParam objects
            messages: List[ChatCompletionMessageParam] = []

            # Process each message based on its role
            for msg in request.messages:
                role = msg.role
                content = msg.content

                # Create properly typed messages based on role
                if role == "system":
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
                    tool_msg: ChatCompletionToolMessageParam = {
                        "role": "tool",
                        "content": content,
                        "tool_call_id": getattr(msg, "tool_call_id", ""),
                    }
                    messages.append(tool_msg)

                else:
                    print(f"Warning: Unexpected message role: {role}")
                    generic_msg: Dict[str, str] = {"role": role, "content": content}
                    messages.append(cast(ChatCompletionMessageParam, generic_msg))

            # Make the streaming call to the OpenAI compatible API
            client = model_config.get_client()
            stream = await client.chat.completions.create(
                model=model_config.model_name,
                messages=messages,
                temperature=model_config.temperature,
                top_p=model_config.top_p,
                stream=True,  # Enable streaming
            )

            # Stream the response chunks
            accumulated_content = ""

            # Use a regular for loop to prevent any buffering behavior from asyncio
            async for chunk in stream:
                if chunk.choices and len(chunk.choices) > 0:
                    delta = chunk.choices[0].delta
                    content = getattr(delta, "content", None)

                    # Only yield chunks that have content
                    if content:
                        accumulated_content += content
                        # Immediately yield the content
                        yield content

        except OpenAIError as e:
            print(f"OpenAI API Streaming Error: {e}")
            raise e
        except Exception as e:
            print(f"Error during LLM streaming interaction: {e}")
            raise e
