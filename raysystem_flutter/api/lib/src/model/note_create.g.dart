// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NoteCreate extends NoteCreate {
  @override
  final String contentAppflowy;
  @override
  final int? parentId;
  @override
  final BuiltList<NoteTitleCreate>? titles;

  factory _$NoteCreate([void Function(NoteCreateBuilder)? updates]) =>
      (new NoteCreateBuilder()..update(updates))._build();

  _$NoteCreate._({required this.contentAppflowy, this.parentId, this.titles})
      : super._() {
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
        contentAppflowy == other.contentAppflowy &&
        parentId == other.parentId &&
        titles == other.titles;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, contentAppflowy.hashCode);
    _$hash = $jc(_$hash, parentId.hashCode);
    _$hash = $jc(_$hash, titles.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NoteCreate')
          ..add('contentAppflowy', contentAppflowy)
          ..add('parentId', parentId)
          ..add('titles', titles))
        .toString();
  }
}

class NoteCreateBuilder implements Builder<NoteCreate, NoteCreateBuilder> {
  _$NoteCreate? _$v;

  String? _contentAppflowy;
  String? get contentAppflowy => _$this._contentAppflowy;
  set contentAppflowy(String? contentAppflowy) =>
      _$this._contentAppflowy = contentAppflowy;

  int? _parentId;
  int? get parentId => _$this._parentId;
  set parentId(int? parentId) => _$this._parentId = parentId;

  ListBuilder<NoteTitleCreate>? _titles;
  ListBuilder<NoteTitleCreate> get titles =>
      _$this._titles ??= new ListBuilder<NoteTitleCreate>();
  set titles(ListBuilder<NoteTitleCreate>? titles) => _$this._titles = titles;

  NoteCreateBuilder() {
    NoteCreate._defaults(this);
  }

  NoteCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _contentAppflowy = $v.contentAppflowy;
      _parentId = $v.parentId;
      _titles = $v.titles?.toBuilder();
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
    _$NoteCreate _$result;
    try {
      _$result = _$v ??
          new _$NoteCreate._(
            contentAppflowy: BuiltValueNullFieldError.checkNotNull(
                contentAppflowy, r'NoteCreate', 'contentAppflowy'),
            parentId: parentId,
            titles: _titles?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'titles';
        _titles?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'NoteCreate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
