from datetime import datetime
from sqlalchemy import Integer, String, DateTime, ForeignKey, Boolean, select, func
from sqlalchemy.orm import Mapped, mapped_column, relationship, backref
from sqlalchemy.ext.hybrid import hybrid_property
from module.db.base import Base


class NoteTitle(Base):
    __tablename__ = "note_title"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    note_id: Mapped[int] = mapped_column(ForeignKey("note.id"), nullable=False)
    title: Mapped[str] = mapped_column(String(255), index=True)
    is_primary: Mapped[bool] = mapped_column(Boolean, default=False)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.now)

    note = relationship("Note", back_populates="note_titles")


class Note(Base):
    """
    Note - stores user notes with AppFlowy editor content
    """

    __tablename__ = "note"

    # Note ID (primary key)
    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)

    # Note content in AppFlowy editor JSON format (stored as string)
    content_appflowy: Mapped[str] = mapped_column(String)

    # Parent note ID for hierarchical structure
    parent_id: Mapped[int | None] = mapped_column(
        ForeignKey("note.id"), nullable=True, index=True
    )

    # Flag indicating if this note has children
    has_children: Mapped[bool] = mapped_column(
        Boolean, default=False, index=True, server_default="0"
    )

    # Relationship with parent and children
    # 不指定cascade参数，默认就是save-update, merge, refresh-expire
    # 显式不包含delete和delete-orphan，这样删除父节点时不会自动删除子节点
    children = relationship("Note", backref=backref("parent", remote_side=[id]))

    # Relationship with note titles
    note_titles = relationship(
        "NoteTitle", back_populates="note", cascade="all, delete-orphan"
    )

    # Note creation timestamp
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.now)

    # Note last update timestamp
    updated_at: Mapped[datetime] = mapped_column(
        DateTime, default=datetime.now, onupdate=datetime.now
    )

    @hybrid_property
    def title(self):
        """Get primary title or first title as fallback"""
        # During object initialization, note_titles might not be initialized yet
        # or might be empty, so we need to handle this case
        if not hasattr(self, 'note_titles') or not self.note_titles:
            return ""
            
        primary = next((t for t in self.note_titles if t.is_primary), None)
        if primary:
            return primary.title
        return self.note_titles[0].title if self.note_titles else ""
    
    @title.expression
    def title(cls):
        """SQLAlchemy expression for title property"""
        # This is used for queries: Note.title == "some text"
        # Get the primary title if it exists, otherwise get the first title
        return select(NoteTitle.title).where(
            (NoteTitle.note_id == cls.id) & 
            (NoteTitle.is_primary == True)
        ).scalar_subquery()
    
    def add_title(self, title_text, is_primary=False):
        """Add a new title to this note"""
        # If this will be primary, update other titles
        if is_primary:
            for title in self.note_titles:
                if title.is_primary:
                    title.is_primary = False
        
        # Create new title
        new_title = NoteTitle(
            note=self,
            title=title_text,
            is_primary=is_primary
        )
        self.note_titles.append(new_title)
        return new_title
    
    def get_all_titles(self):
        """Get all title texts for this note"""
        return [title.title for title in self.note_titles]
    
    def set_primary_title(self, title_id):
        """Set a specific title as primary"""
        for title in self.note_titles:
            title.is_primary = (title.id == title_id)