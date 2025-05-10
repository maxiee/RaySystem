//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_message_output.g.dart';

/// Represents the generated message from the LLM (output).
///
/// Properties:
/// * [role] - Role of the message sender (usually 'assistant')
/// * [content] - Content of the generated message
@BuiltValue()
abstract class ChatMessageOutput implements Built<ChatMessageOutput, ChatMessageOutputBuilder> {
  /// Role of the message sender (usually 'assistant')
  @BuiltValueField(wireName: r'role')
  String get role;

  /// Content of the generated message
  @BuiltValueField(wireName: r'content')
  String get content;

  ChatMessageOutput._();

  factory ChatMessageOutput([void updates(ChatMessageOutputBuilder b)]) = _$ChatMessageOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatMessageOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatMessageOutput> get serializer => _$ChatMessageOutputSerializer();
}

class _$ChatMessageOutputSerializer implements PrimitiveSerializer<ChatMessageOutput> {
  @override
  final Iterable<Type> types = const [ChatMessageOutput, _$ChatMessageOutput];

  @override
  final String wireName = r'ChatMessageOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatMessageOutput object, {
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
    ChatMessageOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatMessageOutputBuilder result,
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
  ChatMessageOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatMessageOutputBuilder();
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

