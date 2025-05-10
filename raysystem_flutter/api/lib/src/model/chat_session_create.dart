//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_session_create.g.dart';

/// Schema for creating a new chat session.
///
/// Properties:
/// * [title] 
/// * [modelName] 
/// * [contentJson] 
@BuiltValue()
abstract class ChatSessionCreate implements Built<ChatSessionCreate, ChatSessionCreateBuilder> {
  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'model_name')
  String? get modelName;

  @BuiltValueField(wireName: r'content_json')
  String get contentJson;

  ChatSessionCreate._();

  factory ChatSessionCreate([void updates(ChatSessionCreateBuilder b)]) = _$ChatSessionCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatSessionCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatSessionCreate> get serializer => _$ChatSessionCreateSerializer();
}

class _$ChatSessionCreateSerializer implements PrimitiveSerializer<ChatSessionCreate> {
  @override
  final Iterable<Type> types = const [ChatSessionCreate, _$ChatSessionCreate];

  @override
  final String wireName = r'ChatSessionCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatSessionCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    if (object.modelName != null) {
      yield r'model_name';
      yield serializers.serialize(
        object.modelName,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'content_json';
    yield serializers.serialize(
      object.contentJson,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatSessionCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatSessionCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'model_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.modelName = valueDes;
          break;
        case r'content_json':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contentJson = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatSessionCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatSessionCreateBuilder();
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

