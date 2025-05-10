//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/chat_message_input.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_completion_request.g.dart';

/// Request body for the chat completion endpoint.
///
/// Properties:
/// * [messages] - A list of messages comprising the conversation history.
/// * [modelName] 
@BuiltValue()
abstract class ChatCompletionRequest implements Built<ChatCompletionRequest, ChatCompletionRequestBuilder> {
  /// A list of messages comprising the conversation history.
  @BuiltValueField(wireName: r'messages')
  BuiltList<ChatMessageInput> get messages;

  @BuiltValueField(wireName: r'model_name')
  String? get modelName;

  ChatCompletionRequest._();

  factory ChatCompletionRequest([void updates(ChatCompletionRequestBuilder b)]) = _$ChatCompletionRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatCompletionRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatCompletionRequest> get serializer => _$ChatCompletionRequestSerializer();
}

class _$ChatCompletionRequestSerializer implements PrimitiveSerializer<ChatCompletionRequest> {
  @override
  final Iterable<Type> types = const [ChatCompletionRequest, _$ChatCompletionRequest];

  @override
  final String wireName = r'ChatCompletionRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatCompletionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'messages';
    yield serializers.serialize(
      object.messages,
      specifiedType: const FullType(BuiltList, [FullType(ChatMessageInput)]),
    );
    if (object.modelName != null) {
      yield r'model_name';
      yield serializers.serialize(
        object.modelName,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatCompletionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatCompletionRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'messages':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ChatMessageInput)]),
          ) as BuiltList<ChatMessageInput>;
          result.messages.replace(valueDes);
          break;
        case r'model_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.modelName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatCompletionRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatCompletionRequestBuilder();
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

