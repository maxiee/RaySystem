//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'network_metrics.g.dart';

/// NetworkMetrics
///
/// Properties:
/// * [uploadSpeedMb] 
/// * [downloadSpeedMb] 
@BuiltValue()
abstract class NetworkMetrics implements Built<NetworkMetrics, NetworkMetricsBuilder> {
  @BuiltValueField(wireName: r'upload_speed_mb')
  num get uploadSpeedMb;

  @BuiltValueField(wireName: r'download_speed_mb')
  num get downloadSpeedMb;

  NetworkMetrics._();

  factory NetworkMetrics([void updates(NetworkMetricsBuilder b)]) = _$NetworkMetrics;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NetworkMetricsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NetworkMetrics> get serializer => _$NetworkMetricsSerializer();
}

class _$NetworkMetricsSerializer implements PrimitiveSerializer<NetworkMetrics> {
  @override
  final Iterable<Type> types = const [NetworkMetrics, _$NetworkMetrics];

  @override
  final String wireName = r'NetworkMetrics';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NetworkMetrics object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'upload_speed_mb';
    yield serializers.serialize(
      object.uploadSpeedMb,
      specifiedType: const FullType(num),
    );
    yield r'download_speed_mb';
    yield serializers.serialize(
      object.downloadSpeedMb,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    NetworkMetrics object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NetworkMetricsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'upload_speed_mb':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.uploadSpeedMb = valueDes;
          break;
        case r'download_speed_mb':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.downloadSpeedMb = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NetworkMetrics deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NetworkMetricsBuilder();
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

