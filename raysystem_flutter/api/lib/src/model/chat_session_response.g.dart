// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_session_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatSessionResponse extends ChatSessionResponse {
  @override
  final String title;
  @override
  final String? modelName;
  @override
  final String contentJson;
  @override
  final int id;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$ChatSessionResponse(
          [void Function(ChatSessionResponseBuilder)? updates]) =>
      (new ChatSessionResponseBuilder()..update(updates))._build();

  _$ChatSessionResponse._(
      {required this.title,
      this.modelName,
      required this.contentJson,
      required this.id,
      required this.createdAt,
      required this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        title, r'ChatSessionResponse', 'title');
    BuiltValueNullFieldError.checkNotNull(
        contentJson, r'ChatSessionResponse', 'contentJson');
    BuiltValueNullFieldError.checkNotNull(id, r'ChatSessionResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'ChatSessionResponse', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'ChatSessionResponse', 'updatedAt');
  }

  @override
  ChatSessionResponse rebuild(
          void Function(ChatSessionResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatSessionResponseBuilder toBuilder() =>
      new ChatSessionResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatSessionResponse &&
        title == other.title &&
        modelName == other.modelName &&
        contentJson == other.contentJson &&
        id == other.id &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, modelName.hashCode);
    _$hash = $jc(_$hash, contentJson.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatSessionResponse')
          ..add('title', title)
          ..add('modelName', modelName)
          ..add('contentJson', contentJson)
          ..add('id', id)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class ChatSessionResponseBuilder
    implements Builder<ChatSessionResponse, ChatSessionResponseBuilder> {
  _$ChatSessionResponse? _$v;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _modelName;
  String? get modelName => _$this._modelName;
  set modelName(String? modelName) => _$this._modelName = modelName;

  String? _contentJson;
  String? get contentJson => _$this._contentJson;
  set contentJson(String? contentJson) => _$this._contentJson = contentJson;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  ChatSessionResponseBuilder() {
    ChatSessionResponse._defaults(this);
  }

  ChatSessionResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _modelName = $v.modelName;
      _contentJson = $v.contentJson;
      _id = $v.id;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatSessionResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ChatSessionResponse;
  }

  @override
  void update(void Function(ChatSessionResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatSessionResponse build() => _build();

  _$ChatSessionResponse _build() {
    final _$result = _$v ??
        new _$ChatSessionResponse._(
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'ChatSessionResponse', 'title'),
          modelName: modelName,
          contentJson: BuiltValueNullFieldError.checkNotNull(
              contentJson, r'ChatSessionResponse', 'contentJson'),
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ChatSessionResponse', 'id'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'ChatSessionResponse', 'createdAt'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'ChatSessionResponse', 'updatedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
