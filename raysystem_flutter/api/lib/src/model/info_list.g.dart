// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InfoList extends InfoList {
  @override
  final BuiltList<InfoResponse> items;
  @override
  final int total;
  @override
  final bool hasMore;

  factory _$InfoList([void Function(InfoListBuilder)? updates]) =>
      (new InfoListBuilder()..update(updates))._build();

  _$InfoList._(
      {required this.items, required this.total, required this.hasMore})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(items, r'InfoList', 'items');
    BuiltValueNullFieldError.checkNotNull(total, r'InfoList', 'total');
    BuiltValueNullFieldError.checkNotNull(hasMore, r'InfoList', 'hasMore');
  }

  @override
  InfoList rebuild(void Function(InfoListBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InfoListBuilder toBuilder() => new InfoListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InfoList &&
        items == other.items &&
        total == other.total &&
        hasMore == other.hasMore;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, hasMore.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InfoList')
          ..add('items', items)
          ..add('total', total)
          ..add('hasMore', hasMore))
        .toString();
  }
}

class InfoListBuilder implements Builder<InfoList, InfoListBuilder> {
  _$InfoList? _$v;

  ListBuilder<InfoResponse>? _items;
  ListBuilder<InfoResponse> get items =>
      _$this._items ??= new ListBuilder<InfoResponse>();
  set items(ListBuilder<InfoResponse>? items) => _$this._items = items;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  bool? _hasMore;
  bool? get hasMore => _$this._hasMore;
  set hasMore(bool? hasMore) => _$this._hasMore = hasMore;

  InfoListBuilder() {
    InfoList._defaults(this);
  }

  InfoListBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _total = $v.total;
      _hasMore = $v.hasMore;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InfoList other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$InfoList;
  }

  @override
  void update(void Function(InfoListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InfoList build() => _build();

  _$InfoList _build() {
    _$InfoList _$result;
    try {
      _$result = _$v ??
          new _$InfoList._(
            items: items.build(),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'InfoList', 'total'),
            hasMore: BuiltValueNullFieldError.checkNotNull(
                hasMore, r'InfoList', 'hasMore'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'InfoList', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
