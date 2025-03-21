// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NoteUpdate extends NoteUpdate {
  @override
  final String title;
  @override
  final String contentAppflowy;
  @override
  final int? parentId;

  factory _$NoteUpdate([void Function(NoteUpdateBuilder)? updates]) =>
      (new NoteUpdateBuilder()..update(updates))._build();

  _$NoteUpdate._(
      {required this.title, required this.contentAppflowy, this.parentId})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(title, r'NoteUpdate', 'title');
    BuiltValueNullFieldError.checkNotNull(
        contentAppflowy, r'NoteUpdate', 'contentAppflowy');
  }

  @override
  NoteUpdate rebuild(void Function(NoteUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NoteUpdateBuilder toBuilder() => new NoteUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NoteUpdate &&
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
    return (newBuiltValueToStringHelper(r'NoteUpdate')
          ..add('title', title)
          ..add('contentAppflowy', contentAppflowy)
          ..add('parentId', parentId))
        .toString();
  }
}

class NoteUpdateBuilder implements Builder<NoteUpdate, NoteUpdateBuilder> {
  _$NoteUpdate? _$v;

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

  NoteUpdateBuilder() {
    NoteUpdate._defaults(this);
  }

  NoteUpdateBuilder get _$this {
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
  void replace(NoteUpdate other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$NoteUpdate;
  }

  @override
  void update(void Function(NoteUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NoteUpdate build() => _build();

  _$NoteUpdate _build() {
    final _$result = _$v ??
        new _$NoteUpdate._(
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'NoteUpdate', 'title'),
          contentAppflowy: BuiltValueNullFieldError.checkNotNull(
              contentAppflowy, r'NoteUpdate', 'contentAppflowy'),
          parentId: parentId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
