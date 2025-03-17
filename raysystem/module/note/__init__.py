from module.note.note import init_note
from module.note.api import init_note_api
from module.note.events import init_note_events

def init():
    """Initialize the note module"""
    init_note()
    init_note_api()
    init_note_events()
