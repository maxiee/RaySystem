// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_session_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatSessionCreate extends ChatSessionCreate {
  @override
  final String title;
  @override
  final String? modelName;
  @override
  final String contentJson;

  factory _$ChatSessionCreate(
          [void Function(ChatSessionCreateBuilder)? updates]) =>
      (new ChatSessionCreateBuilder()..update(updates))._build();

  _$ChatSessionCreate._(
      {required this.title, this.modelName, required this.contentJson})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(title, r'ChatSessionCreate', 'title');
    BuiltValueNullFieldError.checkNotNull(
        contentJson, r'ChatSessionCreate', 'contentJson');
  }

  @override
  ChatSessionCreate rebuild(void Function(ChatSessionCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatSessionCreateBuilder toBuilder() =>
      new ChatSessionCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatSessionCreate &&
        title == other.title &&
        modelName == other.modelName &&
        contentJson == other.contentJson;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, modelName.hashCode);
    _$hash = $jc(_$hash, contentJson.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatSessionCreate')
          ..add('title', title)
          ..add('modelName', modelName)
          ..add('contentJson', contentJson))
        .toString();
  }
}

class ChatSessionCreateBuilder
    implements Builder<ChatSessionCreate, ChatSessionCreateBuilder> {
  _$ChatSessionCreate? _$v;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _modelName;
  String? get modelName => _$this._modelName;
  set modelName(String? modelName) => _$this._modelName = modelName;

  String? _contentJson;
  String? get contentJson => _$this._contentJson;
  set contentJson(String? contentJson) => _$this._contentJson = contentJson;

  ChatSessionCreateBuilder() {
    ChatSessionCreate._defaults(this);
  }

  ChatSessionCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _modelName = $v.modelName;
      _contentJson = $v.contentJson;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatSessionCreate other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ChatSessionCreate;
  }

  @override
  void update(void Function(ChatSessionCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatSessionCreate build() => _build();

  _$ChatSessionCreate _build() {
    final _$result = _$v ??
        new _$ChatSessionCreate._(
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'ChatSessionCreate', 'title'),
          modelName: modelName,
          contentJson: BuiltValueNullFieldError.checkNotNull(
              contentJson, r'ChatSessionCreate', 'contentJson'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
