// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NoteResponse extends NoteResponse {
  @override
  final String contentAppflowy;
  @override
  final int? parentId;
  @override
  final int id;
  @override
  final BuiltList<NoteTitleResponse> noteTitles;
  @override
  final bool hasChildren;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$NoteResponse([void Function(NoteResponseBuilder)? updates]) =>
      (new NoteResponseBuilder()..update(updates))._build();

  _$NoteResponse._(
      {required this.contentAppflowy,
      this.parentId,
      required this.id,
      required this.noteTitles,
      required this.hasChildren,
      required this.createdAt,
      required this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        contentAppflowy, r'NoteResponse', 'contentAppflowy');
    BuiltValueNullFieldError.checkNotNull(id, r'NoteResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(
        noteTitles, r'NoteResponse', 'noteTitles');
    BuiltValueNullFieldError.checkNotNull(
        hasChildren, r'NoteResponse', 'hasChildren');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'NoteResponse', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'NoteResponse', 'updatedAt');
  }

  @override
  NoteResponse rebuild(void Function(NoteResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NoteResponseBuilder toBuilder() => new NoteResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NoteResponse &&
        contentAppflowy == other.contentAppflowy &&
        parentId == other.parentId &&
        id == other.id &&
        noteTitles == other.noteTitles &&
        hasChildren == other.hasChildren &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, contentAppflowy.hashCode);
    _$hash = $jc(_$hash, parentId.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, noteTitles.hashCode);
    _$hash = $jc(_$hash, hasChildren.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NoteResponse')
          ..add('contentAppflowy', contentAppflowy)
          ..add('parentId', parentId)
          ..add('id', id)
          ..add('noteTitles', noteTitles)
          ..add('hasChildren', hasChildren)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class NoteResponseBuilder
    implements Builder<NoteResponse, NoteResponseBuilder> {
  _$NoteResponse? _$v;

  String? _contentAppflowy;
  String? get contentAppflowy => _$this._contentAppflowy;
  set contentAppflowy(String? contentAppflowy) =>
      _$this._contentAppflowy = contentAppflowy;

  int? _parentId;
  int? get parentId => _$this._parentId;
  set parentId(int? parentId) => _$this._parentId = parentId;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  ListBuilder<NoteTitleResponse>? _noteTitles;
  ListBuilder<NoteTitleResponse> get noteTitles =>
      _$this._noteTitles ??= new ListBuilder<NoteTitleResponse>();
  set noteTitles(ListBuilder<NoteTitleResponse>? noteTitles) =>
      _$this._noteTitles = noteTitles;

  bool? _hasChildren;
  bool? get hasChildren => _$this._hasChildren;
  set hasChildren(bool? hasChildren) => _$this._hasChildren = hasChildren;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  NoteResponseBuilder() {
    NoteResponse._defaults(this);
  }

  NoteResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _contentAppflowy = $v.contentAppflowy;
      _parentId = $v.parentId;
      _id = $v.id;
      _noteTitles = $v.noteTitles.toBuilder();
      _hasChildren = $v.hasChildren;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NoteResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$NoteResponse;
  }

  @override
  void update(void Function(NoteResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NoteResponse build() => _build();

  _$NoteResponse _build() {
    _$NoteResponse _$result;
    try {
      _$result = _$v ??
          new _$NoteResponse._(
            contentAppflowy: BuiltValueNullFieldError.checkNotNull(
                contentAppflowy, r'NoteResponse', 'contentAppflowy'),
            parentId: parentId,
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'NoteResponse', 'id'),
            noteTitles: noteTitles.build(),
            hasChildren: BuiltValueNullFieldError.checkNotNull(
                hasChildren, r'NoteResponse', 'hasChildren'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'NoteResponse', 'createdAt'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'NoteResponse', 'updatedAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'noteTitles';
        noteTitles.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'NoteResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
