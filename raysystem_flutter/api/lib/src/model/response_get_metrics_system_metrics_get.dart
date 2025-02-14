//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/network_metrics.dart';
import 'package:openapi/src/model/disk_metrics.dart';
import 'package:openapi/src/model/memory_metrics.dart';
import 'package:openapi/src/model/system_metrics.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/any_of.dart';

part 'response_get_metrics_system_metrics_get.g.dart';

/// ResponseGetMetricsSystemMetricsGet
///
/// Properties:
/// * [cpuPercent]
/// * [memory]
/// * [disks]
/// * [network]
@BuiltValue()
abstract class ResponseGetMetricsSystemMetricsGet
    implements
        Built<ResponseGetMetricsSystemMetricsGet,
            ResponseGetMetricsSystemMetricsGetBuilder> {
  /// Any Of [BuiltMap<String, String>], [SystemMetrics]
  AnyOf get anyOf;

  ResponseGetMetricsSystemMetricsGet._();

  factory ResponseGetMetricsSystemMetricsGet(
          [void updates(ResponseGetMetricsSystemMetricsGetBuilder b)]) =
      _$ResponseGetMetricsSystemMetricsGet;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ResponseGetMetricsSystemMetricsGetBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ResponseGetMetricsSystemMetricsGet> get serializer =>
      _$ResponseGetMetricsSystemMetricsGetSerializer();
}

class _$ResponseGetMetricsSystemMetricsGetSerializer
    implements PrimitiveSerializer<ResponseGetMetricsSystemMetricsGet> {
  @override
  final Iterable<Type> types = const [
    ResponseGetMetricsSystemMetricsGet,
    _$ResponseGetMetricsSystemMetricsGet
  ];

  @override
  final String wireName = r'ResponseGetMetricsSystemMetricsGet';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ResponseGetMetricsSystemMetricsGet object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {}

  @override
  Object serialize(
    Serializers serializers,
    ResponseGetMetricsSystemMetricsGet object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final anyOf = object.anyOf;
    return serializers.serialize(anyOf,
        specifiedType: FullType(
            AnyOf, anyOf.valueTypes.map((type) => FullType(type)).toList()))!;
  }

  @override
  ResponseGetMetricsSystemMetricsGet deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ResponseGetMetricsSystemMetricsGetBuilder();
    Object? anyOfDataSrc;
    final targetType = const FullType(AnyOf, [
      FullType(SystemMetrics),
      FullType(BuiltMap, [FullType(String), FullType(String)]),
    ]);
    anyOfDataSrc = serialized;
    result.anyOf = serializers.deserialize(anyOfDataSrc,
        specifiedType: targetType) as AnyOf;
    return result.build();
  }
}
