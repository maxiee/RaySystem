// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_metrics.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SystemMetrics extends SystemMetrics {
  @override
  final num cpuPercent;
  @override
  final MemoryMetrics memory;
  @override
  final BuiltList<DiskMetrics> disks;
  @override
  final NetworkMetrics network;

  factory _$SystemMetrics([void Function(SystemMetricsBuilder)? updates]) =>
      (new SystemMetricsBuilder()..update(updates))._build();

  _$SystemMetrics._(
      {required this.cpuPercent,
      required this.memory,
      required this.disks,
      required this.network})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        cpuPercent, r'SystemMetrics', 'cpuPercent');
    BuiltValueNullFieldError.checkNotNull(memory, r'SystemMetrics', 'memory');
    BuiltValueNullFieldError.checkNotNull(disks, r'SystemMetrics', 'disks');
    BuiltValueNullFieldError.checkNotNull(network, r'SystemMetrics', 'network');
  }

  @override
  SystemMetrics rebuild(void Function(SystemMetricsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SystemMetricsBuilder toBuilder() => new SystemMetricsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SystemMetrics &&
        cpuPercent == other.cpuPercent &&
        memory == other.memory &&
        disks == other.disks &&
        network == other.network;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cpuPercent.hashCode);
    _$hash = $jc(_$hash, memory.hashCode);
    _$hash = $jc(_$hash, disks.hashCode);
    _$hash = $jc(_$hash, network.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SystemMetrics')
          ..add('cpuPercent', cpuPercent)
          ..add('memory', memory)
          ..add('disks', disks)
          ..add('network', network))
        .toString();
  }
}

class SystemMetricsBuilder
    implements Builder<SystemMetrics, SystemMetricsBuilder> {
  _$SystemMetrics? _$v;

  num? _cpuPercent;
  num? get cpuPercent => _$this._cpuPercent;
  set cpuPercent(num? cpuPercent) => _$this._cpuPercent = cpuPercent;

  MemoryMetricsBuilder? _memory;
  MemoryMetricsBuilder get memory =>
      _$this._memory ??= new MemoryMetricsBuilder();
  set memory(MemoryMetricsBuilder? memory) => _$this._memory = memory;

  ListBuilder<DiskMetrics>? _disks;
  ListBuilder<DiskMetrics> get disks =>
      _$this._disks ??= new ListBuilder<DiskMetrics>();
  set disks(ListBuilder<DiskMetrics>? disks) => _$this._disks = disks;

  NetworkMetricsBuilder? _network;
  NetworkMetricsBuilder get network =>
      _$this._network ??= new NetworkMetricsBuilder();
  set network(NetworkMetricsBuilder? network) => _$this._network = network;

  SystemMetricsBuilder() {
    SystemMetrics._defaults(this);
  }

  SystemMetricsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cpuPercent = $v.cpuPercent;
      _memory = $v.memory.toBuilder();
      _disks = $v.disks.toBuilder();
      _network = $v.network.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SystemMetrics other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SystemMetrics;
  }

  @override
  void update(void Function(SystemMetricsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SystemMetrics build() => _build();

  _$SystemMetrics _build() {
    _$SystemMetrics _$result;
    try {
      _$result = _$v ??
          new _$SystemMetrics._(
            cpuPercent: BuiltValueNullFieldError.checkNotNull(
                cpuPercent, r'SystemMetrics', 'cpuPercent'),
            memory: memory.build(),
            disks: disks.build(),
            network: network.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'memory';
        memory.build();
        _$failedField = 'disks';
        disks.build();
        _$failedField = 'network';
        network.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'SystemMetrics', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
