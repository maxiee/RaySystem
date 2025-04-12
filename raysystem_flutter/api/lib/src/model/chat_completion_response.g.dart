// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_completion_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatCompletionResponse extends ChatCompletionResponse {
  @override
  final ChatMessageOutput message;
  @override
  final String modelUsed;

  factory _$ChatCompletionResponse(
          [void Function(ChatCompletionResponseBuilder)? updates]) =>
      (new ChatCompletionResponseBuilder()..update(updates))._build();

  _$ChatCompletionResponse._({required this.message, required this.modelUsed})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        message, r'ChatCompletionResponse', 'message');
    BuiltValueNullFieldError.checkNotNull(
        modelUsed, r'ChatCompletionResponse', 'modelUsed');
  }

  @override
  ChatCompletionResponse rebuild(
          void Function(ChatCompletionResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatCompletionResponseBuilder toBuilder() =>
      new ChatCompletionResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatCompletionResponse &&
        message == other.message &&
        modelUsed == other.modelUsed;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, modelUsed.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatCompletionResponse')
          ..add('message', message)
          ..add('modelUsed', modelUsed))
        .toString();
  }
}

class ChatCompletionResponseBuilder
    implements Builder<ChatCompletionResponse, ChatCompletionResponseBuilder> {
  _$ChatCompletionResponse? _$v;

  ChatMessageOutputBuilder? _message;
  ChatMessageOutputBuilder get message =>
      _$this._message ??= new ChatMessageOutputBuilder();
  set message(ChatMessageOutputBuilder? message) => _$this._message = message;

  String? _modelUsed;
  String? get modelUsed => _$this._modelUsed;
  set modelUsed(String? modelUsed) => _$this._modelUsed = modelUsed;

  ChatCompletionResponseBuilder() {
    ChatCompletionResponse._defaults(this);
  }

  ChatCompletionResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _message = $v.message.toBuilder();
      _modelUsed = $v.modelUsed;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatCompletionResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ChatCompletionResponse;
  }

  @override
  void update(void Function(ChatCompletionResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatCompletionResponse build() => _build();

  _$ChatCompletionResponse _build() {
    _$ChatCompletionResponse _$result;
    try {
      _$result = _$v ??
          new _$ChatCompletionResponse._(
            message: message.build(),
            modelUsed: BuiltValueNullFieldError.checkNotNull(
                modelUsed, r'ChatCompletionResponse', 'modelUsed'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'message';
        message.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ChatCompletionResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
