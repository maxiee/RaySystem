//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'note_title_update.g.dart';

/// NoteTitleUpdate
///
/// Properties:
/// * [title] 
/// * [isPrimary] 
@BuiltValue()
abstract class NoteTitleUpdate implements Built<NoteTitleUpdate, NoteTitleUpdateBuilder> {
  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'is_primary')
  bool? get isPrimary;

  NoteTitleUpdate._();

  factory NoteTitleUpdate([void updates(NoteTitleUpdateBuilder b)]) = _$NoteTitleUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NoteTitleUpdateBuilder b) => b
      ..isPrimary = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<NoteTitleUpdate> get serializer => _$NoteTitleUpdateSerializer();
}

class _$NoteTitleUpdateSerializer implements PrimitiveSerializer<NoteTitleUpdate> {
  @override
  final Iterable<Type> types = const [NoteTitleUpdate, _$NoteTitleUpdate];

  @override
  final String wireName = r'NoteTitleUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NoteTitleUpdate object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    NoteTitleUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NoteTitleUpdateBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NoteTitleUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NoteTitleUpdateBuilder();
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

