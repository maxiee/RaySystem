from datetime import datetime
from typing import List, Optional, Dict, Any, Tuple
from sqlalchemy import select, or_, desc, func, and_
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import joinedload
from module.db.db import db_async_session
from .model import ChatSession
from .schemas import ChatSessionCreate, ChatSessionUpdate


class ChatSessionManager:
    """
    Manages CRUD operations for LLM chat sessions
    """

    def __init__(self):
        """
        Initialize ChatSessionManager
        """
        pass

    async def create_chat_session(
        self,
        title: str,
        model_name: str,
        content_json: str,
        session: Optional[AsyncSession] = None,
    ) -> ChatSession:
        """
        Create a new chat session with the given title, model name, and content

        Args:
            title: Chat session title
            model_name: The LLM model used for this chat session
            content_json: Chat content in JSON format (as string)
            session: Database session to use (required)

        Returns:
            The newly created ChatSession object
        """
        if session is None:
            raise ValueError("Session is required for create_chat_session")

        # Create the chat session object
        chat_session = ChatSession(
            title=title,
            model_name=model_name,
            content_json=content_json,
            created_at=datetime.now(),
            updated_at=datetime.now(),
        )

        # Add the chat session to the session
        session.add(chat_session)
        await session.commit()
        await session.refresh(chat_session)
        return chat_session

    async def get_chat_session_by_id(
        self, session_id: int, session: AsyncSession
    ) -> Optional[ChatSession]:
        """
        Get a chat session by its ID

        Args:
            session_id: ID of the chat session to retrieve
            session: Database session to use

        Returns:
            ChatSession object if found, None otherwise
        """
        result = await session.execute(
            select(ChatSession).where(ChatSession.id == session_id)
        )
        return result.scalars().first()

    async def update_chat_session(
        self,
        session_id: int,
        update_data: ChatSessionUpdate,
        session: AsyncSession,
    ) -> Optional[ChatSession]:
        """
        Update an existing chat session

        Args:
            session_id: ID of the chat session to update
            update_data: Data to update in the chat session
            session: Database session to use

        Returns:
            Updated ChatSession object if found, None otherwise
        """
        chat_session = await self.get_chat_session_by_id(session_id, session)

        if not chat_session:
            return None

        # Update the fields that are provided in the update_data
        if update_data.title is not None:
            chat_session.title = update_data.title
        if update_data.model_name is not None:
            chat_session.model_name = update_data.model_name
        if update_data.content_json is not None:
            chat_session.content_json = update_data.content_json

        # Update timestamp
        chat_session.updated_at = datetime.now()

        # Save the changes
        await session.commit()
        await session.refresh(chat_session)
        return chat_session

    async def delete_chat_session(self, session_id: int, session: AsyncSession) -> bool:
        """
        Delete a chat session by ID

        Args:
            session_id: ID of the chat session to delete
            session: Database session to use

        Returns:
            True if the chat session was deleted, False if not found
        """
        chat_session = await self.get_chat_session_by_id(session_id, session)

        if not chat_session:
            return False

        await session.delete(chat_session)
        await session.commit()
        return True

    async def get_recent_chat_sessions(
        self, limit: int, offset: int, session: AsyncSession
    ) -> Tuple[List[ChatSession], int]:
        """
        List recently updated chat sessions sorted by update time (newest first)

        Args:
            limit: Maximum number of chat sessions to return
            offset: Number of chat sessions to skip
            session: Database session to use

        Returns:
            A tuple of (list of chat sessions, total count)
        """
        # Get total count
        result = await session.execute(select(func.count()).select_from(ChatSession))
        total = result.scalar_one()

        # Get chat sessions
        result = await session.execute(
            select(ChatSession)
            .order_by(desc(ChatSession.updated_at))
            .offset(offset)
            .limit(limit)
        )

        chat_sessions = result.scalars().all()
        return list(chat_sessions), total


# Create a global instance of the manager
kChatSessionManager = ChatSessionManager()
