//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'people_name_response.g.dart';

/// PeopleNameResponse
///
/// Properties:
/// * [name] 
/// * [id] 
/// * [peopleId] 
@BuiltValue()
abstract class PeopleNameResponse implements Built<PeopleNameResponse, PeopleNameResponseBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'people_id')
  int get peopleId;

  PeopleNameResponse._();

  factory PeopleNameResponse([void updates(PeopleNameResponseBuilder b)]) = _$PeopleNameResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PeopleNameResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PeopleNameResponse> get serializer => _$PeopleNameResponseSerializer();
}

class _$PeopleNameResponseSerializer implements PrimitiveSerializer<PeopleNameResponse> {
  @override
  final Iterable<Type> types = const [PeopleNameResponse, _$PeopleNameResponse];

  @override
  final String wireName = r'PeopleNameResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PeopleNameResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'people_id';
    yield serializers.serialize(
      object.peopleId,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PeopleNameResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PeopleNameResponseBuilder result,
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
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'people_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.peopleId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PeopleNameResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PeopleNameResponseBuilder();
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

