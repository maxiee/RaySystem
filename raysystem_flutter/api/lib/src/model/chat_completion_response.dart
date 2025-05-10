//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/chat_message_output.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_completion_response.g.dart';

/// Response body for the chat completion endpoint.
///
/// Properties:
/// * [message] - The generated chat message from the assistant.
/// * [modelUsed] - The name of the model used for this completion.
@BuiltValue()
abstract class ChatCompletionResponse implements Built<ChatCompletionResponse, ChatCompletionResponseBuilder> {
  /// The generated chat message from the assistant.
  @BuiltValueField(wireName: r'message')
  ChatMessageOutput get message;

  /// The name of the model used for this completion.
  @BuiltValueField(wireName: r'model_used')
  String get modelUsed;

  ChatCompletionResponse._();

  factory ChatCompletionResponse([void updates(ChatCompletionResponseBuilder b)]) = _$ChatCompletionResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatCompletionResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatCompletionResponse> get serializer => _$ChatCompletionResponseSerializer();
}

class _$ChatCompletionResponseSerializer implements PrimitiveSerializer<ChatCompletionResponse> {
  @override
  final Iterable<Type> types = const [ChatCompletionResponse, _$ChatCompletionResponse];

  @override
  final String wireName = r'ChatCompletionResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatCompletionResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(ChatMessageOutput),
    );
    yield r'model_used';
    yield serializers.serialize(
      object.modelUsed,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatCompletionResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatCompletionResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ChatMessageOutput),
          ) as ChatMessageOutput;
          result.message.replace(valueDes);
          break;
        case r'model_used':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.modelUsed = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatCompletionResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatCompletionResponseBuilder();
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

