// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_models_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ListModelsResponse extends ListModelsResponse {
  @override
  final BuiltList<ModelInfo> models;
  @override
  final String defaultModel;

  factory _$ListModelsResponse(
          [void Function(ListModelsResponseBuilder)? updates]) =>
      (new ListModelsResponseBuilder()..update(updates))._build();

  _$ListModelsResponse._({required this.models, required this.defaultModel})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        models, r'ListModelsResponse', 'models');
    BuiltValueNullFieldError.checkNotNull(
        defaultModel, r'ListModelsResponse', 'defaultModel');
  }

  @override
  ListModelsResponse rebuild(
          void Function(ListModelsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListModelsResponseBuilder toBuilder() =>
      new ListModelsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListModelsResponse &&
        models == other.models &&
        defaultModel == other.defaultModel;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, models.hashCode);
    _$hash = $jc(_$hash, defaultModel.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ListModelsResponse')
          ..add('models', models)
          ..add('defaultModel', defaultModel))
        .toString();
  }
}

class ListModelsResponseBuilder
    implements Builder<ListModelsResponse, ListModelsResponseBuilder> {
  _$ListModelsResponse? _$v;

  ListBuilder<ModelInfo>? _models;
  ListBuilder<ModelInfo> get models =>
      _$this._models ??= new ListBuilder<ModelInfo>();
  set models(ListBuilder<ModelInfo>? models) => _$this._models = models;

  String? _defaultModel;
  String? get defaultModel => _$this._defaultModel;
  set defaultModel(String? defaultModel) => _$this._defaultModel = defaultModel;

  ListModelsResponseBuilder() {
    ListModelsResponse._defaults(this);
  }

  ListModelsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _models = $v.models.toBuilder();
      _defaultModel = $v.defaultModel;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListModelsResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ListModelsResponse;
  }

  @override
  void update(void Function(ListModelsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListModelsResponse build() => _build();

  _$ListModelsResponse _build() {
    _$ListModelsResponse _$result;
    try {
      _$result = _$v ??
          new _$ListModelsResponse._(
            models: models.build(),
            defaultModel: BuiltValueNullFieldError.checkNotNull(
                defaultModel, r'ListModelsResponse', 'defaultModel'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'models';
        models.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ListModelsResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
