//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'scheduled_task_response.g.dart';

/// ScheduledTaskResponse
///
/// Properties:
/// * [id]
/// * [taskType]
/// * [interval]
/// * [tag]
/// * [nextRun]
/// * [parameters]
@BuiltValue()
abstract class ScheduledTaskResponse
    implements Built<ScheduledTaskResponse, ScheduledTaskResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'task_type')
  String get taskType;

  @BuiltValueField(wireName: r'interval')
  int get interval;

  @BuiltValueField(wireName: r'tag')
  String get tag;

  @BuiltValueField(wireName: r'next_run')
  DateTime get nextRun;

  @BuiltValueField(wireName: r'parameters')
  JsonObject get parameters;

  ScheduledTaskResponse._();

  factory ScheduledTaskResponse(
      [void updates(ScheduledTaskResponseBuilder b)]) = _$ScheduledTaskResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ScheduledTaskResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ScheduledTaskResponse> get serializer =>
      _$ScheduledTaskResponseSerializer();
}

class _$ScheduledTaskResponseSerializer
    implements PrimitiveSerializer<ScheduledTaskResponse> {
  @override
  final Iterable<Type> types = const [
    ScheduledTaskResponse,
    _$ScheduledTaskResponse
  ];

  @override
  final String wireName = r'ScheduledTaskResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ScheduledTaskResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'task_type';
    yield serializers.serialize(
      object.taskType,
      specifiedType: const FullType(String),
    );
    yield r'interval';
    yield serializers.serialize(
      object.interval,
      specifiedType: const FullType(int),
    );
    yield r'tag';
    yield serializers.serialize(
      object.tag,
      specifiedType: const FullType(String),
    );
    yield r'next_run';
    yield serializers.serialize(
      object.nextRun,
      specifiedType: const FullType(DateTime),
    );
    yield r'parameters';
    yield serializers.serialize(
      object.parameters,
      specifiedType: const FullType(JsonObject),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ScheduledTaskResponse object, {
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
    required ScheduledTaskResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'task_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.taskType = valueDes;
          break;
        case r'interval':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.interval = valueDes;
          break;
        case r'tag':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tag = valueDes;
          break;
        case r'next_run':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.nextRun = valueDes;
          break;
        case r'parameters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(JsonObject),
          ) as JsonObject;
          result.parameters = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ScheduledTaskResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ScheduledTaskResponseBuilder();
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
