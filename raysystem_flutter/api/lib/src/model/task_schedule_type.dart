//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'task_schedule_type.g.dart';

class TaskScheduleType extends EnumClass {

  /// 任务调度类型
  @BuiltValueEnumConst(wireName: r'INTERVAL')
  static const TaskScheduleType INTERVAL = _$INTERVAL;
  /// 任务调度类型
  @BuiltValueEnumConst(wireName: r'CRON')
  static const TaskScheduleType CRON = _$CRON;
  /// 任务调度类型
  @BuiltValueEnumConst(wireName: r'EVENT')
  static const TaskScheduleType EVENT = _$EVENT;
  /// 任务调度类型
  @BuiltValueEnumConst(wireName: r'MANUAL')
  static const TaskScheduleType MANUAL = _$MANUAL;

  static Serializer<TaskScheduleType> get serializer => _$taskScheduleTypeSerializer;

  const TaskScheduleType._(String name): super(name);

  static BuiltSet<TaskScheduleType> get values => _$values;
  static TaskScheduleType valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class TaskScheduleTypeMixin = Object with _$TaskScheduleTypeMixin;

