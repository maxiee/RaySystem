// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatMessageInput extends ChatMessageInput {
  @override
  final String role;
  @override
  final String content;

  factory _$ChatMessageInput(
          [void Function(ChatMessageInputBuilder)? updates]) =>
      (new ChatMessageInputBuilder()..update(updates))._build();

  _$ChatMessageInput._({required this.role, required this.content})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(role, r'ChatMessageInput', 'role');
    BuiltValueNullFieldError.checkNotNull(
        content, r'ChatMessageInput', 'content');
  }

  @override
  ChatMessageInput rebuild(void Function(ChatMessageInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatMessageInputBuilder toBuilder() =>
      new ChatMessageInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatMessageInput &&
        role == other.role &&
        content == other.content;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, content.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatMessageInput')
          ..add('role', role)
          ..add('content', content))
        .toString();
  }
}

class ChatMessageInputBuilder
    implements Builder<ChatMessageInput, ChatMessageInputBuilder> {
  _$ChatMessageInput? _$v;

  String? _role;
  String? get role => _$this._role;
  set role(String? role) => _$this._role = role;

  String? _content;
  String? get content => _$this._content;
  set content(String? content) => _$this._content = content;

  ChatMessageInputBuilder() {
    ChatMessageInput._defaults(this);
  }

  ChatMessageInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _role = $v.role;
      _content = $v.content;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatMessageInput other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ChatMessageInput;
  }

  @override
  void update(void Function(ChatMessageInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatMessageInput build() => _build();

  _$ChatMessageInput _build() {
    final _$result = _$v ??
        new _$ChatMessageInput._(
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'ChatMessageInput', 'role'),
          content: BuiltValueNullFieldError.checkNotNull(
              content, r'ChatMessageInput', 'content'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
