//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/people_name_response.dart';
import 'package:openapi/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'people_response.g.dart';

/// PeopleResponse
///
/// Properties:
/// * [description]
/// * [avatar]
/// * [birthDate]
/// * [id]
/// * [names]
@BuiltValue()
abstract class PeopleResponse
    implements Built<PeopleResponse, PeopleResponseBuilder> {
  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'avatar')
  String? get avatar;

  @BuiltValueField(wireName: r'birth_date')
  Date? get birthDate;

  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'names')
  BuiltList<PeopleNameResponse>? get names;

  PeopleResponse._();

  factory PeopleResponse([void updates(PeopleResponseBuilder b)]) =
      _$PeopleResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PeopleResponseBuilder b) => b..names = ListBuilder();

  @BuiltValueSerializer(custom: true)
  static Serializer<PeopleResponse> get serializer =>
      _$PeopleResponseSerializer();
}

class _$PeopleResponseSerializer
    implements PrimitiveSerializer<PeopleResponse> {
  @override
  final Iterable<Type> types = const [PeopleResponse, _$PeopleResponse];

  @override
  final String wireName = r'PeopleResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PeopleResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.avatar != null) {
      yield r'avatar';
      yield serializers.serialize(
        object.avatar,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.birthDate != null) {
      yield r'birth_date';
      yield serializers.serialize(
        object.birthDate,
        specifiedType: const FullType.nullable(Date),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    if (object.names != null) {
      yield r'names';
      yield serializers.serialize(
        object.names,
        specifiedType:
            const FullType(BuiltList, [FullType(PeopleNameResponse)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PeopleResponse object, {
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
    required PeopleResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'avatar':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.avatar = valueDes;
          break;
        case r'birth_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.birthDate = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'names':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(PeopleNameResponse)]),
          ) as BuiltList<PeopleNameResponse>;
          result.names.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PeopleResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PeopleResponseBuilder();
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
