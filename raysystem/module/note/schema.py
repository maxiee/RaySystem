# 标题
from typing import List, Optional
from pydantic import BaseModel
from datetime import datetime


class NoteTitleBase(BaseModel):
    title: str
    is_primary: bool = False


class NoteTitleCreate(NoteTitleBase):
    pass


class NoteTitleUpdate(NoteTitleBase):
    pass


class NoteTitleResponse(NoteTitleBase):
    id: int
    note_id: int
    created_at: datetime

    class Config:
        from_attributes = True


# 笔记
class NoteBase(BaseModel):
    content_appflowy: str
    parent_id: Optional[int] = None


class NoteCreate(NoteBase):
    titles: List[NoteTitleCreate] = []  # 创建时可以同时提供多个标题


class NoteUpdate(NoteBase):
    pass


class NoteResponse(NoteBase):
    id: int
    note_titles: List[NoteTitleResponse]  # 返回标题列表
    has_children: bool
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class NotesListResponse(BaseModel):
    total: int
    items: List[NoteResponse]


class NoteTreeResponse(BaseModel):
    total: int
    items: List[NoteResponse]
