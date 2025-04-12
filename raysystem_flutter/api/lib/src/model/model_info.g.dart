// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_info.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ModelInfo extends ModelInfo {
  @override
  final String name;
  @override
  final String displayName;
  @override
  final String? description;

  factory _$ModelInfo([void Function(ModelInfoBuilder)? updates]) =>
      (new ModelInfoBuilder()..update(updates))._build();

  _$ModelInfo._(
      {required this.name, required this.displayName, this.description})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(name, r'ModelInfo', 'name');
    BuiltValueNullFieldError.checkNotNull(
        displayName, r'ModelInfo', 'displayName');
  }

  @override
  ModelInfo rebuild(void Function(ModelInfoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ModelInfoBuilder toBuilder() => new ModelInfoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ModelInfo &&
        name == other.name &&
        displayName == other.displayName &&
        description == other.description;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ModelInfo')
          ..add('name', name)
          ..add('displayName', displayName)
          ..add('description', description))
        .toString();
  }
}

class ModelInfoBuilder implements Builder<ModelInfo, ModelInfoBuilder> {
  _$ModelInfo? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  ModelInfoBuilder() {
    ModelInfo._defaults(this);
  }

  ModelInfoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _displayName = $v.displayName;
      _description = $v.description;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ModelInfo other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ModelInfo;
  }

  @override
  void update(void Function(ModelInfoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ModelInfo build() => _build();

  _$ModelInfo _build() {
    final _$result = _$v ??
        new _$ModelInfo._(
          name:
              BuiltValueNullFieldError.checkNotNull(name, r'ModelInfo', 'name'),
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'ModelInfo', 'displayName'),
          description: description,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
