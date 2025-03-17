from datetime import datetime
from sqlalchemy import Integer, String, DateTime, ForeignKey, Boolean
from sqlalchemy.orm import Mapped, mapped_column, relationship, backref
from module.db.base import Base

class Note(Base):
    """
    Note - stores user notes with AppFlowy editor content
    """
    __tablename__ = "note"
    
    # Note ID (primary key)
    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    
    # Note title
    title: Mapped[str] = mapped_column(String, index=True)
    
    # Note content in AppFlowy editor JSON format (stored as string)
    content_appflowy: Mapped[str] = mapped_column(String)
    
    # Parent note ID for hierarchical structure
    parent_id: Mapped[int | None] = mapped_column(ForeignKey("note.id"), nullable=True, index=True)
    
    # Flag indicating if this note has children
    has_children: Mapped[bool] = mapped_column(Boolean, default=False, index=True)
    
    # Relationship with parent and children
    # 不指定cascade参数，默认就是save-update, merge, refresh-expire
    # 显式不包含delete和delete-orphan，这样删除父节点时不会自动删除子节点
    children = relationship("Note", backref=backref("parent", remote_side=[id]))
    
    # Note creation timestamp
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.now)
    
    # Note last update timestamp
    updated_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.now, onupdate=datetime.now)