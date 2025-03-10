from datetime import datetime
from typing import List, Optional
from sqlalchemy import select, or_, desc
from sqlalchemy.ext.asyncio import AsyncSession

from module.db.db import db_async_session
from module.note.model import Note

class NoteManager:
    """
    Manages CRUD operations for notes
    """
    
    async def create_note(self, title: str, content_appflowy: str) -> Note:
        """
        Create a new note with the given title and content
        
        Args:
            title: Note title
            content_appflowy: Content in AppFlowy editor JSON format (as string)
            
        Returns:
            The newly created Note object
        """
        async with db_async_session() as session:
            note = Note(
                title=title,
                content_appflowy=content_appflowy,
                created_at=datetime.now(),
                updated_at=datetime.now()
            )
            session.add(note)
            await session.commit()
            await session.refresh(note)
            return note
    
    async def update_note(self, note_id: int, title: str, content_appflowy: str) -> Optional[Note]:
        """
        Update an existing note
        
        Args:
            note_id: ID of the note to update
            title: New note title
            content_appflowy: New content in AppFlowy editor JSON format
            
        Returns:
            Updated Note object or None if note doesn't exist
        """
        async with db_async_session() as session:
            note = await self.get_note_by_id(note_id, session)
            if not note:
                return None
                
            note.title = title
            note.content_appflowy = content_appflowy
            note.updated_at = datetime.now()
            
            await session.commit()
            await session.refresh(note)
            return note
    
    async def get_note_by_id(self, note_id: int, session: Optional[AsyncSession] = None) -> Optional[Note]:
        """
        Retrieve a note by its ID
        
        Args:
            note_id: ID of the note to retrieve
            session: Optional database session to use
            
        Returns:
            Note object or None if not found
        """
        if session:
            result = await session.execute(select(Note).filter(Note.id == note_id))
            return result.scalars().first()
        
        async with db_async_session() as session:
            result = await session.execute(select(Note).filter(Note.id == note_id))
            return result.scalars().first()
    
    async def delete_note(self, note_id: int) -> bool:
        """
        Delete a note by its ID
        
        Args:
            note_id: ID of the note to delete
            
        Returns:
            True if note was deleted, False if note wasn't found
        """
        async with db_async_session() as session:
            note = await self.get_note_by_id(note_id, session)
            if not note:
                return False
                
            await session.delete(note)
            await session.commit()
            return True
    
    async def search_notes_by_title(self, search_term: str, limit: int = 20, offset: int = 0) -> List[Note]:
        """
        Search notes by title (fuzzy search)
        
        Args:
            search_term: Term to search for in note titles
            limit: Maximum number of results to return
            offset: Number of results to skip (for pagination)
            
        Returns:
            List of matching Note objects
        """
        async with db_async_session() as session:
            result = await session.execute(
                select(Note)
                .filter(Note.title.ilike(f"%{search_term}%"))
                .order_by(desc(Note.updated_at))
                .limit(limit)
                .offset(offset)
            )
            return list(result.scalars().all())
    
    async def get_recently_updated_notes(self, limit: int = 20, offset: int = 0) -> List[Note]:
        """
        Get recently updated notes ordered by update time
        
        Args:
            limit: Maximum number of results to return
            offset: Number of results to skip (for pagination)
            
        Returns:
            List of Note objects ordered by update time (newest first)
        """
        async with db_async_session() as session:
            result = await session.execute(
                select(Note)
                .order_by(desc(Note.updated_at))
                .limit(limit)
                .offset(offset)
            )
            return list(result.scalars().all())
    
    async def get_total_notes_count(self) -> int:
        """
        Get the total number of notes in the database
        
        Returns:
            Total number of notes
        """
        async with db_async_session() as session:
            result = await session.execute(select(Note))
            return len(list(result.scalars().all()))

# Global note manager instance
kNoteManager = NoteManager()

def init_note():
    """Initialize the note module"""
    print("Note module initialized")