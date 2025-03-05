// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_task_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ScheduledTaskResponse extends ScheduledTaskResponse {
  @override
  final String id;
  @override
  final String taskType;
  @override
  final TaskScheduleType scheduleType;
  @override
  final int interval;
  @override
  final String? cronExpression;
  @override
  final String? eventType;
  @override
  final DateTime nextRun;
  @override
  final String tag;
  @override
  final JsonObject parameters;
  @override
  final bool enabled;

  factory _$ScheduledTaskResponse(
          [void Function(ScheduledTaskResponseBuilder)? updates]) =>
      (new ScheduledTaskResponseBuilder()..update(updates))._build();

  _$ScheduledTaskResponse._(
      {required this.id,
      required this.taskType,
      required this.scheduleType,
      required this.interval,
      this.cronExpression,
      this.eventType,
      required this.nextRun,
      required this.tag,
      required this.parameters,
      required this.enabled})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'ScheduledTaskResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(
        taskType, r'ScheduledTaskResponse', 'taskType');
    BuiltValueNullFieldError.checkNotNull(
        scheduleType, r'ScheduledTaskResponse', 'scheduleType');
    BuiltValueNullFieldError.checkNotNull(
        interval, r'ScheduledTaskResponse', 'interval');
    BuiltValueNullFieldError.checkNotNull(
        nextRun, r'ScheduledTaskResponse', 'nextRun');
    BuiltValueNullFieldError.checkNotNull(tag, r'ScheduledTaskResponse', 'tag');
    BuiltValueNullFieldError.checkNotNull(
        parameters, r'ScheduledTaskResponse', 'parameters');
    BuiltValueNullFieldError.checkNotNull(
        enabled, r'ScheduledTaskResponse', 'enabled');
  }

  @override
  ScheduledTaskResponse rebuild(
          void Function(ScheduledTaskResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ScheduledTaskResponseBuilder toBuilder() =>
      new ScheduledTaskResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ScheduledTaskResponse &&
        id == other.id &&
        taskType == other.taskType &&
        scheduleType == other.scheduleType &&
        interval == other.interval &&
        cronExpression == other.cronExpression &&
        eventType == other.eventType &&
        nextRun == other.nextRun &&
        tag == other.tag &&
        parameters == other.parameters &&
        enabled == other.enabled;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, taskType.hashCode);
    _$hash = $jc(_$hash, scheduleType.hashCode);
    _$hash = $jc(_$hash, interval.hashCode);
    _$hash = $jc(_$hash, cronExpression.hashCode);
    _$hash = $jc(_$hash, eventType.hashCode);
    _$hash = $jc(_$hash, nextRun.hashCode);
    _$hash = $jc(_$hash, tag.hashCode);
    _$hash = $jc(_$hash, parameters.hashCode);
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ScheduledTaskResponse')
          ..add('id', id)
          ..add('taskType', taskType)
          ..add('scheduleType', scheduleType)
          ..add('interval', interval)
          ..add('cronExpression', cronExpression)
          ..add('eventType', eventType)
          ..add('nextRun', nextRun)
          ..add('tag', tag)
          ..add('parameters', parameters)
          ..add('enabled', enabled))
        .toString();
  }
}

class ScheduledTaskResponseBuilder
    implements Builder<ScheduledTaskResponse, ScheduledTaskResponseBuilder> {
  _$ScheduledTaskResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _taskType;
  String? get taskType => _$this._taskType;
  set taskType(String? taskType) => _$this._taskType = taskType;

  TaskScheduleType? _scheduleType;
  TaskScheduleType? get scheduleType => _$this._scheduleType;
  set scheduleType(TaskScheduleType? scheduleType) =>
      _$this._scheduleType = scheduleType;

  int? _interval;
  int? get interval => _$this._interval;
  set interval(int? interval) => _$this._interval = interval;

  String? _cronExpression;
  String? get cronExpression => _$this._cronExpression;
  set cronExpression(String? cronExpression) =>
      _$this._cronExpression = cronExpression;

  String? _eventType;
  String? get eventType => _$this._eventType;
  set eventType(String? eventType) => _$this._eventType = eventType;

  DateTime? _nextRun;
  DateTime? get nextRun => _$this._nextRun;
  set nextRun(DateTime? nextRun) => _$this._nextRun = nextRun;

  String? _tag;
  String? get tag => _$this._tag;
  set tag(String? tag) => _$this._tag = tag;

  JsonObject? _parameters;
  JsonObject? get parameters => _$this._parameters;
  set parameters(JsonObject? parameters) => _$this._parameters = parameters;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  ScheduledTaskResponseBuilder() {
    ScheduledTaskResponse._defaults(this);
  }

  ScheduledTaskResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _taskType = $v.taskType;
      _scheduleType = $v.scheduleType;
      _interval = $v.interval;
      _cronExpression = $v.cronExpression;
      _eventType = $v.eventType;
      _nextRun = $v.nextRun;
      _tag = $v.tag;
      _parameters = $v.parameters;
      _enabled = $v.enabled;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ScheduledTaskResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ScheduledTaskResponse;
  }

  @override
  void update(void Function(ScheduledTaskResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ScheduledTaskResponse build() => _build();

  _$ScheduledTaskResponse _build() {
    final _$result = _$v ??
        new _$ScheduledTaskResponse._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ScheduledTaskResponse', 'id'),
          taskType: BuiltValueNullFieldError.checkNotNull(
              taskType, r'ScheduledTaskResponse', 'taskType'),
          scheduleType: BuiltValueNullFieldError.checkNotNull(
              scheduleType, r'ScheduledTaskResponse', 'scheduleType'),
          interval: BuiltValueNullFieldError.checkNotNull(
              interval, r'ScheduledTaskResponse', 'interval'),
          cronExpression: cronExpression,
          eventType: eventType,
          nextRun: BuiltValueNullFieldError.checkNotNull(
              nextRun, r'ScheduledTaskResponse', 'nextRun'),
          tag: BuiltValueNullFieldError.checkNotNull(
              tag, r'ScheduledTaskResponse', 'tag'),
          parameters: BuiltValueNullFieldError.checkNotNull(
              parameters, r'ScheduledTaskResponse', 'parameters'),
          enabled: BuiltValueNullFieldError.checkNotNull(
              enabled, r'ScheduledTaskResponse', 'enabled'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
