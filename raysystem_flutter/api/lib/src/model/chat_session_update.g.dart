// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_session_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatSessionUpdate extends ChatSessionUpdate {
  @override
  final String? title;
  @override
  final String? modelName;
  @override
  final String? contentJson;

  factory _$ChatSessionUpdate(
          [void Function(ChatSessionUpdateBuilder)? updates]) =>
      (new ChatSessionUpdateBuilder()..update(updates))._build();

  _$ChatSessionUpdate._({this.title, this.modelName, this.contentJson})
      : super._();

  @override
  ChatSessionUpdate rebuild(void Function(ChatSessionUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatSessionUpdateBuilder toBuilder() =>
      new ChatSessionUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatSessionUpdate &&
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
    return (newBuiltValueToStringHelper(r'ChatSessionUpdate')
          ..add('title', title)
          ..add('modelName', modelName)
          ..add('contentJson', contentJson))
        .toString();
  }
}

class ChatSessionUpdateBuilder
    implements Builder<ChatSessionUpdate, ChatSessionUpdateBuilder> {
  _$ChatSessionUpdate? _$v;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _modelName;
  String? get modelName => _$this._modelName;
  set modelName(String? modelName) => _$this._modelName = modelName;

  String? _contentJson;
  String? get contentJson => _$this._contentJson;
  set contentJson(String? contentJson) => _$this._contentJson = contentJson;

  ChatSessionUpdateBuilder() {
    ChatSessionUpdate._defaults(this);
  }

  ChatSessionUpdateBuilder get _$this {
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
  void replace(ChatSessionUpdate other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ChatSessionUpdate;
  }

  @override
  void update(void Function(ChatSessionUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatSessionUpdate build() => _build();

  _$ChatSessionUpdate _build() {
    final _$result = _$v ??
        new _$ChatSessionUpdate._(
          title: title,
          modelName: modelName,
          contentJson: contentJson,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
