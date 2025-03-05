// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_schedule_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TaskScheduleType _$INTERVAL = const TaskScheduleType._('INTERVAL');
const TaskScheduleType _$CRON = const TaskScheduleType._('CRON');
const TaskScheduleType _$EVENT = const TaskScheduleType._('EVENT');
const TaskScheduleType _$MANUAL = const TaskScheduleType._('MANUAL');

TaskScheduleType _$valueOf(String name) {
  switch (name) {
    case 'INTERVAL':
      return _$INTERVAL;
    case 'CRON':
      return _$CRON;
    case 'EVENT':
      return _$EVENT;
    case 'MANUAL':
      return _$MANUAL;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<TaskScheduleType> _$values =
    new BuiltSet<TaskScheduleType>(const <TaskScheduleType>[
  _$INTERVAL,
  _$CRON,
  _$EVENT,
  _$MANUAL,
]);

class _$TaskScheduleTypeMeta {
  const _$TaskScheduleTypeMeta();
  TaskScheduleType get INTERVAL => _$INTERVAL;
  TaskScheduleType get CRON => _$CRON;
  TaskScheduleType get EVENT => _$EVENT;
  TaskScheduleType get MANUAL => _$MANUAL;
  TaskScheduleType valueOf(String name) => _$valueOf(name);
  BuiltSet<TaskScheduleType> get values => _$values;
}

abstract class _$TaskScheduleTypeMixin {
  // ignore: non_constant_identifier_names
  _$TaskScheduleTypeMeta get TaskScheduleType => const _$TaskScheduleTypeMeta();
}

Serializer<TaskScheduleType> _$taskScheduleTypeSerializer =
    new _$TaskScheduleTypeSerializer();

class _$TaskScheduleTypeSerializer
    implements PrimitiveSerializer<TaskScheduleType> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'INTERVAL': 'INTERVAL',
    'CRON': 'CRON',
    'EVENT': 'EVENT',
    'MANUAL': 'MANUAL',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'INTERVAL': 'INTERVAL',
    'CRON': 'CRON',
    'EVENT': 'EVENT',
    'MANUAL': 'MANUAL',
  };

  @override
  final Iterable<Type> types = const <Type>[TaskScheduleType];
  @override
  final String wireName = 'TaskScheduleType';

  @override
  Object serialize(Serializers serializers, TaskScheduleType object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TaskScheduleType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TaskScheduleType.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
