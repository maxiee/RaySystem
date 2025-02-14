//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'memory_metrics.g.dart';

/// MemoryMetrics
///
/// Properties:
/// * [totalGb]
/// * [usedGb]
/// * [availableGb]
/// * [cachedGb]
/// * [percent]
/// * [swapTotalGb]
/// * [swapUsedGb]
/// * [swapFreeGb]
/// * [swapPercent]
@BuiltValue()
abstract class MemoryMetrics
    implements Built<MemoryMetrics, MemoryMetricsBuilder> {
  @BuiltValueField(wireName: r'total_gb')
  num get totalGb;

  @BuiltValueField(wireName: r'used_gb')
  num get usedGb;

  @BuiltValueField(wireName: r'available_gb')
  num get availableGb;

  @BuiltValueField(wireName: r'cached_gb')
  num get cachedGb;

  @BuiltValueField(wireName: r'percent')
  num get percent;

  @BuiltValueField(wireName: r'swap_total_gb')
  num get swapTotalGb;

  @BuiltValueField(wireName: r'swap_used_gb')
  num get swapUsedGb;

  @BuiltValueField(wireName: r'swap_free_gb')
  num get swapFreeGb;

  @BuiltValueField(wireName: r'swap_percent')
  num get swapPercent;

  MemoryMetrics._();

  factory MemoryMetrics([void updates(MemoryMetricsBuilder b)]) =
      _$MemoryMetrics;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MemoryMetricsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MemoryMetrics> get serializer =>
      _$MemoryMetricsSerializer();
}

class _$MemoryMetricsSerializer implements PrimitiveSerializer<MemoryMetrics> {
  @override
  final Iterable<Type> types = const [MemoryMetrics, _$MemoryMetrics];

  @override
  final String wireName = r'MemoryMetrics';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MemoryMetrics object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'total_gb';
    yield serializers.serialize(
      object.totalGb,
      specifiedType: const FullType(num),
    );
    yield r'used_gb';
    yield serializers.serialize(
      object.usedGb,
      specifiedType: const FullType(num),
    );
    yield r'available_gb';
    yield serializers.serialize(
      object.availableGb,
      specifiedType: const FullType(num),
    );
    yield r'cached_gb';
    yield serializers.serialize(
      object.cachedGb,
      specifiedType: const FullType(num),
    );
    yield r'percent';
    yield serializers.serialize(
      object.percent,
      specifiedType: const FullType(num),
    );
    yield r'swap_total_gb';
    yield serializers.serialize(
      object.swapTotalGb,
      specifiedType: const FullType(num),
    );
    yield r'swap_used_gb';
    yield serializers.serialize(
      object.swapUsedGb,
      specifiedType: const FullType(num),
    );
    yield r'swap_free_gb';
    yield serializers.serialize(
      object.swapFreeGb,
      specifiedType: const FullType(num),
    );
    yield r'swap_percent';
    yield serializers.serialize(
      object.swapPercent,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MemoryMetrics object, {
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
    required MemoryMetricsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'total_gb':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.totalGb = valueDes;
          break;
        case r'used_gb':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.usedGb = valueDes;
          break;
        case r'available_gb':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.availableGb = valueDes;
          break;
        case r'cached_gb':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.cachedGb = valueDes;
          break;
        case r'percent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.percent = valueDes;
          break;
        case r'swap_total_gb':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.swapTotalGb = valueDes;
          break;
        case r'swap_used_gb':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.swapUsedGb = valueDes;
          break;
        case r'swap_free_gb':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.swapFreeGb = valueDes;
          break;
        case r'swap_percent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.swapPercent = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MemoryMetrics deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MemoryMetricsBuilder();
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
