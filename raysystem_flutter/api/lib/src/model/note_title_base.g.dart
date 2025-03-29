// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_title_base.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NoteTitleBase extends NoteTitleBase {
  @override
  final int id;
  @override
  final String title;
  @override
  final bool isPrimary;
  @override
  final DateTime createdAt;

  factory _$NoteTitleBase([void Function(NoteTitleBaseBuilder)? updates]) =>
      (new NoteTitleBaseBuilder()..update(updates))._build();

  _$NoteTitleBase._(
      {required this.id,
      required this.title,
      required this.isPrimary,
      required this.createdAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'NoteTitleBase', 'id');
    BuiltValueNullFieldError.checkNotNull(title, r'NoteTitleBase', 'title');
    BuiltValueNullFieldError.checkNotNull(
        isPrimary, r'NoteTitleBase', 'isPrimary');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'NoteTitleBase', 'createdAt');
  }

  @override
  NoteTitleBase rebuild(void Function(NoteTitleBaseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NoteTitleBaseBuilder toBuilder() => new NoteTitleBaseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NoteTitleBase &&
        id == other.id &&
        title == other.title &&
        isPrimary == other.isPrimary &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, isPrimary.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NoteTitleBase')
          ..add('id', id)
          ..add('title', title)
          ..add('isPrimary', isPrimary)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class NoteTitleBaseBuilder
    implements Builder<NoteTitleBase, NoteTitleBaseBuilder> {
  _$NoteTitleBase? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  bool? _isPrimary;
  bool? get isPrimary => _$this._isPrimary;
  set isPrimary(bool? isPrimary) => _$this._isPrimary = isPrimary;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  NoteTitleBaseBuilder() {
    NoteTitleBase._defaults(this);
  }

  NoteTitleBaseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _isPrimary = $v.isPrimary;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NoteTitleBase other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$NoteTitleBase;
  }

  @override
  void update(void Function(NoteTitleBaseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NoteTitleBase build() => _build();

  _$NoteTitleBase _build() {
    final _$result = _$v ??
        new _$NoteTitleBase._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'NoteTitleBase', 'id'),
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'NoteTitleBase', 'title'),
          isPrimary: BuiltValueNullFieldError.checkNotNull(
              isPrimary, r'NoteTitleBase', 'isPrimary'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'NoteTitleBase', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
