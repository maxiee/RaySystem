// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_tree_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NoteTreeResponse extends NoteTreeResponse {
  @override
  final int total;
  @override
  final BuiltList<NoteTreeNode> items;

  factory _$NoteTreeResponse(
          [void Function(NoteTreeResponseBuilder)? updates]) =>
      (new NoteTreeResponseBuilder()..update(updates))._build();

  _$NoteTreeResponse._({required this.total, required this.items}) : super._() {
    BuiltValueNullFieldError.checkNotNull(total, r'NoteTreeResponse', 'total');
    BuiltValueNullFieldError.checkNotNull(items, r'NoteTreeResponse', 'items');
  }

  @override
  NoteTreeResponse rebuild(void Function(NoteTreeResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NoteTreeResponseBuilder toBuilder() =>
      new NoteTreeResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NoteTreeResponse &&
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
    return (newBuiltValueToStringHelper(r'NoteTreeResponse')
          ..add('total', total)
          ..add('items', items))
        .toString();
  }
}

class NoteTreeResponseBuilder
    implements Builder<NoteTreeResponse, NoteTreeResponseBuilder> {
  _$NoteTreeResponse? _$v;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  ListBuilder<NoteTreeNode>? _items;
  ListBuilder<NoteTreeNode> get items =>
      _$this._items ??= new ListBuilder<NoteTreeNode>();
  set items(ListBuilder<NoteTreeNode>? items) => _$this._items = items;

  NoteTreeResponseBuilder() {
    NoteTreeResponse._defaults(this);
  }

  NoteTreeResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _total = $v.total;
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NoteTreeResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$NoteTreeResponse;
  }

  @override
  void update(void Function(NoteTreeResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NoteTreeResponse build() => _build();

  _$NoteTreeResponse _build() {
    _$NoteTreeResponse _$result;
    try {
      _$result = _$v ??
          new _$NoteTreeResponse._(
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'NoteTreeResponse', 'total'),
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'NoteTreeResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
