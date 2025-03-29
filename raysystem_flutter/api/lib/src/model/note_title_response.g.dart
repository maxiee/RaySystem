// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_title_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NoteTitleResponse extends NoteTitleResponse {
  @override
  final String title;
  @override
  final bool? isPrimary;
  @override
  final int id;
  @override
  final int noteId;
  @override
  final DateTime createdAt;

  factory _$NoteTitleResponse(
          [void Function(NoteTitleResponseBuilder)? updates]) =>
      (new NoteTitleResponseBuilder()..update(updates))._build();

  _$NoteTitleResponse._(
      {required this.title,
      this.isPrimary,
      required this.id,
      required this.noteId,
      required this.createdAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(title, r'NoteTitleResponse', 'title');
    BuiltValueNullFieldError.checkNotNull(id, r'NoteTitleResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(
        noteId, r'NoteTitleResponse', 'noteId');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'NoteTitleResponse', 'createdAt');
  }

  @override
  NoteTitleResponse rebuild(void Function(NoteTitleResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NoteTitleResponseBuilder toBuilder() =>
      new NoteTitleResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NoteTitleResponse &&
        title == other.title &&
        isPrimary == other.isPrimary &&
        id == other.id &&
        noteId == other.noteId &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, isPrimary.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, noteId.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NoteTitleResponse')
          ..add('title', title)
          ..add('isPrimary', isPrimary)
          ..add('id', id)
          ..add('noteId', noteId)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class NoteTitleResponseBuilder
    implements Builder<NoteTitleResponse, NoteTitleResponseBuilder> {
  _$NoteTitleResponse? _$v;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  bool? _isPrimary;
  bool? get isPrimary => _$this._isPrimary;
  set isPrimary(bool? isPrimary) => _$this._isPrimary = isPrimary;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _noteId;
  int? get noteId => _$this._noteId;
  set noteId(int? noteId) => _$this._noteId = noteId;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  NoteTitleResponseBuilder() {
    NoteTitleResponse._defaults(this);
  }

  NoteTitleResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _isPrimary = $v.isPrimary;
      _id = $v.id;
      _noteId = $v.noteId;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NoteTitleResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$NoteTitleResponse;
  }

  @override
  void update(void Function(NoteTitleResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NoteTitleResponse build() => _build();

  _$NoteTitleResponse _build() {
    final _$result = _$v ??
        new _$NoteTitleResponse._(
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'NoteTitleResponse', 'title'),
          isPrimary: isPrimary,
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'NoteTitleResponse', 'id'),
          noteId: BuiltValueNullFieldError.checkNotNull(
              noteId, r'NoteTitleResponse', 'noteId'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'NoteTitleResponse', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
