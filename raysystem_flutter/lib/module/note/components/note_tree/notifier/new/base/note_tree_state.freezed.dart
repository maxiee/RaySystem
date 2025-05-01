// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_tree_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NoteTreeState {
  NoteTreeItem? get selectedItem => throw _privateConstructorUsedError;

  /// 所有已知笔记的映射，以ID为键
  Map<int, NoteTreeItem> get notesMap => throw _privateConstructorUsedError;

  /// 父子关系映射，键为父ID，值为子ID列表
  Map<int, List<int>> get childrenMap => throw _privateConstructorUsedError;

  /// 根笔记ID列表（没有父笔记的笔记）
  List<int> get rootIds => throw _privateConstructorUsedError;

  /// 展开状态
  Set<int> get expandedFolderIds => throw _privateConstructorUsedError;

  /// 加载状态
  Set<int> get loadingFolderIds => throw _privateConstructorUsedError;

  /// Create a copy of NoteTreeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NoteTreeStateCopyWith<NoteTreeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteTreeStateCopyWith<$Res> {
  factory $NoteTreeStateCopyWith(
          NoteTreeState value, $Res Function(NoteTreeState) then) =
      _$NoteTreeStateCopyWithImpl<$Res, NoteTreeState>;
  @useResult
  $Res call(
      {NoteTreeItem? selectedItem,
      Map<int, NoteTreeItem> notesMap,
      Map<int, List<int>> childrenMap,
      List<int> rootIds,
      Set<int> expandedFolderIds,
      Set<int> loadingFolderIds});
}

/// @nodoc
class _$NoteTreeStateCopyWithImpl<$Res, $Val extends NoteTreeState>
    implements $NoteTreeStateCopyWith<$Res> {
  _$NoteTreeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NoteTreeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedItem = freezed,
    Object? notesMap = null,
    Object? childrenMap = null,
    Object? rootIds = null,
    Object? expandedFolderIds = null,
    Object? loadingFolderIds = null,
  }) {
    return _then(_value.copyWith(
      selectedItem: freezed == selectedItem
          ? _value.selectedItem
          : selectedItem // ignore: cast_nullable_to_non_nullable
              as NoteTreeItem?,
      notesMap: null == notesMap
          ? _value.notesMap
          : notesMap // ignore: cast_nullable_to_non_nullable
              as Map<int, NoteTreeItem>,
      childrenMap: null == childrenMap
          ? _value.childrenMap
          : childrenMap // ignore: cast_nullable_to_non_nullable
              as Map<int, List<int>>,
      rootIds: null == rootIds
          ? _value.rootIds
          : rootIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      expandedFolderIds: null == expandedFolderIds
          ? _value.expandedFolderIds
          : expandedFolderIds // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      loadingFolderIds: null == loadingFolderIds
          ? _value.loadingFolderIds
          : loadingFolderIds // ignore: cast_nullable_to_non_nullable
              as Set<int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NoteTreeStateImplCopyWith<$Res>
    implements $NoteTreeStateCopyWith<$Res> {
  factory _$$NoteTreeStateImplCopyWith(
          _$NoteTreeStateImpl value, $Res Function(_$NoteTreeStateImpl) then) =
      __$$NoteTreeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {NoteTreeItem? selectedItem,
      Map<int, NoteTreeItem> notesMap,
      Map<int, List<int>> childrenMap,
      List<int> rootIds,
      Set<int> expandedFolderIds,
      Set<int> loadingFolderIds});
}

/// @nodoc
class __$$NoteTreeStateImplCopyWithImpl<$Res>
    extends _$NoteTreeStateCopyWithImpl<$Res, _$NoteTreeStateImpl>
    implements _$$NoteTreeStateImplCopyWith<$Res> {
  __$$NoteTreeStateImplCopyWithImpl(
      _$NoteTreeStateImpl _value, $Res Function(_$NoteTreeStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of NoteTreeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedItem = freezed,
    Object? notesMap = null,
    Object? childrenMap = null,
    Object? rootIds = null,
    Object? expandedFolderIds = null,
    Object? loadingFolderIds = null,
  }) {
    return _then(_$NoteTreeStateImpl(
      selectedItem: freezed == selectedItem
          ? _value.selectedItem
          : selectedItem // ignore: cast_nullable_to_non_nullable
              as NoteTreeItem?,
      notesMap: null == notesMap
          ? _value._notesMap
          : notesMap // ignore: cast_nullable_to_non_nullable
              as Map<int, NoteTreeItem>,
      childrenMap: null == childrenMap
          ? _value._childrenMap
          : childrenMap // ignore: cast_nullable_to_non_nullable
              as Map<int, List<int>>,
      rootIds: null == rootIds
          ? _value._rootIds
          : rootIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      expandedFolderIds: null == expandedFolderIds
          ? _value._expandedFolderIds
          : expandedFolderIds // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      loadingFolderIds: null == loadingFolderIds
          ? _value._loadingFolderIds
          : loadingFolderIds // ignore: cast_nullable_to_non_nullable
              as Set<int>,
    ));
  }
}

/// @nodoc

class _$NoteTreeStateImpl implements _NoteTreeState {
  const _$NoteTreeStateImpl(
      {this.selectedItem,
      final Map<int, NoteTreeItem> notesMap = const {},
      final Map<int, List<int>> childrenMap = const {},
      final List<int> rootIds = const [],
      final Set<int> expandedFolderIds = const {},
      final Set<int> loadingFolderIds = const {}})
      : _notesMap = notesMap,
        _childrenMap = childrenMap,
        _rootIds = rootIds,
        _expandedFolderIds = expandedFolderIds,
        _loadingFolderIds = loadingFolderIds;

  @override
  final NoteTreeItem? selectedItem;

  /// 所有已知笔记的映射，以ID为键
  final Map<int, NoteTreeItem> _notesMap;

  /// 所有已知笔记的映射，以ID为键
  @override
  @JsonKey()
  Map<int, NoteTreeItem> get notesMap {
    if (_notesMap is EqualUnmodifiableMapView) return _notesMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_notesMap);
  }

  /// 父子关系映射，键为父ID，值为子ID列表
  final Map<int, List<int>> _childrenMap;

  /// 父子关系映射，键为父ID，值为子ID列表
  @override
  @JsonKey()
  Map<int, List<int>> get childrenMap {
    if (_childrenMap is EqualUnmodifiableMapView) return _childrenMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_childrenMap);
  }

  /// 根笔记ID列表（没有父笔记的笔记）
  final List<int> _rootIds;

  /// 根笔记ID列表（没有父笔记的笔记）
  @override
  @JsonKey()
  List<int> get rootIds {
    if (_rootIds is EqualUnmodifiableListView) return _rootIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rootIds);
  }

  /// 展开状态
  final Set<int> _expandedFolderIds;

  /// 展开状态
  @override
  @JsonKey()
  Set<int> get expandedFolderIds {
    if (_expandedFolderIds is EqualUnmodifiableSetView)
      return _expandedFolderIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_expandedFolderIds);
  }

  /// 加载状态
  final Set<int> _loadingFolderIds;

  /// 加载状态
  @override
  @JsonKey()
  Set<int> get loadingFolderIds {
    if (_loadingFolderIds is EqualUnmodifiableSetView) return _loadingFolderIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_loadingFolderIds);
  }

  @override
  String toString() {
    return 'NoteTreeState(selectedItem: $selectedItem, notesMap: $notesMap, childrenMap: $childrenMap, rootIds: $rootIds, expandedFolderIds: $expandedFolderIds, loadingFolderIds: $loadingFolderIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoteTreeStateImpl &&
            (identical(other.selectedItem, selectedItem) ||
                other.selectedItem == selectedItem) &&
            const DeepCollectionEquality().equals(other._notesMap, _notesMap) &&
            const DeepCollectionEquality()
                .equals(other._childrenMap, _childrenMap) &&
            const DeepCollectionEquality().equals(other._rootIds, _rootIds) &&
            const DeepCollectionEquality()
                .equals(other._expandedFolderIds, _expandedFolderIds) &&
            const DeepCollectionEquality()
                .equals(other._loadingFolderIds, _loadingFolderIds));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      selectedItem,
      const DeepCollectionEquality().hash(_notesMap),
      const DeepCollectionEquality().hash(_childrenMap),
      const DeepCollectionEquality().hash(_rootIds),
      const DeepCollectionEquality().hash(_expandedFolderIds),
      const DeepCollectionEquality().hash(_loadingFolderIds));

  /// Create a copy of NoteTreeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NoteTreeStateImplCopyWith<_$NoteTreeStateImpl> get copyWith =>
      __$$NoteTreeStateImplCopyWithImpl<_$NoteTreeStateImpl>(this, _$identity);
}

abstract class _NoteTreeState implements NoteTreeState {
  const factory _NoteTreeState(
      {final NoteTreeItem? selectedItem,
      final Map<int, NoteTreeItem> notesMap,
      final Map<int, List<int>> childrenMap,
      final List<int> rootIds,
      final Set<int> expandedFolderIds,
      final Set<int> loadingFolderIds}) = _$NoteTreeStateImpl;

  @override
  NoteTreeItem? get selectedItem;

  /// 所有已知笔记的映射，以ID为键
  @override
  Map<int, NoteTreeItem> get notesMap;

  /// 父子关系映射，键为父ID，值为子ID列表
  @override
  Map<int, List<int>> get childrenMap;

  /// 根笔记ID列表（没有父笔记的笔记）
  @override
  List<int> get rootIds;

  /// 展开状态
  @override
  Set<int> get expandedFolderIds;

  /// 加载状态
  @override
  Set<int> get loadingFolderIds;

  /// Create a copy of NoteTreeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NoteTreeStateImplCopyWith<_$NoteTreeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
