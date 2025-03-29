from fastapi import FastAPI, HTTPException, Query, Depends
from typing import List, Optional, cast
from pydantic import BaseModel
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import joinedload
from sqlalchemy import select
from module.db.db import get_db_session
from module.http.http import APP
from module.note.note import kNoteManager
from module.note.model import Note
from module.note.schema import (
    NoteCreate,
    NoteResponse,
    NoteTitleCreate,
    NoteTitleResponse,
    NoteTitleUpdate,
    NoteTreeResponse,
    NoteUpdate,
    NotesListResponse,
)


# Helper function to convert SQLAlchemy Note objects to NoteResponse Pydantic models
def convert_notes_to_response(notes: List[Note]) -> List[NoteResponse]:
    """
    Convert a list of SQLAlchemy Note objects to Pydantic NoteResponse models
    """
    # 这里使用了 SQLAlchemy 的 from_attributes 来将 SQLAlchemy 对象转换为 Pydantic 模型
    return [NoteResponse.model_validate(note, from_attributes=True) for note in notes]


@APP.post("/notes/", response_model=NoteResponse, tags=["notes"])
async def create_note(
    note: NoteCreate, session: AsyncSession = Depends(get_db_session)
):
    """
    Create a new note with title and AppFlowy editor content
    """
    async with session:
        note_created = await kNoteManager.create_note(
            note.titles, note.content_appflowy, note.parent_id, session
        )
        new_note = await kNoteManager.get_note_by_id(note_created.id, session)

    return NoteResponse.model_validate(new_note)


@APP.get("/notes/{note_id}", response_model=NoteResponse, tags=["notes"])
async def get_note(note_id: int, session: AsyncSession = Depends(get_db_session)):
    """
    Get a specific note by ID
    """
    async with session:
        note = await kNoteManager.get_note_by_id(note_id, session)

    if not note:
        raise HTTPException(status_code=404, detail="Note not found")
    return NoteResponse.model_validate(note)


@APP.put("/notes/{note_id}", response_model=NoteResponse, tags=["notes"])
async def update_note(
    note_id: int, note: NoteUpdate, session: AsyncSession = Depends(get_db_session)
):
    """
    Update an existing note
    """
    async with session:
        updated_note = await kNoteManager.update_note(
            note_id, note.content_appflowy, note.parent_id, session
        )

    if not updated_note:
        raise HTTPException(status_code=404, detail="Note not found")
    return NoteResponse.model_validate(updated_note)


@APP.delete("/notes/{note_id}", response_model=bool, tags=["notes"])
async def delete_note(note_id: int, session: AsyncSession = Depends(get_db_session)):
    """
    Delete a note by ID
    """
    async with session:
        result = await kNoteManager.delete_note(note_id, session)

    if not result:
        raise HTTPException(status_code=404, detail="Note not found")
    return True


@APP.get("/notes/", response_model=NotesListResponse, tags=["notes"])
async def list_recent_notes(
    limit: int = Query(20, description="Maximum number of notes to return"),
    offset: int = Query(0, description="Number of notes to skip"),
    session: AsyncSession = Depends(get_db_session),
):
    """
    List recently updated notes sorted by update time (newest first)
    """
    async with session:
        notes = await kNoteManager.get_recently_updated_notes(limit, offset, session)
        total = await kNoteManager.get_total_notes_count(session)

    response_notes = convert_notes_to_response(notes)
    return NotesListResponse(total=total, items=response_notes)


@APP.get("/notes/search", response_model=NotesListResponse, tags=["notes"])
async def search_notes(
    q: str = Query(..., description="Search query for note titles"),
    limit: int = Query(20, description="Maximum number of notes to return"),
    offset: int = Query(0, description="Number of notes to skip"),
    session: AsyncSession = Depends(get_db_session),
):
    """
    Search notes by title (fuzzy search)
    """
    async with session:
        notes = await kNoteManager.search_notes_by_title(q, limit, offset, session)
        # We could optimize this by implementing a count query, but for simplicity
        # we'll just get all matched notes for now
        total = len(notes) + offset if offset > 0 else len(notes)

    response_notes = convert_notes_to_response(notes)
    return NotesListResponse(total=total, items=response_notes)


# --- Title management endpoints ---


@APP.post(
    "/notes/{note_id}/titles", response_model=NoteTitleResponse, tags=["note-titles"]
)
async def add_note_title(
    note_id: int,
    title_data: NoteTitleCreate,
    session: AsyncSession = Depends(get_db_session),
):
    """
    Add a new title to a note
    """
    async with session:
        new_title = await kNoteManager.add_title_to_note(
            note_id, title_data.title, title_data.is_primary, session
        )

    if not new_title:
        raise HTTPException(status_code=404, detail="Note not found")
    return NoteTitleResponse.model_validate(new_title)


@APP.put(
    "/notes/titles/{title_id}", response_model=NoteTitleResponse, tags=["note-titles"]
)
async def update_note_title(
    title_id: int,
    title_data: NoteTitleUpdate,
    session: AsyncSession = Depends(get_db_session),
):
    """
    Update an existing note title
    """
    async with session:
        updated_title = await kNoteManager.update_note_title(
            title_id, title_data.title, title_data.is_primary, session
        )

    if not updated_title:
        raise HTTPException(status_code=404, detail="Note title not found")
    return NoteTitleResponse.model_validate(updated_title)


@APP.delete("/notes/titles/{title_id}", response_model=bool, tags=["note-titles"])
async def delete_note_title(
    title_id: int, session: AsyncSession = Depends(get_db_session)
):
    """
    Delete a note title

    Note: Cannot delete a note's only title or its primary title
    """
    async with session:
        result = await kNoteManager.delete_note_title(title_id, session)

    if result is False:
        raise HTTPException(
            status_code=400, detail="Cannot delete note's only title or primary title"
        )
    return True


@APP.get(
    "/notes/{note_id}/titles",
    response_model=List[NoteTitleResponse],
    tags=["note-titles"],
)
async def get_note_titles(
    note_id: int, session: AsyncSession = Depends(get_db_session)
):
    """
    Get all titles for a note
    """
    async with session:
        note = await kNoteManager.get_note_by_id(note_id, session)

    if not note:
        raise HTTPException(status_code=404, detail="Note not found")

    return [
        NoteTitleResponse.model_validate(title, from_attributes=True)
        for title in note.note_titles
    ]


# --- Tree-related endpoints ---
@APP.get("/notes/tree/children", response_model=NoteTreeResponse, tags=["notes"])
async def get_child_notes(
    parent_id: Optional[int] = Query(
        None, description="Parent note ID, if None returns root notes"
    ),
    limit: int = Query(50, description="Maximum number of notes to return"),
    offset: int = Query(0, description="Number of notes to skip"),
    session: AsyncSession = Depends(get_db_session),
):
    """
    Get child notes for a given parent_id.
    If parent_id is None, returns root-level notes (notes without a parent).
    If parent_id is 0, it's treated as None (for easier frontend handling).
    """
    # 将 parent_id = 0 转换为 None (便于前端处理)
    if parent_id == 0:
        parent_id = None

    async with session:
        notes = await kNoteManager.get_child_notes(parent_id, limit, offset, session)
        total = await kNoteManager.get_child_notes_count(parent_id, session)

    response_notes = convert_notes_to_response(notes)
    return NoteTreeResponse(total=total, items=response_notes)


@APP.post("/notes/{note_id}/move", response_model=NoteResponse, tags=["notes"])
async def move_note(
    note_id: int,
    new_parent_id: Optional[int] = Query(
        None, description="New parent ID, None for root level"
    ),
    session: AsyncSession = Depends(get_db_session),
):
    """
    Move a note to a new parent. If new_parent_id is None, the note becomes a root note.
    """
    async with session:
        updated_note = await kNoteManager.move_note(note_id, new_parent_id, session)

    if not updated_note:
        raise HTTPException(status_code=404, detail="Note not found")
    return NoteResponse.model_validate(updated_note)


@APP.get("/notes/{note_id}/path", response_model=List[NoteResponse], tags=["notes"])
async def get_note_path(note_id: int, session: AsyncSession = Depends(get_db_session)):
    """
    Get the path from root to the specified note (breadcrumbs)
    """
    async with session:
        path = await kNoteManager.get_note_path(note_id, session)

    if not path:
        raise HTTPException(status_code=404, detail="Note not found")
    return [NoteResponse.model_validate(note) for note in path]


def init_note_api():
    """Initialize note API endpoints"""
    print("Note API initialized")
