// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'http_validation_error.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$HTTPValidationError extends HTTPValidationError {
  @override
  final BuiltList<ValidationError>? detail;

  factory _$HTTPValidationError(
          [void Function(HTTPValidationErrorBuilder)? updates]) =>
      (new HTTPValidationErrorBuilder()..update(updates))._build();

  _$HTTPValidationError._({this.detail}) : super._();

  @override
  HTTPValidationError rebuild(
          void Function(HTTPValidationErrorBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HTTPValidationErrorBuilder toBuilder() =>
      new HTTPValidationErrorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HTTPValidationError && detail == other.detail;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, detail.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'HTTPValidationError')
          ..add('detail', detail))
        .toString();
  }
}

class HTTPValidationErrorBuilder
    implements Builder<HTTPValidationError, HTTPValidationErrorBuilder> {
  _$HTTPValidationError? _$v;

  ListBuilder<ValidationError>? _detail;
  ListBuilder<ValidationError> get detail =>
      _$this._detail ??= new ListBuilder<ValidationError>();
  set detail(ListBuilder<ValidationError>? detail) => _$this._detail = detail;

  HTTPValidationErrorBuilder() {
    HTTPValidationError._defaults(this);
  }

  HTTPValidationErrorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _detail = $v.detail?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HTTPValidationError other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$HTTPValidationError;
  }

  @override
  void update(void Function(HTTPValidationErrorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HTTPValidationError build() => _build();

  _$HTTPValidationError _build() {
    _$HTTPValidationError _$result;
    try {
      _$result = _$v ??
          new _$HTTPValidationError._(
            detail: _detail?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'detail';
        _detail?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'HTTPValidationError', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
