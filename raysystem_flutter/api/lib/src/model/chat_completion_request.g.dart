// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_completion_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatCompletionRequest extends ChatCompletionRequest {
  @override
  final BuiltList<ChatMessageInput> messages;
  @override
  final String? modelName;

  factory _$ChatCompletionRequest(
          [void Function(ChatCompletionRequestBuilder)? updates]) =>
      (new ChatCompletionRequestBuilder()..update(updates))._build();

  _$ChatCompletionRequest._({required this.messages, this.modelName})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        messages, r'ChatCompletionRequest', 'messages');
  }

  @override
  ChatCompletionRequest rebuild(
          void Function(ChatCompletionRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatCompletionRequestBuilder toBuilder() =>
      new ChatCompletionRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatCompletionRequest &&
        messages == other.messages &&
        modelName == other.modelName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, messages.hashCode);
    _$hash = $jc(_$hash, modelName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatCompletionRequest')
          ..add('messages', messages)
          ..add('modelName', modelName))
        .toString();
  }
}

class ChatCompletionRequestBuilder
    implements Builder<ChatCompletionRequest, ChatCompletionRequestBuilder> {
  _$ChatCompletionRequest? _$v;

  ListBuilder<ChatMessageInput>? _messages;
  ListBuilder<ChatMessageInput> get messages =>
      _$this._messages ??= new ListBuilder<ChatMessageInput>();
  set messages(ListBuilder<ChatMessageInput>? messages) =>
      _$this._messages = messages;

  String? _modelName;
  String? get modelName => _$this._modelName;
  set modelName(String? modelName) => _$this._modelName = modelName;

  ChatCompletionRequestBuilder() {
    ChatCompletionRequest._defaults(this);
  }

  ChatCompletionRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _messages = $v.messages.toBuilder();
      _modelName = $v.modelName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatCompletionRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ChatCompletionRequest;
  }

  @override
  void update(void Function(ChatCompletionRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatCompletionRequest build() => _build();

  _$ChatCompletionRequest _build() {
    _$ChatCompletionRequest _$result;
    try {
      _$result = _$v ??
          new _$ChatCompletionRequest._(
            messages: messages.build(),
            modelName: modelName,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'messages';
        messages.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ChatCompletionRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
