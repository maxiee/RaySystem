//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'note_update.g.dart';

/// NoteUpdate
///
/// Properties:
/// * [contentAppflowy]
/// * [parentId]
@BuiltValue()
abstract class NoteUpdate implements Built<NoteUpdate, NoteUpdateBuilder> {
  @BuiltValueField(wireName: r'content_appflowy')
  String get contentAppflowy;

  @BuiltValueField(wireName: r'parent_id')
  int? get parentId;

  NoteUpdate._();

  factory NoteUpdate([void updates(NoteUpdateBuilder b)]) = _$NoteUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NoteUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NoteUpdate> get serializer => _$NoteUpdateSerializer();
}

class _$NoteUpdateSerializer implements PrimitiveSerializer<NoteUpdate> {
  @override
  final Iterable<Type> types = const [NoteUpdate, _$NoteUpdate];

  @override
  final String wireName = r'NoteUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NoteUpdate object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    NoteUpdate object, {
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
    required NoteUpdateBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NoteUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NoteUpdateBuilder();
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
