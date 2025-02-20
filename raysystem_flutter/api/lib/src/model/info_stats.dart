//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'info_stats.g.dart';

/// InfoStats
///
/// Properties:
/// * [totalCount]
/// * [unreadCount]
/// * [markedCount]
@BuiltValue()
abstract class InfoStats implements Built<InfoStats, InfoStatsBuilder> {
  @BuiltValueField(wireName: r'total_count')
  int get totalCount;

  @BuiltValueField(wireName: r'unread_count')
  int get unreadCount;

  @BuiltValueField(wireName: r'marked_count')
  int get markedCount;

  InfoStats._();

  factory InfoStats([void updates(InfoStatsBuilder b)]) = _$InfoStats;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InfoStatsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InfoStats> get serializer => _$InfoStatsSerializer();
}

class _$InfoStatsSerializer implements PrimitiveSerializer<InfoStats> {
  @override
  final Iterable<Type> types = const [InfoStats, _$InfoStats];

  @override
  final String wireName = r'InfoStats';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InfoStats object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'total_count';
    yield serializers.serialize(
      object.totalCount,
      specifiedType: const FullType(int),
    );
    yield r'unread_count';
    yield serializers.serialize(
      object.unreadCount,
      specifiedType: const FullType(int),
    );
    yield r'marked_count';
    yield serializers.serialize(
      object.markedCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InfoStats object, {
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
    required InfoStatsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'total_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalCount = valueDes;
          break;
        case r'unread_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unreadCount = valueDes;
          break;
        case r'marked_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.markedCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InfoStats deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InfoStatsBuilder();
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
