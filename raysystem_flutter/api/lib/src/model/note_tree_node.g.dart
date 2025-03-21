// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_tree_node.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NoteTreeNode extends NoteTreeNode {
  @override
  final String title;
  @override
  final String contentAppflowy;
  @override
  final int id;
  @override
  final int? parentId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final bool hasChildren;

  factory _$NoteTreeNode([void Function(NoteTreeNodeBuilder)? updates]) =>
      (new NoteTreeNodeBuilder()..update(updates))._build();

  _$NoteTreeNode._(
      {required this.title,
      required this.contentAppflowy,
      required this.id,
      this.parentId,
      required this.createdAt,
      required this.updatedAt,
      required this.hasChildren})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(title, r'NoteTreeNode', 'title');
    BuiltValueNullFieldError.checkNotNull(
        contentAppflowy, r'NoteTreeNode', 'contentAppflowy');
    BuiltValueNullFieldError.checkNotNull(id, r'NoteTreeNode', 'id');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'NoteTreeNode', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'NoteTreeNode', 'updatedAt');
    BuiltValueNullFieldError.checkNotNull(
        hasChildren, r'NoteTreeNode', 'hasChildren');
  }

  @override
  NoteTreeNode rebuild(void Function(NoteTreeNodeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NoteTreeNodeBuilder toBuilder() => new NoteTreeNodeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NoteTreeNode &&
        title == other.title &&
        contentAppflowy == other.contentAppflowy &&
        id == other.id &&
        parentId == other.parentId &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        hasChildren == other.hasChildren;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, contentAppflowy.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, parentId.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, hasChildren.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NoteTreeNode')
          ..add('title', title)
          ..add('contentAppflowy', contentAppflowy)
          ..add('id', id)
          ..add('parentId', parentId)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('hasChildren', hasChildren))
        .toString();
  }
}

class NoteTreeNodeBuilder
    implements Builder<NoteTreeNode, NoteTreeNodeBuilder> {
  _$NoteTreeNode? _$v;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _contentAppflowy;
  String? get contentAppflowy => _$this._contentAppflowy;
  set contentAppflowy(String? contentAppflowy) =>
      _$this._contentAppflowy = contentAppflowy;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _parentId;
  int? get parentId => _$this._parentId;
  set parentId(int? parentId) => _$this._parentId = parentId;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  bool? _hasChildren;
  bool? get hasChildren => _$this._hasChildren;
  set hasChildren(bool? hasChildren) => _$this._hasChildren = hasChildren;

  NoteTreeNodeBuilder() {
    NoteTreeNode._defaults(this);
  }

  NoteTreeNodeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _contentAppflowy = $v.contentAppflowy;
      _id = $v.id;
      _parentId = $v.parentId;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _hasChildren = $v.hasChildren;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NoteTreeNode other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$NoteTreeNode;
  }

  @override
  void update(void Function(NoteTreeNodeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NoteTreeNode build() => _build();

  _$NoteTreeNode _build() {
    final _$result = _$v ??
        new _$NoteTreeNode._(
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'NoteTreeNode', 'title'),
          contentAppflowy: BuiltValueNullFieldError.checkNotNull(
              contentAppflowy, r'NoteTreeNode', 'contentAppflowy'),
          id: BuiltValueNullFieldError.checkNotNull(id, r'NoteTreeNode', 'id'),
          parentId: parentId,
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'NoteTreeNode', 'createdAt'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'NoteTreeNode', 'updatedAt'),
          hasChildren: BuiltValueNullFieldError.checkNotNull(
              hasChildren, r'NoteTreeNode', 'hasChildren'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
