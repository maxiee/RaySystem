//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/note_title_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'note_response.g.dart';

/// NoteResponse
///
/// Properties:
/// * [contentAppflowy] 
/// * [parentId] 
/// * [id] 
/// * [noteTitles] 
/// * [hasChildren] 
/// * [createdAt] 
/// * [updatedAt] 
@BuiltValue()
abstract class NoteResponse implements Built<NoteResponse, NoteResponseBuilder> {
  @BuiltValueField(wireName: r'content_appflowy')
  String get contentAppflowy;

  @BuiltValueField(wireName: r'parent_id')
  int? get parentId;

  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'note_titles')
  BuiltList<NoteTitleResponse> get noteTitles;

  @BuiltValueField(wireName: r'has_children')
  bool get hasChildren;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'updated_at')
  DateTime get updatedAt;

  NoteResponse._();

  factory NoteResponse([void updates(NoteResponseBuilder b)]) = _$NoteResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NoteResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NoteResponse> get serializer => _$NoteResponseSerializer();
}

class _$NoteResponseSerializer implements PrimitiveSerializer<NoteResponse> {
  @override
  final Iterable<Type> types = const [NoteResponse, _$NoteResponse];

  @override
  final String wireName = r'NoteResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NoteResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'content_appflowy';
    yield serializers.serialize(
      object.contentAppflowy,
      specifiedType: const FullType(String),
    );
    if (object.parentId != null) {
      yield r'parent_id';
      yield serializers.serialize(
        object.parentId,
        specifiedType: const FullType.nullable(int),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'note_titles';
    yield serializers.serialize(
      object.noteTitles,
      specifiedType: const FullType(BuiltList, [FullType(NoteTitleResponse)]),
    );
    yield r'has_children';
    yield serializers.serialize(
      object.hasChildren,
      specifiedType: const FullType(bool),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'updated_at';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    NoteResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NoteResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'content_appflowy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contentAppflowy = valueDes;
          break;
        case r'parent_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.parentId = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'note_titles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(NoteTitleResponse)]),
          ) as BuiltList<NoteTitleResponse>;
          result.noteTitles.replace(valueDes);
          break;
        case r'has_children':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hasChildren = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NoteResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NoteResponseBuilder();
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

