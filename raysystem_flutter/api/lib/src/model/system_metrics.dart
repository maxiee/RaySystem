//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/network_metrics.dart';
import 'package:openapi/src/model/disk_metrics.dart';
import 'package:openapi/src/model/memory_metrics.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'system_metrics.g.dart';

/// SystemMetrics
///
/// Properties:
/// * [cpuPercent]
/// * [memory]
/// * [disks]
/// * [network]
@BuiltValue()
abstract class SystemMetrics
    implements Built<SystemMetrics, SystemMetricsBuilder> {
  @BuiltValueField(wireName: r'cpu_percent')
  num get cpuPercent;

  @BuiltValueField(wireName: r'memory')
  MemoryMetrics get memory;

  @BuiltValueField(wireName: r'disks')
  BuiltList<DiskMetrics> get disks;

  @BuiltValueField(wireName: r'network')
  NetworkMetrics get network;

  SystemMetrics._();

  factory SystemMetrics([void updates(SystemMetricsBuilder b)]) =
      _$SystemMetrics;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SystemMetricsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SystemMetrics> get serializer =>
      _$SystemMetricsSerializer();
}

class _$SystemMetricsSerializer implements PrimitiveSerializer<SystemMetrics> {
  @override
  final Iterable<Type> types = const [SystemMetrics, _$SystemMetrics];

  @override
  final String wireName = r'SystemMetrics';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SystemMetrics object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cpu_percent';
    yield serializers.serialize(
      object.cpuPercent,
      specifiedType: const FullType(num),
    );
    yield r'memory';
    yield serializers.serialize(
      object.memory,
      specifiedType: const FullType(MemoryMetrics),
    );
    yield r'disks';
    yield serializers.serialize(
      object.disks,
      specifiedType: const FullType(BuiltList, [FullType(DiskMetrics)]),
    );
    yield r'network';
    yield serializers.serialize(
      object.network,
      specifiedType: const FullType(NetworkMetrics),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SystemMetrics object, {
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
    required SystemMetricsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cpu_percent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.cpuPercent = valueDes;
          break;
        case r'memory':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MemoryMetrics),
          ) as MemoryMetrics;
          result.memory.replace(valueDes);
          break;
        case r'disks':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DiskMetrics)]),
          ) as BuiltList<DiskMetrics>;
          result.disks.replace(valueDes);
          break;
        case r'network':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(NetworkMetrics),
          ) as NetworkMetrics;
          result.network.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SystemMetrics deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SystemMetricsBuilder();
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
