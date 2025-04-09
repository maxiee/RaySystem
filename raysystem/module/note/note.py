from datetime import datetime
from typing import List, Optional, Tuple
from sqlalchemy import select, or_, desc, func, and_
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import joinedload
from module.db.db import db_async_session
from module.note.model import Note, NoteTitle
from module.note.schema import NoteTitleCreate


class NoteManager:
    """
    Manages CRUD operations for notes
    """

    def __init__(self):
        """
        Initialize NoteManager
        """
        pass

    async def create_note(
        self,
        titles: List[NoteTitleCreate],
        content_appflowy: str,
        parent_id: Optional[int] = None,
        session: Optional[AsyncSession] = None,
    ) -> Note:
        """
        Create a new note with the given title and content

        Args:
            title: Note title
            content_appflowy: Content in AppFlowy editor JSON format (as string)
            parent_id: Optional parent note ID for hierarchical structure
            session: Database session to use (required)

        Returns:
            The newly created Note object
        """
        if session is None:
            raise ValueError("Session is required for create_note")

        # If parent_id is provided, verify it exists
        if parent_id is not None:
            parent_note = await self.get_note_by_id(parent_id, session)
            if parent_note is None:
                raise ValueError(f"Parent note with ID {parent_id} does not exist")

            # Check for circular reference (though this should be impossible for a new note)
            if await self._would_create_cycle(None, parent_id, session):
                raise ValueError("Cannot create note: would create circular reference")

        # Create the note object first without the title
        note = Note(
            content_appflowy=content_appflowy,
            parent_id=parent_id,
            created_at=datetime.now(),
            updated_at=datetime.now(),
        )

        # Add the note to the session and flush to get an ID
        session.add(note)
        await session.flush()

        # 确保至少有一个主标题
        has_primary = any(title.is_primary for title in titles)
        # 如果提供的标题列表为空，创建一个默认标题
        if not titles:
            note_title = NoteTitle(note_id=note.id, title="无标题笔记", is_primary=True)
            session.add(note_title)
            return note
        else:
            # 如果没有指定主标题，将第一个标题设为主标题
            if not has_primary and titles:
                titles[0].is_primary = True

            # 创建所有提供的标题
            for title_data in titles:
                note_title = NoteTitle(
                    note_id=note.id,
                    title=title_data.title,
                    is_primary=title_data.is_primary,
                )
                session.add(note_title)

        # Commit the changes
        await session.commit()
        await session.refresh(note)
        return note

    async def update_note(
        self,
        note_id: int,
        content_appflowy: str,
        parent_id: Optional[int] = None,
        session: Optional[AsyncSession] = None,
    ) -> Optional[Note]:
        """
        Update an existing note

        Note: This method does NOT update note titles. Use title-specific methods for that.

        Args:
            note_id: ID of the note to update
            content_appflowy: New content in AppFlowy editor JSON format
            parent_id: New parent ID (can be None to move to root level)
            session: Database session to use (required)

        Returns:
            Updated Note object or None if note doesn't exist
        """
        if session is None:
            raise ValueError("Session is required for update_note")

        note = await self.get_note_by_id(note_id, session)
        if not note:
            return None

        # Check if parent_id would create a circular reference
        if parent_id is not None and parent_id != note.parent_id:
            if await self._would_create_cycle(note_id, parent_id, session):
                raise ValueError("Cannot update note: would create circular reference")

        # Update content if provided
        if content_appflowy is not None:
            note.content_appflowy = content_appflowy

        note.updated_at = datetime.now()

        # Only update parent_id if it's explicitly provided
        if parent_id is not None and parent_id != note.parent_id:
            # If parent_id is 0, set it to None (root level)
            note.parent_id = None if parent_id == 0 else parent_id

            # If this note becomes a child, update the parent's has_children flag
            if note.parent_id is not None:
                parent = await self.get_note_by_id(note.parent_id, session)  # type: ignore
                if parent and not parent.has_children:
                    parent.has_children = True

        await session.commit()
        await session.refresh(note)
        return note

    async def get_note_by_id(
        self, note_id: int, session: Optional[AsyncSession] = None
    ) -> Optional[Note]:
        """
        Retrieve a note by its ID

        Args:
            note_id: ID of the note to retrieve
            session: Database session to use (required)

        Returns:
            Note object or None if not found
        """
        if session is None:
            raise ValueError("Session is required for get_note_by_id")

        result = await session.execute(
            select(Note)
            .filter(Note.id == note_id)
            .options(joinedload(Note.note_titles))
            .options(joinedload(Note.children))
        )
        return result.scalars().first()

    async def delete_note(
        self, note_id: int, session: Optional[AsyncSession] = None
    ) -> bool:
        """
        Delete a note by its ID and reassign its children to the deleted note's parent.

        When a note is deleted:
        1. If it has children, all children will be moved to have the same parent as the deleted note
           (or become root notes if the deleted note was a root note)
        2. This ensures no child notes are orphaned or deleted when deleting a parent note

        Args:
            note_id: ID of the note to delete
            session: Database session to use (required)

        Returns:
            True if note was deleted, False if note wasn't found
        """
        if session is None:
            raise ValueError("Session is required for delete_note")

        # Get note with its children
        result = await session.execute(
            select(Note).filter(Note.id == note_id).options(joinedload(Note.children))
        )
        note = result.scalars().first()

        if not note:
            return False

        # Store grandparent_id (which could be None for root notes)
        grandparent_id = note.parent_id

        # Now delete the note
        await session.delete(note)
        await session.flush()

        # Reparent all children to the grandparent
        if note.children:
            for child in note.children:
                child.parent_id = grandparent_id
                child.updated_at = datetime.now()

            # Flush to ensure children are updated before deleting parent
            await session.flush()

        await session.commit()
        return True

    async def search_notes_by_title(
        self,
        search_term: str,
        limit: int = 20,
        offset: int = 0,
        session: Optional[AsyncSession] = None,
    ) -> List[Note]:
        """
        Search notes by title (fuzzy search)

        Args:
            search_term: Term to search for in note titles
            limit: Maximum number of results to return
            offset: Number of results to skip (for pagination)
            session: Database session to use (required)

        Returns:
            List of matching Note objects
        """
        if session is None:
            raise ValueError("Session is required for search_notes_by_title")

        # Join with NoteTitle to search in title field
        result = await session.execute(
            select(Note)
            .join(NoteTitle, Note.id == NoteTitle.note_id)
            .filter(NoteTitle.title.ilike(f"%{search_term}%"))
            .options(joinedload(Note.note_titles))
            .order_by(desc(Note.updated_at))
            .limit(limit)
            .offset(offset)
            .distinct()  # Prevent duplicate notes when they have multiple matching titles
        )
        return list(result.scalars().all())

    async def get_recently_updated_notes(
        self, limit: int = 20, offset: int = 0, session: Optional[AsyncSession] = None
    ) -> List[Note]:
        """
        Get recently updated notes ordered by update time

        Args:
            limit: Maximum number of results to return
            offset: Number of results to skip (for pagination)
            session: Database session to use (required)

        Returns:
            List of Note objects ordered by update time (newest first)
        """
        if session is None:
            raise ValueError("Session is required for get_recently_updated_notes")

        result = await session.execute(
            select(Note).order_by(desc(Note.updated_at)).limit(limit).offset(offset)
        )
        return list(result.scalars().all())

    async def get_total_notes_count(
        self, session: Optional[AsyncSession] = None
    ) -> int:
        """
        Get the total number of notes in the database

        Args:
            session: Database session to use (required)

        Returns:
            Total number of notes
        """
        if session is None:
            raise ValueError("Session is required for get_total_notes_count")

        result = await session.execute(select(func.count()).select_from(Note))
        return result.scalar_one()

    # --- Tree-related operations ---

    async def move_note(
        self,
        note_id: int,
        new_parent_id: Optional[int] = None,
        session: Optional[AsyncSession] = None,
    ) -> Optional[Note]:
        """
        Move a note to a new parent

        Args:
            note_id: ID of the note to move
            new_parent_id: ID of the new parent, or None to move to root level
            session: Database session to use (required)

        Returns:
            Updated Note object or None if note doesn't exist
        """
        if session is None:
            raise ValueError("Session is required for move_note")

        # Fetch the note directly within this session context
        result = await session.execute(
            select(Note).filter(Note.id == note_id).options(
                joinedload(Note.children),
                joinedload(Note.note_titles)  # Also load note_titles relationship
            )
        )
        note = result.scalars().first()

        if not note:
            return None

        # Don't do anything if parent_id isn't changing
        if note.parent_id == new_parent_id:
            return note

        # Check if new_parent_id would create a circular reference
        if new_parent_id is not None and await self._would_create_cycle(
            note_id, new_parent_id, session
        ):
            raise ValueError("Cannot move note: would create circular reference")

        # Store old parent ID before updating
        old_parent_id = note.parent_id
        
        # Update parent and save
        note.parent_id = new_parent_id
        note.updated_at = datetime.now()
        
        # Update has_children flag for new parent (if applicable)
        if new_parent_id is not None:
            new_parent = await self.get_note_by_id(new_parent_id, session)
            if new_parent and not new_parent.has_children:
                new_parent.has_children = True
                
        # Update has_children flag for old parent (if applicable)
        if old_parent_id is not None:
            # Check if the old parent still has other children
            old_parent_children_count = await session.execute(
                select(func.count()).select_from(Note).filter(
                    and_(Note.parent_id == old_parent_id, Note.id != note_id)
                )
            )
            remaining_children = old_parent_children_count.scalar_one()
            
            # If no children remain, update the old parent's has_children flag
            if remaining_children == 0:
                old_parent = await self.get_note_by_id(old_parent_id, session)
                if old_parent:
                    old_parent.has_children = False

        await session.commit()
        await session.refresh(note)
        return note

    async def get_note_path(
        self, note_id: int, session: Optional[AsyncSession] = None
    ) -> List[Note]:
        """
        Get the complete path from root to the specified note

        Args:
            note_id: ID of the note to get path for
            session: Database session to use (required)

        Returns:
            List of Note objects representing the path, starting from root
        """
        if session is None:
            raise ValueError("Session is required for get_note_path")

        path = []

        # Start with the requested note
        current = await self.get_note_by_id(note_id, session)
        if not current:
            return []

        # Add current note to the path
        path.append(current)

        # Follow parent references up to the root
        while current.parent_id is not None:
            parent = await self.get_note_by_id(current.parent_id, session)
            if not parent:  # This shouldn't happen if DB integrity is maintained
                break

            path.insert(0, parent)  # Insert at beginning to build path from root
            current = parent

        return path

    async def _would_create_cycle(
        self,
        note_id: Optional[int],
        parent_id: int,
        session: Optional[AsyncSession] = None,
    ) -> bool:
        """
        Check if setting parent_id for note_id would create a circular reference

        Args:
            note_id: ID of the note to check (can be None for new notes)
            parent_id: Proposed parent ID
            session: Database session to use (required)

        Returns:
            True if it would create a cycle, False otherwise
        """
        if session is None:
            raise ValueError("Session is required for _would_create_cycle")

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
            result = await session.execute(
                select(Note.parent_id).filter(Note.id == current_id)
            )
            current_id = result.scalar_one_or_none()

        return False

    async def add_title_to_note(
        self,
        note_id: int,
        title: str,
        is_primary: bool = False,
        session: Optional[AsyncSession] = None,
    ) -> Optional[NoteTitle]:
        """
        Add a new title to an existing note

        Args:
            note_id: ID of the note
            title: Title text
            is_primary: Whether this is the primary title
            session: Database session to use (required)

        Returns:
            The newly created NoteTitle or None if note doesn't exist
        """
        if session is None:
            raise ValueError("Session is required for add_title_to_note")

        note = await self.get_note_by_id(note_id, session)
        if not note:
            return None

        # If this will be primary, update other titles
        if is_primary:
            for title_obj in note.note_titles:
                if title_obj.is_primary:
                    title_obj.is_primary = False

        # Create new title
        new_title = NoteTitle(note_id=note_id, title=title, is_primary=is_primary)
        session.add(new_title)

        # Update note's updated_at time
        note.updated_at = datetime.now()

        await session.commit()
        await session.refresh(new_title)
        return new_title

    async def update_note_title(
        self,
        title_id: int,
        title: Optional[str] = None,
        is_primary: Optional[bool] = None,
        session: Optional[AsyncSession] = None,
    ) -> Optional[NoteTitle]:
        """
        Update an existing note title

        Args:
            title_id: ID of the title to update
            title: New title text (None to leave unchanged)
            is_primary: Whether this is primary (None to leave unchanged)
            session: Database session to use (required)

        Returns:
            Updated NoteTitle or None if not found
        """
        if session is None:
            raise ValueError("Session is required for update_note_title")

        result = await session.execute(
            select(NoteTitle).filter(NoteTitle.id == title_id)
        )
        title_obj = result.scalars().first()

        if not title_obj:
            return None

        # Get the note
        note = await self.get_note_by_id(title_obj.note_id, session)
        if not note:
            return None

        # Update title text if provided
        if title is not None:
            title_obj.title = title

        # Update primary status if provided
        if is_primary is not None and is_primary != title_obj.is_primary:
            if is_primary:
                # If making this primary, un-set the current primary
                for other_title in note.note_titles:
                    if other_title.id != title_id and other_title.is_primary:
                        other_title.is_primary = False

            # Only allow un-setting primary if there are other titles
            elif len(note.note_titles) > 1:
                # Must have at least one primary title
                has_other_primary = False
                for other_title in note.note_titles:
                    if other_title.id != title_id and other_title.is_primary:
                        has_other_primary = True
                        break

                if not has_other_primary:
                    # Find another title to make primary
                    for other_title in note.note_titles:
                        if other_title.id != title_id:
                            other_title.is_primary = True
                            break

            title_obj.is_primary = is_primary

        # Update note's updated_at time
        note.updated_at = datetime.now()

        await session.commit()
        await session.refresh(title_obj)
        return title_obj

    async def delete_note_title(
        self,
        title_id: int,
        session: Optional[AsyncSession] = None,
    ) -> bool:
        """
        Delete a note title

        Cannot delete a note's only title or its primary title

        Args:
            title_id: ID of the title to delete
            session: Database session to use (required)

        Returns:
            True if deleted, False if cannot delete
        """
        if session is None:
            raise ValueError("Session is required for delete_note_title")

        result = await session.execute(
            select(NoteTitle).filter(NoteTitle.id == title_id)
        )
        title_obj = result.scalars().first()

        if not title_obj:
            return True  # Title doesn't exist, consider it deleted

        # Get the note with all its titles
        note = await self.get_note_by_id(title_obj.note_id, session)
        if not note:
            return False

        # Cannot delete the only title
        if len(note.note_titles) <= 1:
            return False

        # Cannot delete the primary title
        if title_obj.is_primary:
            return False

        # Delete the title
        await session.delete(title_obj)

        # Update note's updated_at time
        note.updated_at = datetime.now()

        await session.commit()
        return True

    async def get_child_notes(
        self,
        parent_id: Optional[int] = None,
        limit: int = 50,
        offset: int = 0,
        session: Optional[AsyncSession] = None,
    ) -> List[Note]:
        """
        Get child notes for a given parent ID

        Args:
            parent_id: Parent note ID, or None for root-level notes
            limit: Maximum number of notes to return
            offset: Number of notes to skip
            session: Database session to use (required)

        Returns:
            List of Note objects that are children of the specified parent
        """
        if session is None:
            raise ValueError("Session is required for get_child_notes")

        # 构建查询
        query = (
            select(Note)
            .options(
                joinedload(Note.children),
                joinedload(Note.note_titles),  # 预加载标题关系
            )
            .filter(Note.parent_id == parent_id)
            .order_by(desc(Note.updated_at))  # 按更新时间降序排列
            .limit(limit)
            .offset(offset)
        )

        result = await session.execute(query)
        # 使用 unique() 避免由于 joinedload 导致的重复记录
        return list(result.scalars().unique())

    async def get_child_notes_count(
        self,
        parent_id: Optional[int] = None,
        session: Optional[AsyncSession] = None,
    ) -> int:
        """
        Get the count of child notes for a given parent ID

        Args:
            parent_id: Parent note ID, or None for root-level notes
            session: Database session to use (required)

        Returns:
            Count of notes that are children of the specified parent
        """
        if session is None:
            raise ValueError("Session is required for get_child_notes_count")

        # 统计子节点数量
        query = (
            select(func.count()).select_from(Note).filter(Note.parent_id == parent_id)
        )
        result = await session.execute(query)
        return result.scalar_one()


# Global note manager instance
kNoteManager = NoteManager()


def init_note():
    """Initialize the note module"""
    print("Note module initialized")
