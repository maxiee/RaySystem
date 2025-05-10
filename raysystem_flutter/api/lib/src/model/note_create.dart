//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/note_title_create.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'note_create.g.dart';

/// NoteCreate
///
/// Properties:
/// * [contentAppflowy]
/// * [parentId]
/// * [titles]
@BuiltValue()
abstract class NoteCreate implements Built<NoteCreate, NoteCreateBuilder> {
  @BuiltValueField(wireName: r'content_appflowy')
  String get contentAppflowy;

  @BuiltValueField(wireName: r'parent_id')
  int? get parentId;

  @BuiltValueField(wireName: r'titles')
  BuiltList<NoteTitleCreate>? get titles;

  NoteCreate._();

  factory NoteCreate([void updates(NoteCreateBuilder b)]) = _$NoteCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NoteCreateBuilder b) => b..titles = ListBuilder();

  @BuiltValueSerializer(custom: true)
  static Serializer<NoteCreate> get serializer => _$NoteCreateSerializer();
}

class _$NoteCreateSerializer implements PrimitiveSerializer<NoteCreate> {
  @override
  final Iterable<Type> types = const [NoteCreate, _$NoteCreate];

  @override
  final String wireName = r'NoteCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NoteCreate object, {
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
    if (object.titles != null) {
      yield r'titles';
      yield serializers.serialize(
        object.titles,
        specifiedType: const FullType(BuiltList, [FullType(NoteTitleCreate)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    NoteCreate object, {
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
    required NoteCreateBuilder result,
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
        case r'titles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(NoteTitleCreate)]),
          ) as BuiltList<NoteTitleCreate>;
          result.titles.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NoteCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NoteCreateBuilder();
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
