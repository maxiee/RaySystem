import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'dart:collection';

import 'package:raysystem_flutter/api/api.dart';

enum NoteOperationStatus {
  idle,
  loading,
  success,
  error,
}

/// A class that represents a note with additional state information
class NoteState {
  final NoteResponse note;
  final NoteOperationStatus status;
  final String? errorMessage;
  final bool isEditing;
  final bool isDirty; // Whether the note has unsaved changes

  NoteState({
    required this.note,
    this.status = NoteOperationStatus.idle,
    this.errorMessage,
    this.isEditing = false,
    this.isDirty = false,
  });

  NoteState copyWith({
    NoteResponse? note,
    NoteOperationStatus? status,
    String? errorMessage,
    bool? isEditing,
    bool? isDirty,
  }) {
    return NoteState(
      note: note ?? this.note,
      status: status ?? this.status,
      errorMessage: errorMessage,
      isEditing: isEditing ?? this.isEditing,
      isDirty: isDirty ?? this.isDirty,
    );
  }
}

/// Provider that manages multiple notes and handles communication with the NotesApi
class NotesProvider extends ChangeNotifier {
  // Store notes by their IDs for quick access
  final Map<int, NoteState> _notes = {};

  // Status for the whole provider
  NoteOperationStatus _status = NoteOperationStatus.idle;
  String? _errorMessage;

  // For pagination and recent notes
  int _currentOffset = 0;
  int _currentLimit = 20;
  bool _hasMoreNotes = true;

  // For search
  final List<int> _recentNoteIds = [];

  // Getters
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == NoteOperationStatus.loading;
  bool get hasError => _status == NoteOperationStatus.error;
  bool get hasMoreNotes => _hasMoreNotes;

  // Return an unmodifiable view of the notes map
  UnmodifiableMapView<int, NoteState> get notes => UnmodifiableMapView(_notes);

  // Get a list of all notes sorted by updated date (most recent first)
  List<NoteState> get allNotes {
    final sortedNotes = _notes.values.toList();
    sortedNotes.sort((a, b) => b.note.updatedAt.compareTo(a.note.updatedAt));
    return sortedNotes;
  }

  // Get recent notes IDs
  List<int> get recentNoteIds => List.unmodifiable(_recentNoteIds);

  // Get recent notes as NoteState objects
  List<NoteState> get recentNotes {
    return _recentNoteIds
        .map((id) => _notes[id])
        .whereType<NoteState>()
        .toList();
  }

  // Get a specific note by ID
  NoteState? getNoteById(int id) => _notes[id];

  // Reset error state
  void resetError() {
    _errorMessage = null;
    _status = NoteOperationStatus.idle;
    notifyListeners();
  }

  // Load recent notes
  Future<void> loadRecentNotes({bool refresh = false}) async {
    if (refresh) {
      _currentOffset = 0;
      _hasMoreNotes = true;
      _notes.clear();
      _recentNoteIds.clear();
    }

    if (!_hasMoreNotes) return;

    _status = NoteOperationStatus.loading;
    notifyListeners();

    try {
      final response = await notesApi.listRecentNotesNotesGet(
        limit: _currentLimit,
        offset: _currentOffset,
      );

      final notes = response.data?.items.toList() ?? [];

      if (notes.isEmpty) {
        _hasMoreNotes = false;
      } else {
        for (final note in notes) {
          _notes[note.id] = NoteState(note: note);
          if (!_recentNoteIds.contains(note.id)) {
            _recentNoteIds.add(note.id);
          }
        }
        _currentOffset += notes.length;
      }

      _status = NoteOperationStatus.success;
    } catch (e) {
      _status = NoteOperationStatus.error;
      _errorMessage = 'Failed to load recent notes: ${e.toString()}';
      debugPrint(_errorMessage);
    } finally {
      notifyListeners();
    }
  }

  // Load more notes (pagination)
  Future<void> loadMoreNotes() async {
    await loadRecentNotes();
  }

  // Delete a note
  Future<bool> deleteNote(int noteId) async {
    // Set the specific note to loading state
    if (_notes.containsKey(noteId)) {
      _notes[noteId] =
          _notes[noteId]!.copyWith(status: NoteOperationStatus.loading);
      notifyListeners();
    }

    try {
      final response =
          await notesApi.deleteNoteNotesNoteIdDelete(noteId: noteId);
      final success = response.data ?? false;

      if (success) {
        // Remove note from lists
        _notes.remove(noteId);
        _recentNoteIds.remove(noteId);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      if (_notes.containsKey(noteId)) {
        _notes[noteId] = _notes[noteId]!.copyWith(
          status: NoteOperationStatus.error,
          errorMessage: 'Failed to delete note: ${e.toString()}',
        );
      } else {
        _errorMessage = 'Failed to delete note: ${e.toString()}';
        _status = NoteOperationStatus.error;
      }
      debugPrint('Error deleting note $noteId: ${e.toString()}');
      notifyListeners();
      return false;
    }
  }

  // Search notes by title
  Future<void> searchNotes(String query) async {
    _status = NoteOperationStatus.loading;
    notifyListeners();

    try {
      final response = await notesApi.searchNotesNotesSearchGet(
        q: query,
        limit: _currentLimit,
        offset: 0,
      );

      final searchResults = response.data?.items.toList() ?? [];

      // Update the notes map with search results
      for (final note in searchResults) {
        _notes[note.id] = NoteState(note: note);
      }

      _status = NoteOperationStatus.success;
      notifyListeners();
    } catch (e) {
      _status = NoteOperationStatus.error;
      _errorMessage = 'Failed to search notes: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
    }
  }

  // Set a note as being edited
  void setNoteEditing(int noteId, {required bool isEditing}) {
    if (_notes.containsKey(noteId)) {
      _notes[noteId] = _notes[noteId]!.copyWith(isEditing: isEditing);
      notifyListeners();
    }
  }

  // Mark a note as having unsaved changes
  void setNoteDirty(int noteId, {required bool isDirty}) {
    if (_notes.containsKey(noteId)) {
      _notes[noteId] = _notes[noteId]!.copyWith(isDirty: isDirty);
      notifyListeners();
    }
  }
}
