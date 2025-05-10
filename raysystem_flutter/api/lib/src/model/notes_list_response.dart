//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/note_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'notes_list_response.g.dart';

/// NotesListResponse
///
/// Properties:
/// * [total]
/// * [items]
@BuiltValue()
abstract class NotesListResponse
    implements Built<NotesListResponse, NotesListResponseBuilder> {
  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'items')
  BuiltList<NoteResponse> get items;

  NotesListResponse._();

  factory NotesListResponse([void updates(NotesListResponseBuilder b)]) =
      _$NotesListResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NotesListResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NotesListResponse> get serializer =>
      _$NotesListResponseSerializer();
}

class _$NotesListResponseSerializer
    implements PrimitiveSerializer<NotesListResponse> {
  @override
  final Iterable<Type> types = const [NotesListResponse, _$NotesListResponse];

  @override
  final String wireName = r'NotesListResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NotesListResponse object, {
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
      specifiedType: const FullType(BuiltList, [FullType(NoteResponse)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    NotesListResponse object, {
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
    required NotesListResponseBuilder result,
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
            specifiedType: const FullType(BuiltList, [FullType(NoteResponse)]),
          ) as BuiltList<NoteResponse>;
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
  NotesListResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotesListResponseBuilder();
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
