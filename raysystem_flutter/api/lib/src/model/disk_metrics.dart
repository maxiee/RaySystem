//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'disk_metrics.g.dart';

/// DiskMetrics
///
/// Properties:
/// * [device]
/// * [mountPoint]
/// * [volumeName]
/// * [totalGb]
/// * [usedGb]
/// * [freeGb]
/// * [usagePercent]
/// * [readSpeedMb]
/// * [writeSpeedMb]
@BuiltValue()
abstract class DiskMetrics implements Built<DiskMetrics, DiskMetricsBuilder> {
  @BuiltValueField(wireName: r'device')
  String get device;

  @BuiltValueField(wireName: r'mount_point')
  String get mountPoint;

  @BuiltValueField(wireName: r'volume_name')
  String get volumeName;

  @BuiltValueField(wireName: r'total_gb')
  num get totalGb;

  @BuiltValueField(wireName: r'used_gb')
  num get usedGb;

  @BuiltValueField(wireName: r'free_gb')
  num get freeGb;

  @BuiltValueField(wireName: r'usage_percent')
  num get usagePercent;

  @BuiltValueField(wireName: r'read_speed_mb')
  num get readSpeedMb;

  @BuiltValueField(wireName: r'write_speed_mb')
  num get writeSpeedMb;

  DiskMetrics._();

  factory DiskMetrics([void updates(DiskMetricsBuilder b)]) = _$DiskMetrics;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DiskMetricsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DiskMetrics> get serializer => _$DiskMetricsSerializer();
}

class _$DiskMetricsSerializer implements PrimitiveSerializer<DiskMetrics> {
  @override
  final Iterable<Type> types = const [DiskMetrics, _$DiskMetrics];

  @override
  final String wireName = r'DiskMetrics';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DiskMetrics object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'device';
    yield serializers.serialize(
      object.device,
      specifiedType: const FullType(String),
    );
    yield r'mount_point';
    yield serializers.serialize(
      object.mountPoint,
      specifiedType: const FullType(String),
    );
    yield r'volume_name';
    yield serializers.serialize(
      object.volumeName,
      specifiedType: const FullType(String),
    );
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
    yield r'free_gb';
    yield serializers.serialize(
      object.freeGb,
      specifiedType: const FullType(num),
    );
    yield r'usage_percent';
    yield serializers.serialize(
      object.usagePercent,
      specifiedType: const FullType(num),
    );
    yield r'read_speed_mb';
    yield serializers.serialize(
      object.readSpeedMb,
      specifiedType: const FullType(num),
    );
    yield r'write_speed_mb';
    yield serializers.serialize(
      object.writeSpeedMb,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DiskMetrics object, {
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
    required DiskMetricsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'device':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.device = valueDes;
          break;
        case r'mount_point':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mountPoint = valueDes;
          break;
        case r'volume_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.volumeName = valueDes;
          break;
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
        case r'free_gb':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.freeGb = valueDes;
          break;
        case r'usage_percent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.usagePercent = valueDes;
          break;
        case r'read_speed_mb':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.readSpeedMb = valueDes;
          break;
        case r'write_speed_mb':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.writeSpeedMb = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DiskMetrics deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DiskMetricsBuilder();
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
