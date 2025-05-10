//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/model_info.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'list_models_response.g.dart';

/// Response body for the list models endpoint.
///
/// Properties:
/// * [models] - List of available models
/// * [defaultModel] - The name of the default model
@BuiltValue()
abstract class ListModelsResponse implements Built<ListModelsResponse, ListModelsResponseBuilder> {
  /// List of available models
  @BuiltValueField(wireName: r'models')
  BuiltList<ModelInfo> get models;

  /// The name of the default model
  @BuiltValueField(wireName: r'default_model')
  String get defaultModel;

  ListModelsResponse._();

  factory ListModelsResponse([void updates(ListModelsResponseBuilder b)]) = _$ListModelsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListModelsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListModelsResponse> get serializer => _$ListModelsResponseSerializer();
}

class _$ListModelsResponseSerializer implements PrimitiveSerializer<ListModelsResponse> {
  @override
  final Iterable<Type> types = const [ListModelsResponse, _$ListModelsResponse];

  @override
  final String wireName = r'ListModelsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListModelsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'models';
    yield serializers.serialize(
      object.models,
      specifiedType: const FullType(BuiltList, [FullType(ModelInfo)]),
    );
    yield r'default_model';
    yield serializers.serialize(
      object.defaultModel,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ListModelsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ListModelsResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'models':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ModelInfo)]),
          ) as BuiltList<ModelInfo>;
          result.models.replace(valueDes);
          break;
        case r'default_model':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.defaultModel = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ListModelsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListModelsResponseBuilder();
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

