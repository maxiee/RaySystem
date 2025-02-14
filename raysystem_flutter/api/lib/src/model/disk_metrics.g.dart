// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disk_metrics.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DiskMetrics extends DiskMetrics {
  @override
  final String device;
  @override
  final String mountPoint;
  @override
  final String volumeName;
  @override
  final num totalGb;
  @override
  final num usedGb;
  @override
  final num freeGb;
  @override
  final num usagePercent;
  @override
  final num readSpeedMb;
  @override
  final num writeSpeedMb;

  factory _$DiskMetrics([void Function(DiskMetricsBuilder)? updates]) =>
      (new DiskMetricsBuilder()..update(updates))._build();

  _$DiskMetrics._(
      {required this.device,
      required this.mountPoint,
      required this.volumeName,
      required this.totalGb,
      required this.usedGb,
      required this.freeGb,
      required this.usagePercent,
      required this.readSpeedMb,
      required this.writeSpeedMb})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(device, r'DiskMetrics', 'device');
    BuiltValueNullFieldError.checkNotNull(
        mountPoint, r'DiskMetrics', 'mountPoint');
    BuiltValueNullFieldError.checkNotNull(
        volumeName, r'DiskMetrics', 'volumeName');
    BuiltValueNullFieldError.checkNotNull(totalGb, r'DiskMetrics', 'totalGb');
    BuiltValueNullFieldError.checkNotNull(usedGb, r'DiskMetrics', 'usedGb');
    BuiltValueNullFieldError.checkNotNull(freeGb, r'DiskMetrics', 'freeGb');
    BuiltValueNullFieldError.checkNotNull(
        usagePercent, r'DiskMetrics', 'usagePercent');
    BuiltValueNullFieldError.checkNotNull(
        readSpeedMb, r'DiskMetrics', 'readSpeedMb');
    BuiltValueNullFieldError.checkNotNull(
        writeSpeedMb, r'DiskMetrics', 'writeSpeedMb');
  }

  @override
  DiskMetrics rebuild(void Function(DiskMetricsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DiskMetricsBuilder toBuilder() => new DiskMetricsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DiskMetrics &&
        device == other.device &&
        mountPoint == other.mountPoint &&
        volumeName == other.volumeName &&
        totalGb == other.totalGb &&
        usedGb == other.usedGb &&
        freeGb == other.freeGb &&
        usagePercent == other.usagePercent &&
        readSpeedMb == other.readSpeedMb &&
        writeSpeedMb == other.writeSpeedMb;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, device.hashCode);
    _$hash = $jc(_$hash, mountPoint.hashCode);
    _$hash = $jc(_$hash, volumeName.hashCode);
    _$hash = $jc(_$hash, totalGb.hashCode);
    _$hash = $jc(_$hash, usedGb.hashCode);
    _$hash = $jc(_$hash, freeGb.hashCode);
    _$hash = $jc(_$hash, usagePercent.hashCode);
    _$hash = $jc(_$hash, readSpeedMb.hashCode);
    _$hash = $jc(_$hash, writeSpeedMb.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DiskMetrics')
          ..add('device', device)
          ..add('mountPoint', mountPoint)
          ..add('volumeName', volumeName)
          ..add('totalGb', totalGb)
          ..add('usedGb', usedGb)
          ..add('freeGb', freeGb)
          ..add('usagePercent', usagePercent)
          ..add('readSpeedMb', readSpeedMb)
          ..add('writeSpeedMb', writeSpeedMb))
        .toString();
  }
}

class DiskMetricsBuilder implements Builder<DiskMetrics, DiskMetricsBuilder> {
  _$DiskMetrics? _$v;

  String? _device;
  String? get device => _$this._device;
  set device(String? device) => _$this._device = device;

  String? _mountPoint;
  String? get mountPoint => _$this._mountPoint;
  set mountPoint(String? mountPoint) => _$this._mountPoint = mountPoint;

  String? _volumeName;
  String? get volumeName => _$this._volumeName;
  set volumeName(String? volumeName) => _$this._volumeName = volumeName;

  num? _totalGb;
  num? get totalGb => _$this._totalGb;
  set totalGb(num? totalGb) => _$this._totalGb = totalGb;

  num? _usedGb;
  num? get usedGb => _$this._usedGb;
  set usedGb(num? usedGb) => _$this._usedGb = usedGb;

  num? _freeGb;
  num? get freeGb => _$this._freeGb;
  set freeGb(num? freeGb) => _$this._freeGb = freeGb;

  num? _usagePercent;
  num? get usagePercent => _$this._usagePercent;
  set usagePercent(num? usagePercent) => _$this._usagePercent = usagePercent;

  num? _readSpeedMb;
  num? get readSpeedMb => _$this._readSpeedMb;
  set readSpeedMb(num? readSpeedMb) => _$this._readSpeedMb = readSpeedMb;

  num? _writeSpeedMb;
  num? get writeSpeedMb => _$this._writeSpeedMb;
  set writeSpeedMb(num? writeSpeedMb) => _$this._writeSpeedMb = writeSpeedMb;

  DiskMetricsBuilder() {
    DiskMetrics._defaults(this);
  }

  DiskMetricsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _device = $v.device;
      _mountPoint = $v.mountPoint;
      _volumeName = $v.volumeName;
      _totalGb = $v.totalGb;
      _usedGb = $v.usedGb;
      _freeGb = $v.freeGb;
      _usagePercent = $v.usagePercent;
      _readSpeedMb = $v.readSpeedMb;
      _writeSpeedMb = $v.writeSpeedMb;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DiskMetrics other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DiskMetrics;
  }

  @override
  void update(void Function(DiskMetricsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DiskMetrics build() => _build();

  _$DiskMetrics _build() {
    final _$result = _$v ??
        new _$DiskMetrics._(
          device: BuiltValueNullFieldError.checkNotNull(
              device, r'DiskMetrics', 'device'),
          mountPoint: BuiltValueNullFieldError.checkNotNull(
              mountPoint, r'DiskMetrics', 'mountPoint'),
          volumeName: BuiltValueNullFieldError.checkNotNull(
              volumeName, r'DiskMetrics', 'volumeName'),
          totalGb: BuiltValueNullFieldError.checkNotNull(
              totalGb, r'DiskMetrics', 'totalGb'),
          usedGb: BuiltValueNullFieldError.checkNotNull(
              usedGb, r'DiskMetrics', 'usedGb'),
          freeGb: BuiltValueNullFieldError.checkNotNull(
              freeGb, r'DiskMetrics', 'freeGb'),
          usagePercent: BuiltValueNullFieldError.checkNotNull(
              usagePercent, r'DiskMetrics', 'usagePercent'),
          readSpeedMb: BuiltValueNullFieldError.checkNotNull(
              readSpeedMb, r'DiskMetrics', 'readSpeedMb'),
          writeSpeedMb: BuiltValueNullFieldError.checkNotNull(
              writeSpeedMb, r'DiskMetrics', 'writeSpeedMb'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
