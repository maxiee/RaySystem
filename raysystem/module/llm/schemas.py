from pydantic import BaseModel, Field
from typing import List, Dict, Optional
from datetime import datetime


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


# Chat Session Schemas
class ChatSessionBase(BaseModel):
    """Base schema for chat sessions."""

    title: str
    model_name: Optional[str] = ""
    content_json: str


class ChatSessionCreate(ChatSessionBase):
    """Schema for creating a new chat session."""

    pass


class ChatSessionUpdate(BaseModel):
    """Schema for updating an existing chat session."""

    title: Optional[str] = None
    model_name: Optional[str] = None
    content_json: Optional[str] = None


class ChatSessionResponse(ChatSessionBase):
    """Schema for chat session responses."""

    id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class ChatSessionsListResponse(BaseModel):
    """Schema for listing multiple chat sessions."""

    total: int
    items: List[ChatSessionResponse]


class ListModelsResponse(BaseModel):
    """Response body for the list models endpoint."""

    models: List[ModelInfo] = Field(..., description="List of available models")
    default_model: str = Field(..., description="The name of the default model")
