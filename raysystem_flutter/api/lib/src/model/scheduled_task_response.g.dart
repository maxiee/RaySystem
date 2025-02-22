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
  final int interval;
  @override
  final String tag;
  @override
  final DateTime nextRun;
  @override
  final JsonObject parameters;

  factory _$ScheduledTaskResponse(
          [void Function(ScheduledTaskResponseBuilder)? updates]) =>
      (new ScheduledTaskResponseBuilder()..update(updates))._build();

  _$ScheduledTaskResponse._(
      {required this.id,
      required this.taskType,
      required this.interval,
      required this.tag,
      required this.nextRun,
      required this.parameters})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'ScheduledTaskResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(
        taskType, r'ScheduledTaskResponse', 'taskType');
    BuiltValueNullFieldError.checkNotNull(
        interval, r'ScheduledTaskResponse', 'interval');
    BuiltValueNullFieldError.checkNotNull(tag, r'ScheduledTaskResponse', 'tag');
    BuiltValueNullFieldError.checkNotNull(
        nextRun, r'ScheduledTaskResponse', 'nextRun');
    BuiltValueNullFieldError.checkNotNull(
        parameters, r'ScheduledTaskResponse', 'parameters');
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
        interval == other.interval &&
        tag == other.tag &&
        nextRun == other.nextRun &&
        parameters == other.parameters;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, taskType.hashCode);
    _$hash = $jc(_$hash, interval.hashCode);
    _$hash = $jc(_$hash, tag.hashCode);
    _$hash = $jc(_$hash, nextRun.hashCode);
    _$hash = $jc(_$hash, parameters.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ScheduledTaskResponse')
          ..add('id', id)
          ..add('taskType', taskType)
          ..add('interval', interval)
          ..add('tag', tag)
          ..add('nextRun', nextRun)
          ..add('parameters', parameters))
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

  int? _interval;
  int? get interval => _$this._interval;
  set interval(int? interval) => _$this._interval = interval;

  String? _tag;
  String? get tag => _$this._tag;
  set tag(String? tag) => _$this._tag = tag;

  DateTime? _nextRun;
  DateTime? get nextRun => _$this._nextRun;
  set nextRun(DateTime? nextRun) => _$this._nextRun = nextRun;

  JsonObject? _parameters;
  JsonObject? get parameters => _$this._parameters;
  set parameters(JsonObject? parameters) => _$this._parameters = parameters;

  ScheduledTaskResponseBuilder() {
    ScheduledTaskResponse._defaults(this);
  }

  ScheduledTaskResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _taskType = $v.taskType;
      _interval = $v.interval;
      _tag = $v.tag;
      _nextRun = $v.nextRun;
      _parameters = $v.parameters;
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
          interval: BuiltValueNullFieldError.checkNotNull(
              interval, r'ScheduledTaskResponse', 'interval'),
          tag: BuiltValueNullFieldError.checkNotNull(
              tag, r'ScheduledTaskResponse', 'tag'),
          nextRun: BuiltValueNullFieldError.checkNotNull(
              nextRun, r'ScheduledTaskResponse', 'nextRun'),
          parameters: BuiltValueNullFieldError.checkNotNull(
              parameters, r'ScheduledTaskResponse', 'parameters'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
