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
    # Optional: Add other parameters like model, temperature, max_tokens if you want to allow overrides per request
    # model: Optional[str] = Field(None, description="Model to use for this completion.")


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
    # Optional: Add usage statistics if needed and available from the LLM service
    # usage: Optional[Dict[str, int]] = Field(None, description="Token usage statistics.")
