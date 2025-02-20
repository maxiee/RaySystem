// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info_stats.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InfoStats extends InfoStats {
  @override
  final int totalCount;
  @override
  final int unreadCount;
  @override
  final int markedCount;

  factory _$InfoStats([void Function(InfoStatsBuilder)? updates]) =>
      (new InfoStatsBuilder()..update(updates))._build();

  _$InfoStats._(
      {required this.totalCount,
      required this.unreadCount,
      required this.markedCount})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        totalCount, r'InfoStats', 'totalCount');
    BuiltValueNullFieldError.checkNotNull(
        unreadCount, r'InfoStats', 'unreadCount');
    BuiltValueNullFieldError.checkNotNull(
        markedCount, r'InfoStats', 'markedCount');
  }

  @override
  InfoStats rebuild(void Function(InfoStatsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InfoStatsBuilder toBuilder() => new InfoStatsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InfoStats &&
        totalCount == other.totalCount &&
        unreadCount == other.unreadCount &&
        markedCount == other.markedCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, totalCount.hashCode);
    _$hash = $jc(_$hash, unreadCount.hashCode);
    _$hash = $jc(_$hash, markedCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InfoStats')
          ..add('totalCount', totalCount)
          ..add('unreadCount', unreadCount)
          ..add('markedCount', markedCount))
        .toString();
  }
}

class InfoStatsBuilder implements Builder<InfoStats, InfoStatsBuilder> {
  _$InfoStats? _$v;

  int? _totalCount;
  int? get totalCount => _$this._totalCount;
  set totalCount(int? totalCount) => _$this._totalCount = totalCount;

  int? _unreadCount;
  int? get unreadCount => _$this._unreadCount;
  set unreadCount(int? unreadCount) => _$this._unreadCount = unreadCount;

  int? _markedCount;
  int? get markedCount => _$this._markedCount;
  set markedCount(int? markedCount) => _$this._markedCount = markedCount;

  InfoStatsBuilder() {
    InfoStats._defaults(this);
  }

  InfoStatsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _totalCount = $v.totalCount;
      _unreadCount = $v.unreadCount;
      _markedCount = $v.markedCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InfoStats other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$InfoStats;
  }

  @override
  void update(void Function(InfoStatsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InfoStats build() => _build();

  _$InfoStats _build() {
    final _$result = _$v ??
        new _$InfoStats._(
          totalCount: BuiltValueNullFieldError.checkNotNull(
              totalCount, r'InfoStats', 'totalCount'),
          unreadCount: BuiltValueNullFieldError.checkNotNull(
              unreadCount, r'InfoStats', 'unreadCount'),
          markedCount: BuiltValueNullFieldError.checkNotNull(
              markedCount, r'InfoStats', 'markedCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
