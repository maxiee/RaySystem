// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_error_loc_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ValidationErrorLocInner extends ValidationErrorLocInner {
  @override
  final AnyOf anyOf;

  factory _$ValidationErrorLocInner(
          [void Function(ValidationErrorLocInnerBuilder)? updates]) =>
      (new ValidationErrorLocInnerBuilder()..update(updates))._build();

  _$ValidationErrorLocInner._({required this.anyOf}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        anyOf, r'ValidationErrorLocInner', 'anyOf');
  }

  @override
  ValidationErrorLocInner rebuild(
          void Function(ValidationErrorLocInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ValidationErrorLocInnerBuilder toBuilder() =>
      new ValidationErrorLocInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ValidationErrorLocInner && anyOf == other.anyOf;
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
    return (newBuiltValueToStringHelper(r'ValidationErrorLocInner')
          ..add('anyOf', anyOf))
        .toString();
  }
}

class ValidationErrorLocInnerBuilder
    implements
        Builder<ValidationErrorLocInner, ValidationErrorLocInnerBuilder> {
  _$ValidationErrorLocInner? _$v;

  AnyOf? _anyOf;
  AnyOf? get anyOf => _$this._anyOf;
  set anyOf(AnyOf? anyOf) => _$this._anyOf = anyOf;

  ValidationErrorLocInnerBuilder() {
    ValidationErrorLocInner._defaults(this);
  }

  ValidationErrorLocInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _anyOf = $v.anyOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ValidationErrorLocInner other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ValidationErrorLocInner;
  }

  @override
  void update(void Function(ValidationErrorLocInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ValidationErrorLocInner build() => _build();

  _$ValidationErrorLocInner _build() {
    final _$result = _$v ??
        new _$ValidationErrorLocInner._(
          anyOf: BuiltValueNullFieldError.checkNotNull(
              anyOf, r'ValidationErrorLocInner', 'anyOf'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
