//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'note_title_response.g.dart';

/// NoteTitleResponse
///
/// Properties:
/// * [title]
/// * [isPrimary]
/// * [id]
/// * [noteId]
/// * [createdAt]
@BuiltValue()
abstract class NoteTitleResponse
    implements Built<NoteTitleResponse, NoteTitleResponseBuilder> {
  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'is_primary')
  bool? get isPrimary;

  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'note_id')
  int get noteId;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  NoteTitleResponse._();

  factory NoteTitleResponse([void updates(NoteTitleResponseBuilder b)]) =
      _$NoteTitleResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NoteTitleResponseBuilder b) => b..isPrimary = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<NoteTitleResponse> get serializer =>
      _$NoteTitleResponseSerializer();
}

class _$NoteTitleResponseSerializer
    implements PrimitiveSerializer<NoteTitleResponse> {
  @override
  final Iterable<Type> types = const [NoteTitleResponse, _$NoteTitleResponse];

  @override
  final String wireName = r'NoteTitleResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NoteTitleResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    if (object.isPrimary != null) {
      yield r'is_primary';
      yield serializers.serialize(
        object.isPrimary,
        specifiedType: const FullType(bool),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'note_id';
    yield serializers.serialize(
      object.noteId,
      specifiedType: const FullType(int),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    NoteTitleResponse object, {
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
    required NoteTitleResponseBuilder result,
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
        case r'is_primary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isPrimary = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'note_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.noteId = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NoteTitleResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NoteTitleResponseBuilder();
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
