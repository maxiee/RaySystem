// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NoteResponse extends NoteResponse {
  @override
  final String title;
  @override
  final String contentAppflowy;
  @override
  final int id;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$NoteResponse([void Function(NoteResponseBuilder)? updates]) =>
      (new NoteResponseBuilder()..update(updates))._build();

  _$NoteResponse._(
      {required this.title,
      required this.contentAppflowy,
      required this.id,
      required this.createdAt,
      required this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(title, r'NoteResponse', 'title');
    BuiltValueNullFieldError.checkNotNull(
        contentAppflowy, r'NoteResponse', 'contentAppflowy');
    BuiltValueNullFieldError.checkNotNull(id, r'NoteResponse', 'id');
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
        title == other.title &&
        contentAppflowy == other.contentAppflowy &&
        id == other.id &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, contentAppflowy.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NoteResponse')
          ..add('title', title)
          ..add('contentAppflowy', contentAppflowy)
          ..add('id', id)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class NoteResponseBuilder
    implements Builder<NoteResponse, NoteResponseBuilder> {
  _$NoteResponse? _$v;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _contentAppflowy;
  String? get contentAppflowy => _$this._contentAppflowy;
  set contentAppflowy(String? contentAppflowy) =>
      _$this._contentAppflowy = contentAppflowy;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

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
      _title = $v.title;
      _contentAppflowy = $v.contentAppflowy;
      _id = $v.id;
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
    final _$result = _$v ??
        new _$NoteResponse._(
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'NoteResponse', 'title'),
          contentAppflowy: BuiltValueNullFieldError.checkNotNull(
              contentAppflowy, r'NoteResponse', 'contentAppflowy'),
          id: BuiltValueNullFieldError.checkNotNull(id, r'NoteResponse', 'id'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'NoteResponse', 'createdAt'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'NoteResponse', 'updatedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
