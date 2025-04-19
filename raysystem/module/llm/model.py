from datetime import datetime
from sqlalchemy import Integer, String, DateTime, ForeignKey, Boolean, select, func
from sqlalchemy.orm import Mapped, mapped_column, relationship
from module.db.base import Base


class ChatSession(Base):
    """
    ChatSession - stores user chat conversations with LLM models
    """

    __tablename__ = "llm_chat_session"

    # Chat session ID (primary key)
    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)

    # Session title
    title: Mapped[str] = mapped_column(String(255), index=True)

    # Model used for this chat session
    model_name: Mapped[str] = mapped_column(String(100), index=True)

    # Chat content in JSON format (stored as string)
    content_json: Mapped[str] = mapped_column(String)

    # Session creation timestamp
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.now)

    # Session last update timestamp
    updated_at: Mapped[datetime] = mapped_column(
        DateTime, default=datetime.now, onupdate=datetime.now
    )
