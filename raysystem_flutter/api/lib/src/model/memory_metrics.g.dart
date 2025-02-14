// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_metrics.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MemoryMetrics extends MemoryMetrics {
  @override
  final num totalGb;
  @override
  final num usedGb;
  @override
  final num availableGb;
  @override
  final num cachedGb;
  @override
  final num percent;
  @override
  final num swapTotalGb;
  @override
  final num swapUsedGb;
  @override
  final num swapFreeGb;
  @override
  final num swapPercent;

  factory _$MemoryMetrics([void Function(MemoryMetricsBuilder)? updates]) =>
      (new MemoryMetricsBuilder()..update(updates))._build();

  _$MemoryMetrics._(
      {required this.totalGb,
      required this.usedGb,
      required this.availableGb,
      required this.cachedGb,
      required this.percent,
      required this.swapTotalGb,
      required this.swapUsedGb,
      required this.swapFreeGb,
      required this.swapPercent})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(totalGb, r'MemoryMetrics', 'totalGb');
    BuiltValueNullFieldError.checkNotNull(usedGb, r'MemoryMetrics', 'usedGb');
    BuiltValueNullFieldError.checkNotNull(
        availableGb, r'MemoryMetrics', 'availableGb');
    BuiltValueNullFieldError.checkNotNull(
        cachedGb, r'MemoryMetrics', 'cachedGb');
    BuiltValueNullFieldError.checkNotNull(percent, r'MemoryMetrics', 'percent');
    BuiltValueNullFieldError.checkNotNull(
        swapTotalGb, r'MemoryMetrics', 'swapTotalGb');
    BuiltValueNullFieldError.checkNotNull(
        swapUsedGb, r'MemoryMetrics', 'swapUsedGb');
    BuiltValueNullFieldError.checkNotNull(
        swapFreeGb, r'MemoryMetrics', 'swapFreeGb');
    BuiltValueNullFieldError.checkNotNull(
        swapPercent, r'MemoryMetrics', 'swapPercent');
  }

  @override
  MemoryMetrics rebuild(void Function(MemoryMetricsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MemoryMetricsBuilder toBuilder() => new MemoryMetricsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MemoryMetrics &&
        totalGb == other.totalGb &&
        usedGb == other.usedGb &&
        availableGb == other.availableGb &&
        cachedGb == other.cachedGb &&
        percent == other.percent &&
        swapTotalGb == other.swapTotalGb &&
        swapUsedGb == other.swapUsedGb &&
        swapFreeGb == other.swapFreeGb &&
        swapPercent == other.swapPercent;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, totalGb.hashCode);
    _$hash = $jc(_$hash, usedGb.hashCode);
    _$hash = $jc(_$hash, availableGb.hashCode);
    _$hash = $jc(_$hash, cachedGb.hashCode);
    _$hash = $jc(_$hash, percent.hashCode);
    _$hash = $jc(_$hash, swapTotalGb.hashCode);
    _$hash = $jc(_$hash, swapUsedGb.hashCode);
    _$hash = $jc(_$hash, swapFreeGb.hashCode);
    _$hash = $jc(_$hash, swapPercent.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MemoryMetrics')
          ..add('totalGb', totalGb)
          ..add('usedGb', usedGb)
          ..add('availableGb', availableGb)
          ..add('cachedGb', cachedGb)
          ..add('percent', percent)
          ..add('swapTotalGb', swapTotalGb)
          ..add('swapUsedGb', swapUsedGb)
          ..add('swapFreeGb', swapFreeGb)
          ..add('swapPercent', swapPercent))
        .toString();
  }
}

class MemoryMetricsBuilder
    implements Builder<MemoryMetrics, MemoryMetricsBuilder> {
  _$MemoryMetrics? _$v;

  num? _totalGb;
  num? get totalGb => _$this._totalGb;
  set totalGb(num? totalGb) => _$this._totalGb = totalGb;

  num? _usedGb;
  num? get usedGb => _$this._usedGb;
  set usedGb(num? usedGb) => _$this._usedGb = usedGb;

  num? _availableGb;
  num? get availableGb => _$this._availableGb;
  set availableGb(num? availableGb) => _$this._availableGb = availableGb;

  num? _cachedGb;
  num? get cachedGb => _$this._cachedGb;
  set cachedGb(num? cachedGb) => _$this._cachedGb = cachedGb;

  num? _percent;
  num? get percent => _$this._percent;
  set percent(num? percent) => _$this._percent = percent;

  num? _swapTotalGb;
  num? get swapTotalGb => _$this._swapTotalGb;
  set swapTotalGb(num? swapTotalGb) => _$this._swapTotalGb = swapTotalGb;

  num? _swapUsedGb;
  num? get swapUsedGb => _$this._swapUsedGb;
  set swapUsedGb(num? swapUsedGb) => _$this._swapUsedGb = swapUsedGb;

  num? _swapFreeGb;
  num? get swapFreeGb => _$this._swapFreeGb;
  set swapFreeGb(num? swapFreeGb) => _$this._swapFreeGb = swapFreeGb;

  num? _swapPercent;
  num? get swapPercent => _$this._swapPercent;
  set swapPercent(num? swapPercent) => _$this._swapPercent = swapPercent;

  MemoryMetricsBuilder() {
    MemoryMetrics._defaults(this);
  }

  MemoryMetricsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _totalGb = $v.totalGb;
      _usedGb = $v.usedGb;
      _availableGb = $v.availableGb;
      _cachedGb = $v.cachedGb;
      _percent = $v.percent;
      _swapTotalGb = $v.swapTotalGb;
      _swapUsedGb = $v.swapUsedGb;
      _swapFreeGb = $v.swapFreeGb;
      _swapPercent = $v.swapPercent;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MemoryMetrics other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$MemoryMetrics;
  }

  @override
  void update(void Function(MemoryMetricsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MemoryMetrics build() => _build();

  _$MemoryMetrics _build() {
    final _$result = _$v ??
        new _$MemoryMetrics._(
          totalGb: BuiltValueNullFieldError.checkNotNull(
              totalGb, r'MemoryMetrics', 'totalGb'),
          usedGb: BuiltValueNullFieldError.checkNotNull(
              usedGb, r'MemoryMetrics', 'usedGb'),
          availableGb: BuiltValueNullFieldError.checkNotNull(
              availableGb, r'MemoryMetrics', 'availableGb'),
          cachedGb: BuiltValueNullFieldError.checkNotNull(
              cachedGb, r'MemoryMetrics', 'cachedGb'),
          percent: BuiltValueNullFieldError.checkNotNull(
              percent, r'MemoryMetrics', 'percent'),
          swapTotalGb: BuiltValueNullFieldError.checkNotNull(
              swapTotalGb, r'MemoryMetrics', 'swapTotalGb'),
          swapUsedGb: BuiltValueNullFieldError.checkNotNull(
              swapUsedGb, r'MemoryMetrics', 'swapUsedGb'),
          swapFreeGb: BuiltValueNullFieldError.checkNotNull(
              swapFreeGb, r'MemoryMetrics', 'swapFreeGb'),
          swapPercent: BuiltValueNullFieldError.checkNotNull(
              swapPercent, r'MemoryMetrics', 'swapPercent'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
