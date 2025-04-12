import os
from typing import List, Optional, Dict, Any
from openai import AsyncOpenAI, OpenAIError
from .schemas import ChatCompletionRequest, ChatCompletionResponse, ChatMessageOutput
from module.llm.middleware import LLMMiddleware, ChatContext, apply_middleware

# Placeholder: Replace with your actual configuration loading mechanism
# e.g., from raysystem.config import settings
# LLM_SERVICE_URL = settings.get("llm_service")
# LLM_API_KEY = settings.get("llm_key")
# LLM_MODEL_NAME = settings.get("llm_model")

# Using environment variables as fallback/example
LLM_SERVICE_URL = os.getenv(
    "LLM_SERVICE_URL", "http://localhost:8000/v1"
)  # Default to a common local proxy URL
LLM_API_KEY = os.getenv(
    "LLM_API_KEY", "not-needed-for-local"
)  # API key might not be needed for all services
LLM_MODEL_NAME = os.getenv("LLM_MODEL_NAME", "local-model")  # Default model name


class LLMService:
    """Handles interaction with the OpenAI-compatible LLM service."""

    def __init__(
        self,
        base_url: str = LLM_SERVICE_URL,
        api_key: str = LLM_API_KEY,
        default_model: str = LLM_MODEL_NAME,
        middleware: Optional[List[LLMMiddleware]] = None,
    ):
        if not base_url:
            raise ValueError("LLM_SERVICE_URL must be configured.")
        if not default_model:
            raise ValueError("LLM_MODEL_NAME must be configured.")

        self.client = AsyncOpenAI(base_url=base_url, api_key=api_key)
        self.default_model = default_model
        self.middleware = middleware or []
        print(
            f"LLM Service Initialized: URL='{base_url}', Model='{default_model}', Middleware Count={len(self.middleware)}"
        )

    async def create_chat_completion(
        self, request: ChatCompletionRequest
    ) -> ChatCompletionResponse:
        """
        Generates a chat completion using the configured LLM service,
        applying any registered middleware.
        """
        model_to_use = (
            self.default_model
        )  # Add logic to allow overriding via request if needed

        # Prepare context for middleware
        context: ChatContext = {
            "request_messages": [msg.model_dump() for msg in request.messages],
            "model": model_to_use,
            "response_message": None,
            "raw_openai_response": None,
            "error": None,
            "metadata": {},  # For middleware communication
        }

        try:
            # --- Pre-computation/validation middleware hook (if needed) ---
            # await apply_middleware(self.pre_middleware, context) # Example for separate pre/post lists

            # Convert Pydantic models to dicts for the SDK
            messages_dict = context[
                "request_messages"
            ]  # Use potentially modified messages

            # Make the async call to the OpenAI compatible API
            response = await self.client.chat.completions.create(
                model=context["model"],  # Use potentially modified model
                messages=messages_dict,
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
            # Depending on desired behavior, you might raise a specific HTTP exception here
            # or let the post-middleware handle/log it.
            # For now, we store the error and let middleware see it.
        except Exception as e:
            print(f"Error during LLM interaction: {e}")
            context["error"] = e
            # Store unexpected errors as well

        # --- Post-computation/logging middleware hook ---
        # This runs regardless of success or failure, allowing logging/cleanup
        await apply_middleware(self.middleware, context)

        # Final check: if an error occurred and wasn't handled/cleared by middleware
        if context["error"]:
            # Re-raise the original error or a generic one
            raise context["error"]

        # If successful, return the response from the context
        if context["response_message"]:
            # Construct the final API response object
            # Add usage data if available and processed by middleware
            return ChatCompletionResponse(
                message=context["response_message"],
                # usage=context["metadata"].get("token_usage") # Example
            )
        else:
            # Should not happen if error handling is correct, but raise defensively
            raise ValueError("LLM call finished without a response or error.")


# --- Example Middleware (define here or import from middleware.py) ---
async def logging_middleware(context: ChatContext):
    """Logs request and response/error."""
    print("--- LLM Middleware: Logging ---")
    print(f"Model: {context.get('model')}")
    print(f"Request Messages Count: {len(context.get('request_messages', []))}")
    if response := context.get("response_message"):
        print(f"Response Role: {response.role}")
        print(f"Response Content Length: {len(response.content)}")
    if error := context.get("error"):
        print(f"Error Occurred: {type(error).__name__}: {error}")
    if raw_response := context.get("raw_openai_response"):
        # Be careful logging raw response, might contain sensitive info or be large
        # Consider logging only specific parts like usage if available
        usage = raw_response.get("usage")
        if usage:
            print(f"Usage Info: {usage}")
    print("-------------------------------")


# --- Service Instantiation (Example - Adapt to your DI framework) ---
# This instance would typically be created once and injected where needed.
# You can configure the middleware list here.
# llm_service_instance = LLMService(middleware=[logging_middleware])
