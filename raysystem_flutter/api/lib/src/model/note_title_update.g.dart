// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_title_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NoteTitleUpdate extends NoteTitleUpdate {
  @override
  final String title;
  @override
  final bool? isPrimary;

  factory _$NoteTitleUpdate([void Function(NoteTitleUpdateBuilder)? updates]) =>
      (new NoteTitleUpdateBuilder()..update(updates))._build();

  _$NoteTitleUpdate._({required this.title, this.isPrimary}) : super._() {
    BuiltValueNullFieldError.checkNotNull(title, r'NoteTitleUpdate', 'title');
  }

  @override
  NoteTitleUpdate rebuild(void Function(NoteTitleUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NoteTitleUpdateBuilder toBuilder() =>
      new NoteTitleUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NoteTitleUpdate &&
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
    return (newBuiltValueToStringHelper(r'NoteTitleUpdate')
          ..add('title', title)
          ..add('isPrimary', isPrimary))
        .toString();
  }
}

class NoteTitleUpdateBuilder
    implements Builder<NoteTitleUpdate, NoteTitleUpdateBuilder> {
  _$NoteTitleUpdate? _$v;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  bool? _isPrimary;
  bool? get isPrimary => _$this._isPrimary;
  set isPrimary(bool? isPrimary) => _$this._isPrimary = isPrimary;

  NoteTitleUpdateBuilder() {
    NoteTitleUpdate._defaults(this);
  }

  NoteTitleUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _isPrimary = $v.isPrimary;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NoteTitleUpdate other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$NoteTitleUpdate;
  }

  @override
  void update(void Function(NoteTitleUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NoteTitleUpdate build() => _build();

  _$NoteTitleUpdate _build() {
    final _$result = _$v ??
        new _$NoteTitleUpdate._(
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'NoteTitleUpdate', 'title'),
          isPrimary: isPrimary,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
