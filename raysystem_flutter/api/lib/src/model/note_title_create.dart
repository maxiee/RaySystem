//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'note_title_create.g.dart';

/// NoteTitleCreate
///
/// Properties:
/// * [title]
/// * [isPrimary]
@BuiltValue()
abstract class NoteTitleCreate
    implements Built<NoteTitleCreate, NoteTitleCreateBuilder> {
  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'is_primary')
  bool? get isPrimary;

  NoteTitleCreate._();

  factory NoteTitleCreate([void updates(NoteTitleCreateBuilder b)]) =
      _$NoteTitleCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NoteTitleCreateBuilder b) => b..isPrimary = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<NoteTitleCreate> get serializer =>
      _$NoteTitleCreateSerializer();
}

class _$NoteTitleCreateSerializer
    implements PrimitiveSerializer<NoteTitleCreate> {
  @override
  final Iterable<Type> types = const [NoteTitleCreate, _$NoteTitleCreate];

  @override
  final String wireName = r'NoteTitleCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NoteTitleCreate object, {
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
    NoteTitleCreate object, {
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
    required NoteTitleCreateBuilder result,
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
  NoteTitleCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NoteTitleCreateBuilder();
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
