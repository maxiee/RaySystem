// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'people_list_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PeopleListResponse extends PeopleListResponse {
  @override
  final BuiltList<PeopleResponse> items;
  @override
  final int total;
  @override
  final int page;
  @override
  final int pageSize;
  @override
  final int totalPages;

  factory _$PeopleListResponse(
          [void Function(PeopleListResponseBuilder)? updates]) =>
      (new PeopleListResponseBuilder()..update(updates))._build();

  _$PeopleListResponse._(
      {required this.items,
      required this.total,
      required this.page,
      required this.pageSize,
      required this.totalPages})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        items, r'PeopleListResponse', 'items');
    BuiltValueNullFieldError.checkNotNull(
        total, r'PeopleListResponse', 'total');
    BuiltValueNullFieldError.checkNotNull(page, r'PeopleListResponse', 'page');
    BuiltValueNullFieldError.checkNotNull(
        pageSize, r'PeopleListResponse', 'pageSize');
    BuiltValueNullFieldError.checkNotNull(
        totalPages, r'PeopleListResponse', 'totalPages');
  }

  @override
  PeopleListResponse rebuild(
          void Function(PeopleListResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PeopleListResponseBuilder toBuilder() =>
      new PeopleListResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PeopleListResponse &&
        items == other.items &&
        total == other.total &&
        page == other.page &&
        pageSize == other.pageSize &&
        totalPages == other.totalPages;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, pageSize.hashCode);
    _$hash = $jc(_$hash, totalPages.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PeopleListResponse')
          ..add('items', items)
          ..add('total', total)
          ..add('page', page)
          ..add('pageSize', pageSize)
          ..add('totalPages', totalPages))
        .toString();
  }
}

class PeopleListResponseBuilder
    implements Builder<PeopleListResponse, PeopleListResponseBuilder> {
  _$PeopleListResponse? _$v;

  ListBuilder<PeopleResponse>? _items;
  ListBuilder<PeopleResponse> get items =>
      _$this._items ??= new ListBuilder<PeopleResponse>();
  set items(ListBuilder<PeopleResponse>? items) => _$this._items = items;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  int? _pageSize;
  int? get pageSize => _$this._pageSize;
  set pageSize(int? pageSize) => _$this._pageSize = pageSize;

  int? _totalPages;
  int? get totalPages => _$this._totalPages;
  set totalPages(int? totalPages) => _$this._totalPages = totalPages;

  PeopleListResponseBuilder() {
    PeopleListResponse._defaults(this);
  }

  PeopleListResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _total = $v.total;
      _page = $v.page;
      _pageSize = $v.pageSize;
      _totalPages = $v.totalPages;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PeopleListResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PeopleListResponse;
  }

  @override
  void update(void Function(PeopleListResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PeopleListResponse build() => _build();

  _$PeopleListResponse _build() {
    _$PeopleListResponse _$result;
    try {
      _$result = _$v ??
          new _$PeopleListResponse._(
            items: items.build(),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'PeopleListResponse', 'total'),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'PeopleListResponse', 'page'),
            pageSize: BuiltValueNullFieldError.checkNotNull(
                pageSize, r'PeopleListResponse', 'pageSize'),
            totalPages: BuiltValueNullFieldError.checkNotNull(
                totalPages, r'PeopleListResponse', 'totalPages'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'PeopleListResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
