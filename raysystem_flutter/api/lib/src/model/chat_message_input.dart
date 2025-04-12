//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_message_input.g.dart';

/// Represents a single message in the chat history (input).
///
/// Properties:
/// * [role] - Role of the message sender (e.g., 'user', 'assistant', 'system')
/// * [content] - Content of the message
@BuiltValue()
abstract class ChatMessageInput
    implements Built<ChatMessageInput, ChatMessageInputBuilder> {
  /// Role of the message sender (e.g., 'user', 'assistant', 'system')
  @BuiltValueField(wireName: r'role')
  String get role;

  /// Content of the message
  @BuiltValueField(wireName: r'content')
  String get content;

  ChatMessageInput._();

  factory ChatMessageInput([void updates(ChatMessageInputBuilder b)]) =
      _$ChatMessageInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatMessageInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatMessageInput> get serializer =>
      _$ChatMessageInputSerializer();
}

class _$ChatMessageInputSerializer
    implements PrimitiveSerializer<ChatMessageInput> {
  @override
  final Iterable<Type> types = const [ChatMessageInput, _$ChatMessageInput];

  @override
  final String wireName = r'ChatMessageInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatMessageInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(String),
    );
    yield r'content';
    yield serializers.serialize(
      object.content,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatMessageInput object, {
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
    required ChatMessageInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.role = valueDes;
          break;
        case r'content':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.content = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatMessageInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatMessageInputBuilder();
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
