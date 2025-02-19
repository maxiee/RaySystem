//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/info_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'info_list.g.dart';

/// InfoList
///
/// Properties:
/// * [items]
/// * [total]
/// * [hasMore]
@BuiltValue()
abstract class InfoList implements Built<InfoList, InfoListBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<InfoResponse> get items;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'has_more')
  bool get hasMore;

  InfoList._();

  factory InfoList([void updates(InfoListBuilder b)]) = _$InfoList;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InfoListBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InfoList> get serializer => _$InfoListSerializer();
}

class _$InfoListSerializer implements PrimitiveSerializer<InfoList> {
  @override
  final Iterable<Type> types = const [InfoList, _$InfoList];

  @override
  final String wireName = r'InfoList';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InfoList object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(InfoResponse)]),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'has_more';
    yield serializers.serialize(
      object.hasMore,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InfoList object, {
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
    required InfoListBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(InfoResponse)]),
          ) as BuiltList<InfoResponse>;
          result.items.replace(valueDes);
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'has_more':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hasMore = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InfoList deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InfoListBuilder();
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
