from fastapi import FastAPI, HTTPException, Query, Depends
from typing import List, Optional, cast
from pydantic import BaseModel
from datetime import datetime
from sqlalchemy.ext.asyncio import AsyncSession
from module.db.db import get_db_session
from module.http.http import APP
from module.note.note import kNoteManager
from module.note.model import Note

# --- Schema definitions ---

class NoteBase(BaseModel):
    title: str
    content_appflowy: str

class NoteCreate(NoteBase):
    parent_id: Optional[int] = None

class NoteUpdate(NoteBase):
    parent_id: Optional[int] = None

class NoteResponse(NoteBase):
    id: int
    parent_id: Optional[int] = None
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True

class NoteTreeNode(NoteResponse):
    has_children: bool
    
class NotesListResponse(BaseModel):
    total: int
    items: List[NoteResponse]

class NoteTreeResponse(BaseModel):
    total: int
    items: List[NoteTreeNode]

# Helper function to convert SQLAlchemy Note objects to NoteResponse Pydantic models
def convert_notes_to_response(notes: List[Note]) -> List[NoteResponse]:
    return [NoteResponse.model_validate(note) for note in notes]

# Helper function to convert SQLAlchemy Note objects to NoteTreeNode Pydantic models
def convert_notes_to_tree_nodes(notes: List[Note], with_has_children: bool = True) -> List[NoteTreeNode]:
    result = []
    for note in notes:
        # Use the has_children field from the database directly
        has_children = note.has_children
        # Only calculate if needed and with_has_children flag is True (for backward compatibility)
        if with_has_children and not hasattr(note, 'has_children'):
            has_children = len(note.children) > 0
        
        tree_node = NoteTreeNode(
            id=note.id,
            title=note.title,
            content_appflowy=note.content_appflowy,
            parent_id=note.parent_id,
            created_at=note.created_at,
            updated_at=note.updated_at,
            has_children=has_children
        )
        result.append(tree_node)
    return result

# --- API endpoints ---

@APP.post("/notes/", response_model=NoteResponse, tags=["notes"])
async def create_note(note: NoteCreate):
    """
    Create a new note with title and AppFlowy editor content
    """
    result = await kNoteManager.create_note(
        note.title, 
        note.content_appflowy,
        note.parent_id
    )
    return NoteResponse.model_validate(result)

@APP.get("/notes/{note_id}", response_model=NoteResponse, tags=["notes"])
async def get_note(note_id: int):
    """
    Get a specific note by ID
    """
    note = await kNoteManager.get_note_by_id(note_id)
    if not note:
        raise HTTPException(status_code=404, detail="Note not found")
    return NoteResponse.model_validate(note)

@APP.put("/notes/{note_id}", response_model=NoteResponse, tags=["notes"])
async def update_note(note_id: int, note: NoteUpdate):
    """
    Update an existing note
    """
    updated_note = await kNoteManager.update_note(
        note_id, 
        note.title, 
        note.content_appflowy,
        note.parent_id
    )
    if not updated_note:
        raise HTTPException(status_code=404, detail="Note not found")
    return NoteResponse.model_validate(updated_note)

@APP.delete("/notes/{note_id}", response_model=bool, tags=["notes"])
async def delete_note(note_id: int):
    """
    Delete a note by ID
    """
    result = await kNoteManager.delete_note(note_id)
    if not result:
        raise HTTPException(status_code=404, detail="Note not found")
    return True

@APP.get("/notes/", response_model=NotesListResponse, tags=["notes"])
async def list_recent_notes(
    limit: int = Query(20, description="Maximum number of notes to return"), 
    offset: int = Query(0, description="Number of notes to skip"),
    session: AsyncSession = Depends(get_db_session)
):
    """
    List recently updated notes sorted by update time (newest first)
    """
    notes = await kNoteManager.get_recently_updated_notes(limit, offset, session)
    total = await kNoteManager.get_total_notes_count(session)
    response_notes = convert_notes_to_response(notes)
    return NotesListResponse(total=total, items=response_notes)

@APP.get("/notes/search", response_model=NotesListResponse, tags=["notes"])
async def search_notes(
    q: str = Query(..., description="Search query for note titles"),
    limit: int = Query(20, description="Maximum number of notes to return"),
    offset: int = Query(0, description="Number of notes to skip")
):
    """
    Search notes by title (fuzzy search)
    """
    notes = await kNoteManager.search_notes_by_title(q, limit, offset)
    # We could optimize this by implementing a count query, but for simplicity 
    # we'll just get all matched notes for now
    total = len(notes) + offset if offset > 0 else len(notes) 
    response_notes = convert_notes_to_response(notes)
    return NotesListResponse(total=total, items=response_notes)

# --- Tree-related endpoints ---
@APP.get("/notes/tree/children", response_model=NoteTreeResponse, tags=["notes", "tree"])
async def get_child_notes(
    parent_id: Optional[int] = Query(None, description="Parent note ID, if None returns root notes"),
    limit: int = Query(50, description="Maximum number of notes to return"),
    offset: int = Query(0, description="Number of notes to skip"),
    session: AsyncSession = Depends(get_db_session)
):
    """
    Get child notes for a given parent_id.
    If parent_id is None, returns root-level notes (notes without a parent).
    """
    notes = await kNoteManager.get_child_notes(parent_id, limit, offset, session)
    total = await kNoteManager.get_child_notes_count(parent_id)
    tree_nodes = convert_notes_to_tree_nodes(notes)
    return NoteTreeResponse(total=total, items=tree_nodes)

@APP.post("/notes/{note_id}/move", response_model=NoteResponse, tags=["notes", "tree"])
async def move_note(
    note_id: int,
    new_parent_id: Optional[int] = Query(None, description="New parent ID, None for root level")
):
    """
    Move a note to a new parent. If new_parent_id is None, the note becomes a root note.
    """
    updated_note = await kNoteManager.move_note(note_id, new_parent_id)
    if not updated_note:
        raise HTTPException(status_code=404, detail="Note not found")
    return NoteResponse.model_validate(updated_note)

@APP.get("/notes/{note_id}/path", response_model=List[NoteResponse], tags=["notes", "tree"])
async def get_note_path(note_id: int):
    """
    Get the path from root to the specified note (breadcrumbs)
    """
    path = await kNoteManager.get_note_path(note_id)
    if not path:
        raise HTTPException(status_code=404, detail="Note not found")
    return [NoteResponse.model_validate(note) for note in path]

def init_note_api():
    """Initialize note API endpoints"""
    print("Note API initialized")