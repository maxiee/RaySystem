from pydantic import BaseModel, Field
from typing import List, Dict, Optional


class ChatMessageInput(BaseModel):
    """Represents a single message in the chat history (input)."""

    role: str = Field(
        ...,
        description="Role of the message sender (e.g., 'user', 'assistant', 'system')",
    )
    content: str = Field(..., description="Content of the message")


class ChatCompletionRequest(BaseModel):
    """Request body for the chat completion endpoint."""

    messages: List[ChatMessageInput] = Field(
        ..., description="A list of messages comprising the conversation history."
    )
    model_name: Optional[str] = Field(
        None,
        description="Name of the model to use for this completion. If not provided, the default model will be used.",
    )


class ChatMessageOutput(BaseModel):
    """Represents the generated message from the LLM (output)."""

    role: str = Field(
        ..., description="Role of the message sender (usually 'assistant')"
    )
    content: str = Field(..., description="Content of the generated message")


class ChatCompletionResponse(BaseModel):
    """Response body for the chat completion endpoint."""

    message: ChatMessageOutput = Field(
        ..., description="The generated chat message from the assistant."
    )
    model_used: str = Field(
        ..., description="The name of the model used for this completion."
    )
    # Optional: Add usage statistics if needed and available from the LLM service
    # usage: Optional[Dict[str, int]] = Field(None, description="Token usage statistics.")


class ModelInfo(BaseModel):
    """Information about an available LLM model."""

    name: str = Field(
        ...,
        description="The name of the model, used as identifier when requesting completions",
    )
    display_name: str = Field(
        ..., description="User-friendly display name for the model"
    )
    description: Optional[str] = Field(
        None, description="Optional description of the model capabilities"
    )


class ListModelsResponse(BaseModel):
    """Response body for the list models endpoint."""

    models: List[ModelInfo] = Field(..., description="List of available models")
    default_model: str = Field(..., description="The name of the default model")
