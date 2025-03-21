//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/note_tree_node.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'note_tree_response.g.dart';

/// NoteTreeResponse
///
/// Properties:
/// * [total]
/// * [items]
@BuiltValue()
abstract class NoteTreeResponse
    implements Built<NoteTreeResponse, NoteTreeResponseBuilder> {
  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'items')
  BuiltList<NoteTreeNode> get items;

  NoteTreeResponse._();

  factory NoteTreeResponse([void updates(NoteTreeResponseBuilder b)]) =
      _$NoteTreeResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NoteTreeResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NoteTreeResponse> get serializer =>
      _$NoteTreeResponseSerializer();
}

class _$NoteTreeResponseSerializer
    implements PrimitiveSerializer<NoteTreeResponse> {
  @override
  final Iterable<Type> types = const [NoteTreeResponse, _$NoteTreeResponse];

  @override
  final String wireName = r'NoteTreeResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NoteTreeResponse object, {
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
      specifiedType: const FullType(BuiltList, [FullType(NoteTreeNode)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    NoteTreeResponse object, {
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
    required NoteTreeResponseBuilder result,
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
            specifiedType: const FullType(BuiltList, [FullType(NoteTreeNode)]),
          ) as BuiltList<NoteTreeNode>;
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
  NoteTreeResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NoteTreeResponseBuilder();
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
