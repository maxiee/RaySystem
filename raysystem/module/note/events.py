from sqlalchemy import event, select, update, func
from module.note.model import Note

@event.listens_for(Note, 'after_insert')
def update_parent_has_children_on_insert(mapper, connection, target):
    """Update parent's has_children flag when a note is inserted"""
    # Skip if no parent
    if target.parent_id is None:
        return
        
    # Update parent's has_children flag to True since we're adding a child
    connection.execute(
        update(Note).
        where(Note.id == target.parent_id).
        values(has_children=True)
    )

@event.listens_for(Note, 'after_delete')
def update_parent_has_children_on_delete(mapper, connection, target):
    """Update parent's has_children flag when a note is deleted"""
    # Skip if no parent
    if target.parent_id is None:
        return
        
    # Count remaining children for the parent
    stmt = select(func.count(Note.id)).where(Note.parent_id == target.parent_id)
    count = connection.execute(stmt).scalar()
    
    # Update parent's has_children flag based on remaining children count
    connection.execute(
        update(Note).
        where(Note.id == target.parent_id).
        values(has_children=(count > 0))
    )

def init_note_events():
    """Initialize note event listeners"""
    print("Note event listeners initialized")
