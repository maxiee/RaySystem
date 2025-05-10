// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'people_name_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PeopleNameCreate extends PeopleNameCreate {
  @override
  final String name;

  factory _$PeopleNameCreate(
          [void Function(PeopleNameCreateBuilder)? updates]) =>
      (new PeopleNameCreateBuilder()..update(updates))._build();

  _$PeopleNameCreate._({required this.name}) : super._() {
    BuiltValueNullFieldError.checkNotNull(name, r'PeopleNameCreate', 'name');
  }

  @override
  PeopleNameCreate rebuild(void Function(PeopleNameCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PeopleNameCreateBuilder toBuilder() =>
      new PeopleNameCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PeopleNameCreate && name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PeopleNameCreate')..add('name', name))
        .toString();
  }
}

class PeopleNameCreateBuilder
    implements Builder<PeopleNameCreate, PeopleNameCreateBuilder> {
  _$PeopleNameCreate? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  PeopleNameCreateBuilder() {
    PeopleNameCreate._defaults(this);
  }

  PeopleNameCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PeopleNameCreate other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PeopleNameCreate;
  }

  @override
  void update(void Function(PeopleNameCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PeopleNameCreate build() => _build();

  _$PeopleNameCreate _build() {
    final _$result = _$v ??
        new _$PeopleNameCreate._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'PeopleNameCreate', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
