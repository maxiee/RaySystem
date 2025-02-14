// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_metrics.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NetworkMetrics extends NetworkMetrics {
  @override
  final num uploadSpeedMb;
  @override
  final num downloadSpeedMb;

  factory _$NetworkMetrics([void Function(NetworkMetricsBuilder)? updates]) =>
      (new NetworkMetricsBuilder()..update(updates))._build();

  _$NetworkMetrics._(
      {required this.uploadSpeedMb, required this.downloadSpeedMb})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        uploadSpeedMb, r'NetworkMetrics', 'uploadSpeedMb');
    BuiltValueNullFieldError.checkNotNull(
        downloadSpeedMb, r'NetworkMetrics', 'downloadSpeedMb');
  }

  @override
  NetworkMetrics rebuild(void Function(NetworkMetricsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NetworkMetricsBuilder toBuilder() =>
      new NetworkMetricsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NetworkMetrics &&
        uploadSpeedMb == other.uploadSpeedMb &&
        downloadSpeedMb == other.downloadSpeedMb;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, uploadSpeedMb.hashCode);
    _$hash = $jc(_$hash, downloadSpeedMb.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NetworkMetrics')
          ..add('uploadSpeedMb', uploadSpeedMb)
          ..add('downloadSpeedMb', downloadSpeedMb))
        .toString();
  }
}

class NetworkMetricsBuilder
    implements Builder<NetworkMetrics, NetworkMetricsBuilder> {
  _$NetworkMetrics? _$v;

  num? _uploadSpeedMb;
  num? get uploadSpeedMb => _$this._uploadSpeedMb;
  set uploadSpeedMb(num? uploadSpeedMb) =>
      _$this._uploadSpeedMb = uploadSpeedMb;

  num? _downloadSpeedMb;
  num? get downloadSpeedMb => _$this._downloadSpeedMb;
  set downloadSpeedMb(num? downloadSpeedMb) =>
      _$this._downloadSpeedMb = downloadSpeedMb;

  NetworkMetricsBuilder() {
    NetworkMetrics._defaults(this);
  }

  NetworkMetricsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _uploadSpeedMb = $v.uploadSpeedMb;
      _downloadSpeedMb = $v.downloadSpeedMb;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NetworkMetrics other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$NetworkMetrics;
  }

  @override
  void update(void Function(NetworkMetricsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NetworkMetrics build() => _build();

  _$NetworkMetrics _build() {
    final _$result = _$v ??
        new _$NetworkMetrics._(
          uploadSpeedMb: BuiltValueNullFieldError.checkNotNull(
              uploadSpeedMb, r'NetworkMetrics', 'uploadSpeedMb'),
          downloadSpeedMb: BuiltValueNullFieldError.checkNotNull(
              downloadSpeedMb, r'NetworkMetrics', 'downloadSpeedMb'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
