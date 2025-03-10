from datetime import datetime
from sqlalchemy import Integer, String, DateTime
from sqlalchemy.orm import Mapped, mapped_column
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
    
    # Note creation timestamp
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.now)
    
    # Note last update timestamp
    updated_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.now, onupdate=datetime.now)