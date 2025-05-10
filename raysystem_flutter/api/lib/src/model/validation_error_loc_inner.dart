//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'dart:core';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/any_of.dart';

part 'validation_error_loc_inner.g.dart';

/// ValidationErrorLocInner
@BuiltValue()
abstract class ValidationErrorLocInner implements Built<ValidationErrorLocInner, ValidationErrorLocInnerBuilder> {
  /// Any Of [String], [int]
  AnyOf get anyOf;

  ValidationErrorLocInner._();

  factory ValidationErrorLocInner([void updates(ValidationErrorLocInnerBuilder b)]) = _$ValidationErrorLocInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ValidationErrorLocInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ValidationErrorLocInner> get serializer => _$ValidationErrorLocInnerSerializer();
}

class _$ValidationErrorLocInnerSerializer implements PrimitiveSerializer<ValidationErrorLocInner> {
  @override
  final Iterable<Type> types = const [ValidationErrorLocInner, _$ValidationErrorLocInner];

  @override
  final String wireName = r'ValidationErrorLocInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ValidationErrorLocInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
  }

  @override
  Object serialize(
    Serializers serializers,
    ValidationErrorLocInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final anyOf = object.anyOf;
    return serializers.serialize(anyOf, specifiedType: FullType(AnyOf, anyOf.valueTypes.map((type) => FullType(type)).toList()))!;
  }

  @override
  ValidationErrorLocInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ValidationErrorLocInnerBuilder();
    Object? anyOfDataSrc;
    final targetType = const FullType(AnyOf, [FullType(String), FullType(int), ]);
    anyOfDataSrc = serialized;
    result.anyOf = serializers.deserialize(anyOfDataSrc, specifiedType: targetType) as AnyOf;
    return result.build();
  }
}

