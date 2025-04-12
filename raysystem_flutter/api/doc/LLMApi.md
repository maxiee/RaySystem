# openapi.api.LLMApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**chatCompletionEndpointLlmChatPost**](LLMApi.md#chatcompletionendpointllmchatpost) | **POST** /llm/chat | Generate Chat Completion
[**listModelsEndpointLlmModelsGet**](LLMApi.md#listmodelsendpointllmmodelsget) | **GET** /llm/models | List Available LLM Models


# **chatCompletionEndpointLlmChatPost**
> ChatCompletionResponse chatCompletionEndpointLlmChatPost(chatCompletionRequest)

Generate Chat Completion

Sends a conversation history to the configured LLM and returns the next message.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getLLMApi();
final ChatCompletionRequest chatCompletionRequest = ; // ChatCompletionRequest | 

try {
    final response = api.chatCompletionEndpointLlmChatPost(chatCompletionRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling LLMApi->chatCompletionEndpointLlmChatPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **chatCompletionRequest** | [**ChatCompletionRequest**](ChatCompletionRequest.md)|  | 

### Return type

[**ChatCompletionResponse**](ChatCompletionResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listModelsEndpointLlmModelsGet**
> ListModelsResponse listModelsEndpointLlmModelsGet()

List Available LLM Models

Returns a list of available LLM models that can be used for chat completions.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getLLMApi();

try {
    final response = api.listModelsEndpointLlmModelsGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling LLMApi->listModelsEndpointLlmModelsGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ListModelsResponse**](ListModelsResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

