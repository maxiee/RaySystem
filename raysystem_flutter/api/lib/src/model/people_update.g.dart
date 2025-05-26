// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'people_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PeopleUpdate extends PeopleUpdate {
  @override
  final String? description;
  @override
  final String? avatar;
  @override
  final Date? birthDate;

  factory _$PeopleUpdate([void Function(PeopleUpdateBuilder)? updates]) =>
      (new PeopleUpdateBuilder()..update(updates))._build();

  _$PeopleUpdate._({this.description, this.avatar, this.birthDate}) : super._();

  @override
  PeopleUpdate rebuild(void Function(PeopleUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PeopleUpdateBuilder toBuilder() => new PeopleUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PeopleUpdate &&
        description == other.description &&
        avatar == other.avatar &&
        birthDate == other.birthDate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, avatar.hashCode);
    _$hash = $jc(_$hash, birthDate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PeopleUpdate')
          ..add('description', description)
          ..add('avatar', avatar)
          ..add('birthDate', birthDate))
        .toString();
  }
}

class PeopleUpdateBuilder
    implements Builder<PeopleUpdate, PeopleUpdateBuilder> {
  _$PeopleUpdate? _$v;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _avatar;
  String? get avatar => _$this._avatar;
  set avatar(String? avatar) => _$this._avatar = avatar;

  Date? _birthDate;
  Date? get birthDate => _$this._birthDate;
  set birthDate(Date? birthDate) => _$this._birthDate = birthDate;

  PeopleUpdateBuilder() {
    PeopleUpdate._defaults(this);
  }

  PeopleUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _description = $v.description;
      _avatar = $v.avatar;
      _birthDate = $v.birthDate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PeopleUpdate other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PeopleUpdate;
  }

  @override
  void update(void Function(PeopleUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PeopleUpdate build() => _build();

  _$PeopleUpdate _build() {
    final _$result = _$v ??
        new _$PeopleUpdate._(
          description: description,
          avatar: avatar,
          birthDate: birthDate,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
