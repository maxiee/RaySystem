// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_title_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NoteTitleCreate extends NoteTitleCreate {
  @override
  final String title;
  @override
  final bool? isPrimary;

  factory _$NoteTitleCreate([void Function(NoteTitleCreateBuilder)? updates]) =>
      (new NoteTitleCreateBuilder()..update(updates))._build();

  _$NoteTitleCreate._({required this.title, this.isPrimary}) : super._() {
    BuiltValueNullFieldError.checkNotNull(title, r'NoteTitleCreate', 'title');
  }

  @override
  NoteTitleCreate rebuild(void Function(NoteTitleCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NoteTitleCreateBuilder toBuilder() =>
      new NoteTitleCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NoteTitleCreate &&
        title == other.title &&
        isPrimary == other.isPrimary;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, isPrimary.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NoteTitleCreate')
          ..add('title', title)
          ..add('isPrimary', isPrimary))
        .toString();
  }
}

class NoteTitleCreateBuilder
    implements Builder<NoteTitleCreate, NoteTitleCreateBuilder> {
  _$NoteTitleCreate? _$v;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  bool? _isPrimary;
  bool? get isPrimary => _$this._isPrimary;
  set isPrimary(bool? isPrimary) => _$this._isPrimary = isPrimary;

  NoteTitleCreateBuilder() {
    NoteTitleCreate._defaults(this);
  }

  NoteTitleCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _isPrimary = $v.isPrimary;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NoteTitleCreate other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$NoteTitleCreate;
  }

  @override
  void update(void Function(NoteTitleCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NoteTitleCreate build() => _build();

  _$NoteTitleCreate _build() {
    final _$result = _$v ??
        new _$NoteTitleCreate._(
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'NoteTitleCreate', 'title'),
          isPrimary: isPrimary,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
