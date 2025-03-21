// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NoteCreate extends NoteCreate {
  @override
  final String title;
  @override
  final String contentAppflowy;
  @override
  final int? parentId;

  factory _$NoteCreate([void Function(NoteCreateBuilder)? updates]) =>
      (new NoteCreateBuilder()..update(updates))._build();

  _$NoteCreate._(
      {required this.title, required this.contentAppflowy, this.parentId})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(title, r'NoteCreate', 'title');
    BuiltValueNullFieldError.checkNotNull(
        contentAppflowy, r'NoteCreate', 'contentAppflowy');
  }

  @override
  NoteCreate rebuild(void Function(NoteCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NoteCreateBuilder toBuilder() => new NoteCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NoteCreate &&
        title == other.title &&
        contentAppflowy == other.contentAppflowy &&
        parentId == other.parentId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, contentAppflowy.hashCode);
    _$hash = $jc(_$hash, parentId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NoteCreate')
          ..add('title', title)
          ..add('contentAppflowy', contentAppflowy)
          ..add('parentId', parentId))
        .toString();
  }
}

class NoteCreateBuilder implements Builder<NoteCreate, NoteCreateBuilder> {
  _$NoteCreate? _$v;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _contentAppflowy;
  String? get contentAppflowy => _$this._contentAppflowy;
  set contentAppflowy(String? contentAppflowy) =>
      _$this._contentAppflowy = contentAppflowy;

  int? _parentId;
  int? get parentId => _$this._parentId;
  set parentId(int? parentId) => _$this._parentId = parentId;

  NoteCreateBuilder() {
    NoteCreate._defaults(this);
  }

  NoteCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _contentAppflowy = $v.contentAppflowy;
      _parentId = $v.parentId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NoteCreate other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$NoteCreate;
  }

  @override
  void update(void Function(NoteCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NoteCreate build() => _build();

  _$NoteCreate _build() {
    final _$result = _$v ??
        new _$NoteCreate._(
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'NoteCreate', 'title'),
          contentAppflowy: BuiltValueNullFieldError.checkNotNull(
              contentAppflowy, r'NoteCreate', 'contentAppflowy'),
          parentId: parentId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
