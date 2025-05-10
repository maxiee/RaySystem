//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'model_info.g.dart';

/// Information about an available LLM model.
///
/// Properties:
/// * [name] - The name of the model, used as identifier when requesting completions
/// * [displayName] - User-friendly display name for the model
/// * [description] 
@BuiltValue()
abstract class ModelInfo implements Built<ModelInfo, ModelInfoBuilder> {
  /// The name of the model, used as identifier when requesting completions
  @BuiltValueField(wireName: r'name')
  String get name;

  /// User-friendly display name for the model
  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'description')
  String? get description;

  ModelInfo._();

  factory ModelInfo([void updates(ModelInfoBuilder b)]) = _$ModelInfo;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ModelInfoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ModelInfo> get serializer => _$ModelInfoSerializer();
}

class _$ModelInfoSerializer implements PrimitiveSerializer<ModelInfo> {
  @override
  final Iterable<Type> types = const [ModelInfo, _$ModelInfo];

  @override
  final String wireName = r'ModelInfo';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ModelInfo object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ModelInfo object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ModelInfoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ModelInfo deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ModelInfoBuilder();
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

