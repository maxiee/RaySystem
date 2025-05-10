//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/validation_error.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'http_validation_error.g.dart';

/// HTTPValidationError
///
/// Properties:
/// * [detail] 
@BuiltValue()
abstract class HTTPValidationError implements Built<HTTPValidationError, HTTPValidationErrorBuilder> {
  @BuiltValueField(wireName: r'detail')
  BuiltList<ValidationError>? get detail;

  HTTPValidationError._();

  factory HTTPValidationError([void updates(HTTPValidationErrorBuilder b)]) = _$HTTPValidationError;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(HTTPValidationErrorBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<HTTPValidationError> get serializer => _$HTTPValidationErrorSerializer();
}

class _$HTTPValidationErrorSerializer implements PrimitiveSerializer<HTTPValidationError> {
  @override
  final Iterable<Type> types = const [HTTPValidationError, _$HTTPValidationError];

  @override
  final String wireName = r'HTTPValidationError';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    HTTPValidationError object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.detail != null) {
      yield r'detail';
      yield serializers.serialize(
        object.detail,
        specifiedType: const FullType(BuiltList, [FullType(ValidationError)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    HTTPValidationError object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required HTTPValidationErrorBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'detail':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ValidationError)]),
          ) as BuiltList<ValidationError>;
          result.detail.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  HTTPValidationError deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = HTTPValidationErrorBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

