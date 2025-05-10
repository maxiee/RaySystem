//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/task_schedule_type.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'scheduled_task_response.g.dart';

/// ScheduledTaskResponse
///
/// Properties:
/// * [id] 
/// * [taskType] 
/// * [scheduleType] 
/// * [interval] 
/// * [cronExpression] 
/// * [eventType] 
/// * [nextRun] 
/// * [tag] 
/// * [parameters] 
/// * [enabled] 
@BuiltValue()
abstract class ScheduledTaskResponse implements Built<ScheduledTaskResponse, ScheduledTaskResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'task_type')
  String get taskType;

  @BuiltValueField(wireName: r'schedule_type')
  TaskScheduleType get scheduleType;
  // enum scheduleTypeEnum {  INTERVAL,  CRON,  EVENT,  MANUAL,  };

  @BuiltValueField(wireName: r'interval')
  int get interval;

  @BuiltValueField(wireName: r'cron_expression')
  String? get cronExpression;

  @BuiltValueField(wireName: r'event_type')
  String? get eventType;

  @BuiltValueField(wireName: r'next_run')
  DateTime get nextRun;

  @BuiltValueField(wireName: r'tag')
  String get tag;

  @BuiltValueField(wireName: r'parameters')
  JsonObject get parameters;

  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  ScheduledTaskResponse._();

  factory ScheduledTaskResponse([void updates(ScheduledTaskResponseBuilder b)]) = _$ScheduledTaskResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ScheduledTaskResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ScheduledTaskResponse> get serializer => _$ScheduledTaskResponseSerializer();
}

class _$ScheduledTaskResponseSerializer implements PrimitiveSerializer<ScheduledTaskResponse> {
  @override
  final Iterable<Type> types = const [ScheduledTaskResponse, _$ScheduledTaskResponse];

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
    yield r'schedule_type';
    yield serializers.serialize(
      object.scheduleType,
      specifiedType: const FullType(TaskScheduleType),
    );
    yield r'interval';
    yield serializers.serialize(
      object.interval,
      specifiedType: const FullType(int),
    );
    if (object.cronExpression != null) {
      yield r'cron_expression';
      yield serializers.serialize(
        object.cronExpression,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.eventType != null) {
      yield r'event_type';
      yield serializers.serialize(
        object.eventType,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'next_run';
    yield serializers.serialize(
      object.nextRun,
      specifiedType: const FullType(DateTime),
    );
    yield r'tag';
    yield serializers.serialize(
      object.tag,
      specifiedType: const FullType(String),
    );
    yield r'parameters';
    yield serializers.serialize(
      object.parameters,
      specifiedType: const FullType(JsonObject),
    );
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ScheduledTaskResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
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
        case r'schedule_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TaskScheduleType),
          ) as TaskScheduleType;
          result.scheduleType = valueDes;
          break;
        case r'interval':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.interval = valueDes;
          break;
        case r'cron_expression':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.cronExpression = valueDes;
          break;
        case r'event_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.eventType = valueDes;
          break;
        case r'next_run':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.nextRun = valueDes;
          break;
        case r'tag':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tag = valueDes;
          break;
        case r'parameters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(JsonObject),
          ) as JsonObject;
          result.parameters = valueDes;
          break;
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
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

