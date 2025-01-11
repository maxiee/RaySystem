// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_error.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ValidationError extends ValidationError {
  @override
  final BuiltList<ValidationErrorLocInner> loc;
  @override
  final String msg;
  @override
  final String type;

  factory _$ValidationError([void Function(ValidationErrorBuilder)? updates]) =>
      (new ValidationErrorBuilder()..update(updates))._build();

  _$ValidationError._(
      {required this.loc, required this.msg, required this.type})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(loc, r'ValidationError', 'loc');
    BuiltValueNullFieldError.checkNotNull(msg, r'ValidationError', 'msg');
    BuiltValueNullFieldError.checkNotNull(type, r'ValidationError', 'type');
  }

  @override
  ValidationError rebuild(void Function(ValidationErrorBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ValidationErrorBuilder toBuilder() =>
      new ValidationErrorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ValidationError &&
        loc == other.loc &&
        msg == other.msg &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, loc.hashCode);
    _$hash = $jc(_$hash, msg.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ValidationError')
          ..add('loc', loc)
          ..add('msg', msg)
          ..add('type', type))
        .toString();
  }
}

class ValidationErrorBuilder
    implements Builder<ValidationError, ValidationErrorBuilder> {
  _$ValidationError? _$v;

  ListBuilder<ValidationErrorLocInner>? _loc;
  ListBuilder<ValidationErrorLocInner> get loc =>
      _$this._loc ??= new ListBuilder<ValidationErrorLocInner>();
  set loc(ListBuilder<ValidationErrorLocInner>? loc) => _$this._loc = loc;

  String? _msg;
  String? get msg => _$this._msg;
  set msg(String? msg) => _$this._msg = msg;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  ValidationErrorBuilder() {
    ValidationError._defaults(this);
  }

  ValidationErrorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _loc = $v.loc.toBuilder();
      _msg = $v.msg;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ValidationError other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ValidationError;
  }

  @override
  void update(void Function(ValidationErrorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ValidationError build() => _build();

  _$ValidationError _build() {
    _$ValidationError _$result;
    try {
      _$result = _$v ??
          new _$ValidationError._(
            loc: loc.build(),
            msg: BuiltValueNullFieldError.checkNotNull(
                msg, r'ValidationError', 'msg'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'ValidationError', 'type'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'loc';
        loc.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ValidationError', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
