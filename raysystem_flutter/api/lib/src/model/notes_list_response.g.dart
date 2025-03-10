// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes_list_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NotesListResponse extends NotesListResponse {
  @override
  final int total;
  @override
  final BuiltList<NoteResponse> items;

  factory _$NotesListResponse(
          [void Function(NotesListResponseBuilder)? updates]) =>
      (new NotesListResponseBuilder()..update(updates))._build();

  _$NotesListResponse._({required this.total, required this.items})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(total, r'NotesListResponse', 'total');
    BuiltValueNullFieldError.checkNotNull(items, r'NotesListResponse', 'items');
  }

  @override
  NotesListResponse rebuild(void Function(NotesListResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotesListResponseBuilder toBuilder() =>
      new NotesListResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotesListResponse &&
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
    return (newBuiltValueToStringHelper(r'NotesListResponse')
          ..add('total', total)
          ..add('items', items))
        .toString();
  }
}

class NotesListResponseBuilder
    implements Builder<NotesListResponse, NotesListResponseBuilder> {
  _$NotesListResponse? _$v;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  ListBuilder<NoteResponse>? _items;
  ListBuilder<NoteResponse> get items =>
      _$this._items ??= new ListBuilder<NoteResponse>();
  set items(ListBuilder<NoteResponse>? items) => _$this._items = items;

  NotesListResponseBuilder() {
    NotesListResponse._defaults(this);
  }

  NotesListResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _total = $v.total;
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotesListResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$NotesListResponse;
  }

  @override
  void update(void Function(NotesListResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotesListResponse build() => _build();

  _$NotesListResponse _build() {
    _$NotesListResponse _$result;
    try {
      _$result = _$v ??
          new _$NotesListResponse._(
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'NotesListResponse', 'total'),
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'NotesListResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
