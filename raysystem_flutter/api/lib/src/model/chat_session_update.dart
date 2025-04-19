//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_session_update.g.dart';

/// Schema for updating an existing chat session.
///
/// Properties:
/// * [title]
/// * [modelName]
/// * [contentJson]
@BuiltValue()
abstract class ChatSessionUpdate
    implements Built<ChatSessionUpdate, ChatSessionUpdateBuilder> {
  @BuiltValueField(wireName: r'title')
  String? get title;

  @BuiltValueField(wireName: r'model_name')
  String? get modelName;

  @BuiltValueField(wireName: r'content_json')
  String? get contentJson;

  ChatSessionUpdate._();

  factory ChatSessionUpdate([void updates(ChatSessionUpdateBuilder b)]) =
      _$ChatSessionUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatSessionUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatSessionUpdate> get serializer =>
      _$ChatSessionUpdateSerializer();
}

class _$ChatSessionUpdateSerializer
    implements PrimitiveSerializer<ChatSessionUpdate> {
  @override
  final Iterable<Type> types = const [ChatSessionUpdate, _$ChatSessionUpdate];

  @override
  final String wireName = r'ChatSessionUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatSessionUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.title != null) {
      yield r'title';
      yield serializers.serialize(
        object.title,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.modelName != null) {
      yield r'model_name';
      yield serializers.serialize(
        object.modelName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.contentJson != null) {
      yield r'content_json';
      yield serializers.serialize(
        object.contentJson,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatSessionUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatSessionUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
  ChatSessionUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatSessionUpdateBuilder();
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
