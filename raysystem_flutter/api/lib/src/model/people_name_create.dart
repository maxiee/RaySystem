//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'people_name_create.g.dart';

/// PeopleNameCreate
///
/// Properties:
/// * [name]
@BuiltValue()
abstract class PeopleNameCreate
    implements Built<PeopleNameCreate, PeopleNameCreateBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  PeopleNameCreate._();

  factory PeopleNameCreate([void updates(PeopleNameCreateBuilder b)]) =
      _$PeopleNameCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PeopleNameCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PeopleNameCreate> get serializer =>
      _$PeopleNameCreateSerializer();
}

class _$PeopleNameCreateSerializer
    implements PrimitiveSerializer<PeopleNameCreate> {
  @override
  final Iterable<Type> types = const [PeopleNameCreate, _$PeopleNameCreate];

  @override
  final String wireName = r'PeopleNameCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PeopleNameCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PeopleNameCreate object, {
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
    required PeopleNameCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PeopleNameCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PeopleNameCreateBuilder();
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
