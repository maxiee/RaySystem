//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/chat_session_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_sessions_list_response.g.dart';

/// Schema for listing multiple chat sessions.
///
/// Properties:
/// * [total] 
/// * [items] 
@BuiltValue()
abstract class ChatSessionsListResponse implements Built<ChatSessionsListResponse, ChatSessionsListResponseBuilder> {
  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'items')
  BuiltList<ChatSessionResponse> get items;

  ChatSessionsListResponse._();

  factory ChatSessionsListResponse([void updates(ChatSessionsListResponseBuilder b)]) = _$ChatSessionsListResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatSessionsListResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatSessionsListResponse> get serializer => _$ChatSessionsListResponseSerializer();
}

class _$ChatSessionsListResponseSerializer implements PrimitiveSerializer<ChatSessionsListResponse> {
  @override
  final Iterable<Type> types = const [ChatSessionsListResponse, _$ChatSessionsListResponse];

  @override
  final String wireName = r'ChatSessionsListResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatSessionsListResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(ChatSessionResponse)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatSessionsListResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatSessionsListResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ChatSessionResponse)]),
          ) as BuiltList<ChatSessionResponse>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatSessionsListResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatSessionsListResponseBuilder();
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

