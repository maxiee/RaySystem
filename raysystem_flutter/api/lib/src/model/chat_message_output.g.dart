// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatMessageOutput extends ChatMessageOutput {
  @override
  final String role;
  @override
  final String content;

  factory _$ChatMessageOutput(
          [void Function(ChatMessageOutputBuilder)? updates]) =>
      (new ChatMessageOutputBuilder()..update(updates))._build();

  _$ChatMessageOutput._({required this.role, required this.content})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(role, r'ChatMessageOutput', 'role');
    BuiltValueNullFieldError.checkNotNull(
        content, r'ChatMessageOutput', 'content');
  }

  @override
  ChatMessageOutput rebuild(void Function(ChatMessageOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatMessageOutputBuilder toBuilder() =>
      new ChatMessageOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatMessageOutput &&
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
    return (newBuiltValueToStringHelper(r'ChatMessageOutput')
          ..add('role', role)
          ..add('content', content))
        .toString();
  }
}

class ChatMessageOutputBuilder
    implements Builder<ChatMessageOutput, ChatMessageOutputBuilder> {
  _$ChatMessageOutput? _$v;

  String? _role;
  String? get role => _$this._role;
  set role(String? role) => _$this._role = role;

  String? _content;
  String? get content => _$this._content;
  set content(String? content) => _$this._content = content;

  ChatMessageOutputBuilder() {
    ChatMessageOutput._defaults(this);
  }

  ChatMessageOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _role = $v.role;
      _content = $v.content;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatMessageOutput other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ChatMessageOutput;
  }

  @override
  void update(void Function(ChatMessageOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatMessageOutput build() => _build();

  _$ChatMessageOutput _build() {
    final _$result = _$v ??
        new _$ChatMessageOutput._(
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'ChatMessageOutput', 'role'),
          content: BuiltValueNullFieldError.checkNotNull(
              content, r'ChatMessageOutput', 'content'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
