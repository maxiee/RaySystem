from fastapi import FastAPI, HTTPException, Query
from typing import List, Optional, cast
from pydantic import BaseModel
from datetime import datetime

from module.http.http import APP
from module.note.note import kNoteManager
from module.note.model import Note

# --- Schema definitions ---

class NoteBase(BaseModel):
    title: str
    content_appflowy: str

class NoteCreate(NoteBase):
    pass

class NoteUpdate(NoteBase):
    pass

class NoteResponse(NoteBase):
    id: int
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True

class NotesListResponse(BaseModel):
    total: int
    items: List[NoteResponse]

# Helper function to convert SQLAlchemy Note objects to NoteResponse Pydantic models
def convert_notes_to_response(notes: List[Note]) -> List[NoteResponse]:
    return [NoteResponse.model_validate(note) for note in notes]

# --- API endpoints ---

@APP.post("/notes/", response_model=NoteResponse, tags=["notes"])
async def create_note(note: NoteCreate):
    """
    Create a new note with title and AppFlowy editor content
    """
    result = await kNoteManager.create_note(note.title, note.content_appflowy)
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
    updated_note = await kNoteManager.update_note(note_id, note.title, note.content_appflowy)
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
    offset: int = Query(0, description="Number of notes to skip")
):
    """
    List recently updated notes sorted by update time (newest first)
    """
    notes = await kNoteManager.get_recently_updated_notes(limit, offset)
    total = await kNoteManager.get_total_notes_count()
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

def init_note_api():
    """Initialize note API endpoints"""
    print("Note API initialized")