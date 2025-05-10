// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'people_name_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PeopleNameResponse extends PeopleNameResponse {
  @override
  final String name;
  @override
  final int id;
  @override
  final int peopleId;

  factory _$PeopleNameResponse(
          [void Function(PeopleNameResponseBuilder)? updates]) =>
      (new PeopleNameResponseBuilder()..update(updates))._build();

  _$PeopleNameResponse._(
      {required this.name, required this.id, required this.peopleId})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(name, r'PeopleNameResponse', 'name');
    BuiltValueNullFieldError.checkNotNull(id, r'PeopleNameResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(
        peopleId, r'PeopleNameResponse', 'peopleId');
  }

  @override
  PeopleNameResponse rebuild(
          void Function(PeopleNameResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PeopleNameResponseBuilder toBuilder() =>
      new PeopleNameResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PeopleNameResponse &&
        name == other.name &&
        id == other.id &&
        peopleId == other.peopleId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, peopleId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PeopleNameResponse')
          ..add('name', name)
          ..add('id', id)
          ..add('peopleId', peopleId))
        .toString();
  }
}

class PeopleNameResponseBuilder
    implements Builder<PeopleNameResponse, PeopleNameResponseBuilder> {
  _$PeopleNameResponse? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _peopleId;
  int? get peopleId => _$this._peopleId;
  set peopleId(int? peopleId) => _$this._peopleId = peopleId;

  PeopleNameResponseBuilder() {
    PeopleNameResponse._defaults(this);
  }

  PeopleNameResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _id = $v.id;
      _peopleId = $v.peopleId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PeopleNameResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PeopleNameResponse;
  }

  @override
  void update(void Function(PeopleNameResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PeopleNameResponse build() => _build();

  _$PeopleNameResponse _build() {
    final _$result = _$v ??
        new _$PeopleNameResponse._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'PeopleNameResponse', 'name'),
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'PeopleNameResponse', 'id'),
          peopleId: BuiltValueNullFieldError.checkNotNull(
              peopleId, r'PeopleNameResponse', 'peopleId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
