// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_get_metrics_system_metrics_get.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ResponseGetMetricsSystemMetricsGet
    extends ResponseGetMetricsSystemMetricsGet {
  @override
  final AnyOf anyOf;

  factory _$ResponseGetMetricsSystemMetricsGet(
          [void Function(ResponseGetMetricsSystemMetricsGetBuilder)?
              updates]) =>
      (new ResponseGetMetricsSystemMetricsGetBuilder()..update(updates))
          ._build();

  _$ResponseGetMetricsSystemMetricsGet._({required this.anyOf}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        anyOf, r'ResponseGetMetricsSystemMetricsGet', 'anyOf');
  }

  @override
  ResponseGetMetricsSystemMetricsGet rebuild(
          void Function(ResponseGetMetricsSystemMetricsGetBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ResponseGetMetricsSystemMetricsGetBuilder toBuilder() =>
      new ResponseGetMetricsSystemMetricsGetBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ResponseGetMetricsSystemMetricsGet && anyOf == other.anyOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, anyOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ResponseGetMetricsSystemMetricsGet')
          ..add('anyOf', anyOf))
        .toString();
  }
}

class ResponseGetMetricsSystemMetricsGetBuilder
    implements
        Builder<ResponseGetMetricsSystemMetricsGet,
            ResponseGetMetricsSystemMetricsGetBuilder> {
  _$ResponseGetMetricsSystemMetricsGet? _$v;

  AnyOf? _anyOf;
  AnyOf? get anyOf => _$this._anyOf;
  set anyOf(AnyOf? anyOf) => _$this._anyOf = anyOf;

  ResponseGetMetricsSystemMetricsGetBuilder() {
    ResponseGetMetricsSystemMetricsGet._defaults(this);
  }

  ResponseGetMetricsSystemMetricsGetBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _anyOf = $v.anyOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ResponseGetMetricsSystemMetricsGet other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ResponseGetMetricsSystemMetricsGet;
  }

  @override
  void update(
      void Function(ResponseGetMetricsSystemMetricsGetBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ResponseGetMetricsSystemMetricsGet build() => _build();

  _$ResponseGetMetricsSystemMetricsGet _build() {
    final _$result = _$v ??
        new _$ResponseGetMetricsSystemMetricsGet._(
          anyOf: BuiltValueNullFieldError.checkNotNull(
              anyOf, r'ResponseGetMetricsSystemMetricsGet', 'anyOf'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
