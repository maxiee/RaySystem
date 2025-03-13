from datetime import datetime
from typing import List, Optional, Tuple
from sqlalchemy import select, or_, desc, func, and_
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import joinedload
from module.db.db import db_async_session
from module.note.model import Note

class NoteManager:
    """
    Manages CRUD operations for notes
    """

    def __init__(self, session: Optional[AsyncSession] = None):
        """
        Initialize NoteManager with an optional session
        """
        self.session = session or db_async_session()
    
    async def create_note(self, title: str, content_appflowy: str, parent_id: Optional[int] = None) -> Note:
        """
        Create a new note with the given title and content
        
        Args:
            title: Note title
            content_appflowy: Content in AppFlowy editor JSON format (as string)
            parent_id: Optional parent note ID for hierarchical structure
            
        Returns:
            The newly created Note object
        """
        async with self.session as session:
            # If parent_id is provided, verify it exists
            if parent_id is not None:
                parent_note = await self.get_note_by_id(parent_id)
                if parent_note is None:
                    raise ValueError(f"Parent note with ID {parent_id} does not exist")
                
                # Check for circular reference (though this should be impossible for a new note)
                if await self._would_create_cycle(None, parent_id):
                    raise ValueError("Cannot create note: would create circular reference")
            
            note = Note(
                title=title,
                content_appflowy=content_appflowy,
                parent_id=parent_id,
                created_at=datetime.now(),
                updated_at=datetime.now()
            )
            session.add(note)
            await session.commit()
            await session.refresh(note)
            return note
    
    async def update_note(self, 
                          note_id: int, 
                          title: str, 
                          content_appflowy: str, 
                          parent_id: Optional[int] = None) -> Optional[Note]:
        """
        Update an existing note
        
        Args:
            note_id: ID of the note to update
            title: New note title
            content_appflowy: New content in AppFlowy editor JSON format
            parent_id: New parent ID (can be None to move to root level)
            
        Returns:
            Updated Note object or None if note doesn't exist
        """
        async with self.session as session:
            note = await self.get_note_by_id(note_id)
            if not note:
                return None
            
            # Check if parent_id would create a circular reference
            if parent_id is not None and parent_id != note.parent_id:
                if await self._would_create_cycle(note_id, parent_id):
                    raise ValueError("Cannot update note: would create circular reference")
                
            note.title = title
            note.content_appflowy = content_appflowy
            note.updated_at = datetime.now()
            
            # Only update parent_id if it's explicitly provided
            if parent_id != note.parent_id:  # Could be None or a different ID
                note.parent_id = parent_id
            
            await session.commit()
            await session.refresh(note)
            return note
    
    async def get_note_by_id(self, note_id: int) -> Optional[Note]:
        """
        Retrieve a note by its ID
        
        Args:
            note_id: ID of the note to retrieve
            session: Optional database session to use
            
        Returns:
            Note object or None if not found
        """
        async with self.session as session:
            result = await session.execute(
                select(Note)
                .filter(Note.id == note_id)
                .options(joinedload(Note.children))
            )
            return result.scalars().first()
    
    async def delete_note(self, note_id: int) -> bool:
        """
        Delete a note by its ID and reassign its children to the deleted note's parent.
        
        When a note is deleted:
        1. If it has children, all children will be moved to have the same parent as the deleted note
           (or become root notes if the deleted note was a root note)
        2. This ensures no child notes are orphaned or deleted when deleting a parent note
        
        Args:
            note_id: ID of the note to delete
            session: Optional database session to use
            
        Returns:
            True if note was deleted, False if note wasn't found
        """
        async with self.session as session:
            # Get note with its children
            result = await session.execute(
                select(Note)
                .filter(Note.id == note_id)
                .options(joinedload(Note.children))
            )
            note = result.scalars().first()
            
            if not note:
                return False
                
            # Store grandparent_id (which could be None for root notes)
            grandparent_id = note.parent_id
            
            # Reparent all children to the grandparent
            if note.children:
                for child in note.children:
                    child.parent_id = grandparent_id
                    child.updated_at = datetime.now()
                
                # Flush to ensure children are updated before deleting parent
                await session.flush()
            
            # Now delete the note
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
            session: Optional database session to use
            
        Returns:
            List of matching Note objects
        """
        async with self.session as session:
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
            session: Optional database session to use
            
        Returns:
            List of Note objects ordered by update time (newest first)
        """        
        async with self.session as session:
            result = await session.execute(
                select(Note)
                .order_by(desc(Note.updated_at))
                .limit(limit)
                .offset(offset)
                .options(joinedload(Note.children))
            )
            return list(result.scalars().all())
    
    async def get_total_notes_count(self) -> int:
        """
        Get the total number of notes in the database
        
        Returns:
            Total number of notes
        """
        async with self.session as session:
            result = await session.execute(select(func.count()).select_from(Note))
            return result.scalar_one()
    
    # --- Tree-related operations ---
    
    async def get_child_notes(self, 
                              parent_id: Optional[int] = None, 
                              limit: int = 50, 
                              offset: int = 0) -> List[Note]:
        """
        Get child notes for a given parent ID
        
        Args:
            parent_id: ID of the parent note, or None to get root notes
            limit: Maximum number of results to return
            offset: Number of results to skip (for pagination)
            session: Optional database session to use
            
        Returns:
            List of child Note objects
        """
        async with self.session as session:
            query = select(Note).options(joinedload(Note.children))
            
            # If parent_id is None, get notes without parent (root notes)
            if parent_id is None:
                query = query.filter(Note.parent_id.is_(None))
            else:
                query = query.filter(Note.parent_id == parent_id)
            
            result = await session.execute(
                query.order_by(desc(Note.updated_at))
                .limit(limit)
                .offset(offset)
            )
            return list(result.unique().scalars().all())
    
    async def get_child_notes_count(self, parent_id: Optional[int] = None) -> int:
        """
        Get count of child notes for a given parent ID
        
        Args:
            parent_id: ID of the parent note, or None to get root notes count
            session: Optional database session to use
            
        Returns:
            Count of child notes
        """        
        async with self.session as session:
            query = select(func.count()).select_from(Note)
            
            # If parent_id is None, count notes without parent (root notes)
            if parent_id is None:
                query = query.filter(Note.parent_id.is_(None))
            else:
                query = query.filter(Note.parent_id == parent_id)
            
            result = await session.execute(query)
            return result.scalar_one()
    
    async def move_note(self, note_id: int, new_parent_id: Optional[int] = None) -> Optional[Note]:
        """
        Move a note to a new parent
        
        Args:
            note_id: ID of the note to move
            new_parent_id: ID of the new parent, or None to move to root level
            session: Optional database session to use
            
        Returns:
            Updated Note object or None if note doesn't exist
        """
        async with self.session as session:
            note = await self.get_note_by_id(note_id)
            if not note:
                return None
            
            # Don't do anything if parent_id isn't changing
            if note.parent_id == new_parent_id:
                return note
            
            # Check if new_parent_id would create a circular reference
            if new_parent_id is not None and await self._would_create_cycle(note_id, new_parent_id):
                raise ValueError("Cannot move note: would create circular reference")
            
            # Update parent and save
            note.parent_id = new_parent_id
            note.updated_at = datetime.now()
            await session.commit()
            await session.refresh(note)
            return note
    
    async def get_note_path(self, note_id: int) -> List[Note]:
        """
        Get the complete path from root to the specified note
        
        Args:
            note_id: ID of the note to get path for
            session: Optional database session to use
            
        Returns:
            List of Note objects representing the path, starting from root
        """
        path = []
        async with self.session as session:
            # Start with the requested note
            current = await self.get_note_by_id(note_id)
            if not current:
                return []
            
            # Add current note to the path
            path.append(current)
            
            # Follow parent references up to the root
            while current.parent_id is not None:
                parent = await self.get_note_by_id(current.parent_id)
                if not parent:  # This shouldn't happen if DB integrity is maintained
                    break
                
                path.insert(0, parent)  # Insert at beginning to build path from root
                current = parent
            
            return path
    
    async def _would_create_cycle(self, 
                                 note_id: Optional[int], 
                                 parent_id: int) -> bool:
        """
        Check if setting parent_id for note_id would create a circular reference
        
        Args:
            note_id: ID of the note to check (can be None for new notes)
            parent_id: Proposed parent ID
            session: Database session to use
            
        Returns:
            True if it would create a cycle, False otherwise
        """
        # New notes can't create cycles (they can't be in an ancestry chain yet)
        if note_id is None:
            return False
        
        # Self-reference is always a cycle
        if note_id == parent_id:
            return True
        
        # Check if note_id appears in the ancestry chain of parent_id
        current_id = parent_id
        visited = set()
        
        while current_id is not None:
            # Avoid infinite loops if DB already has cycles
            if current_id in visited:
                return True
            
            visited.add(current_id)
            
            # If we encounter the original note_id in the chain, it's a cycle
            if current_id == note_id:
                return True
            
            # Get parent of the current note
            result = await self.session.execute(
                select(Note.parent_id).filter(Note.id == current_id)
            )
            current_id = result.scalar_one_or_none()
            
        return False

# Global note manager instance
kNoteManager = NoteManager()

def init_note():
    """Initialize the note module"""
    print("Note module initialized")