// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'people_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PeopleResponse extends PeopleResponse {
  @override
  final String? description;
  @override
  final String? avatar;
  @override
  final String? birthDate;
  @override
  final int id;
  @override
  final BuiltList<PeopleNameResponse>? names;

  factory _$PeopleResponse([void Function(PeopleResponseBuilder)? updates]) =>
      (new PeopleResponseBuilder()..update(updates))._build();

  _$PeopleResponse._(
      {this.description,
      this.avatar,
      this.birthDate,
      required this.id,
      this.names})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'PeopleResponse', 'id');
  }

  @override
  PeopleResponse rebuild(void Function(PeopleResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PeopleResponseBuilder toBuilder() =>
      new PeopleResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PeopleResponse &&
        description == other.description &&
        avatar == other.avatar &&
        birthDate == other.birthDate &&
        id == other.id &&
        names == other.names;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, avatar.hashCode);
    _$hash = $jc(_$hash, birthDate.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, names.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PeopleResponse')
          ..add('description', description)
          ..add('avatar', avatar)
          ..add('birthDate', birthDate)
          ..add('id', id)
          ..add('names', names))
        .toString();
  }
}

class PeopleResponseBuilder
    implements Builder<PeopleResponse, PeopleResponseBuilder> {
  _$PeopleResponse? _$v;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _avatar;
  String? get avatar => _$this._avatar;
  set avatar(String? avatar) => _$this._avatar = avatar;

  String? _birthDate;
  String? get birthDate => _$this._birthDate;
  set birthDate(String? birthDate) => _$this._birthDate = birthDate;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  ListBuilder<PeopleNameResponse>? _names;
  ListBuilder<PeopleNameResponse> get names =>
      _$this._names ??= new ListBuilder<PeopleNameResponse>();
  set names(ListBuilder<PeopleNameResponse>? names) => _$this._names = names;

  PeopleResponseBuilder() {
    PeopleResponse._defaults(this);
  }

  PeopleResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _description = $v.description;
      _avatar = $v.avatar;
      _birthDate = $v.birthDate;
      _id = $v.id;
      _names = $v.names?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PeopleResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PeopleResponse;
  }

  @override
  void update(void Function(PeopleResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PeopleResponse build() => _build();

  _$PeopleResponse _build() {
    _$PeopleResponse _$result;
    try {
      _$result = _$v ??
          new _$PeopleResponse._(
            description: description,
            avatar: avatar,
            birthDate: birthDate,
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'PeopleResponse', 'id'),
            names: _names?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'names';
        _names?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'PeopleResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
