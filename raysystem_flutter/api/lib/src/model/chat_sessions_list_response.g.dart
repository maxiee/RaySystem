// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_sessions_list_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatSessionsListResponse extends ChatSessionsListResponse {
  @override
  final int total;
  @override
  final BuiltList<ChatSessionResponse> items;

  factory _$ChatSessionsListResponse(
          [void Function(ChatSessionsListResponseBuilder)? updates]) =>
      (new ChatSessionsListResponseBuilder()..update(updates))._build();

  _$ChatSessionsListResponse._({required this.total, required this.items})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        total, r'ChatSessionsListResponse', 'total');
    BuiltValueNullFieldError.checkNotNull(
        items, r'ChatSessionsListResponse', 'items');
  }

  @override
  ChatSessionsListResponse rebuild(
          void Function(ChatSessionsListResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatSessionsListResponseBuilder toBuilder() =>
      new ChatSessionsListResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatSessionsListResponse &&
        total == other.total &&
        items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatSessionsListResponse')
          ..add('total', total)
          ..add('items', items))
        .toString();
  }
}

class ChatSessionsListResponseBuilder
    implements
        Builder<ChatSessionsListResponse, ChatSessionsListResponseBuilder> {
  _$ChatSessionsListResponse? _$v;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  ListBuilder<ChatSessionResponse>? _items;
  ListBuilder<ChatSessionResponse> get items =>
      _$this._items ??= new ListBuilder<ChatSessionResponse>();
  set items(ListBuilder<ChatSessionResponse>? items) => _$this._items = items;

  ChatSessionsListResponseBuilder() {
    ChatSessionsListResponse._defaults(this);
  }

  ChatSessionsListResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _total = $v.total;
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatSessionsListResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ChatSessionsListResponse;
  }

  @override
  void update(void Function(ChatSessionsListResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatSessionsListResponse build() => _build();

  _$ChatSessionsListResponse _build() {
    _$ChatSessionsListResponse _$result;
    try {
      _$result = _$v ??
          new _$ChatSessionsListResponse._(
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'ChatSessionsListResponse', 'total'),
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ChatSessionsListResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
