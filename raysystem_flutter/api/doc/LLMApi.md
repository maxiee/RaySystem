# openapi.api.LLMApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**chatCompletionEndpointLlmChatPost**](LLMApi.md#chatcompletionendpointllmchatpost) | **POST** /llm/chat | Generate Chat Completion
[**chatStreamEndpointLlmChatStreamPost**](LLMApi.md#chatstreamendpointllmchatstreampost) | **POST** /llm/chat_stream | Chat Stream Endpoint
[**createChatSessionLlmChatSessionsPost**](LLMApi.md#createchatsessionllmchatsessionspost) | **POST** /llm/chat-sessions/ | Create Chat Session
[**deleteChatSessionLlmChatSessionsSessionIdDelete**](LLMApi.md#deletechatsessionllmchatsessionssessioniddelete) | **DELETE** /llm/chat-sessions/{session_id} | Delete Chat Session
[**getChatSessionLlmChatSessionsSessionIdGet**](LLMApi.md#getchatsessionllmchatsessionssessionidget) | **GET** /llm/chat-sessions/{session_id} | Get Chat Session
[**listChatSessionsLlmChatSessionsGet**](LLMApi.md#listchatsessionsllmchatsessionsget) | **GET** /llm/chat-sessions/ | List Chat Sessions
[**listModelsEndpointLlmModelsGet**](LLMApi.md#listmodelsendpointllmmodelsget) | **GET** /llm/models | List Available LLM Models
[**updateChatSessionLlmChatSessionsSessionIdPut**](LLMApi.md#updatechatsessionllmchatsessionssessionidput) | **PUT** /llm/chat-sessions/{session_id} | Update Chat Session


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

# **chatStreamEndpointLlmChatStreamPost**
> JsonObject chatStreamEndpointLlmChatStreamPost(chatCompletionRequest)

Chat Stream Endpoint

Stream chat completions as SSE events.  Returns a real-time stream of partial completion results as they're generated.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getLLMApi();
final ChatCompletionRequest chatCompletionRequest = ; // ChatCompletionRequest | 

try {
    final response = api.chatStreamEndpointLlmChatStreamPost(chatCompletionRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling LLMApi->chatStreamEndpointLlmChatStreamPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **chatCompletionRequest** | [**ChatCompletionRequest**](ChatCompletionRequest.md)|  | 

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createChatSessionLlmChatSessionsPost**
> ChatSessionResponse createChatSessionLlmChatSessionsPost(chatSessionCreate)

Create Chat Session

Create a new chat session with the specified title, model name, and content

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getLLMApi();
final ChatSessionCreate chatSessionCreate = ; // ChatSessionCreate | 

try {
    final response = api.createChatSessionLlmChatSessionsPost(chatSessionCreate);
    print(response);
} catch on DioException (e) {
    print('Exception when calling LLMApi->createChatSessionLlmChatSessionsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **chatSessionCreate** | [**ChatSessionCreate**](ChatSessionCreate.md)|  | 

### Return type

[**ChatSessionResponse**](ChatSessionResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteChatSessionLlmChatSessionsSessionIdDelete**
> bool deleteChatSessionLlmChatSessionsSessionIdDelete(sessionId)

Delete Chat Session

Delete a chat session by ID

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getLLMApi();
final int sessionId = 56; // int | 

try {
    final response = api.deleteChatSessionLlmChatSessionsSessionIdDelete(sessionId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling LLMApi->deleteChatSessionLlmChatSessionsSessionIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **sessionId** | **int**|  | 

### Return type

**bool**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getChatSessionLlmChatSessionsSessionIdGet**
> ChatSessionResponse getChatSessionLlmChatSessionsSessionIdGet(sessionId)

Get Chat Session

Get a specific chat session by ID

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getLLMApi();
final int sessionId = 56; // int | 

try {
    final response = api.getChatSessionLlmChatSessionsSessionIdGet(sessionId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling LLMApi->getChatSessionLlmChatSessionsSessionIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **sessionId** | **int**|  | 

### Return type

[**ChatSessionResponse**](ChatSessionResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listChatSessionsLlmChatSessionsGet**
> ChatSessionsListResponse listChatSessionsLlmChatSessionsGet(limit, offset)

List Chat Sessions

List recently updated chat sessions sorted by update time (newest first)

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getLLMApi();
final int limit = 56; // int | Maximum number of chat sessions to return
final int offset = 56; // int | Number of chat sessions to skip

try {
    final response = api.listChatSessionsLlmChatSessionsGet(limit, offset);
    print(response);
} catch on DioException (e) {
    print('Exception when calling LLMApi->listChatSessionsLlmChatSessionsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Maximum number of chat sessions to return | [optional] [default to 20]
 **offset** | **int**| Number of chat sessions to skip | [optional] [default to 0]

### Return type

[**ChatSessionsListResponse**](ChatSessionsListResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
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

# **updateChatSessionLlmChatSessionsSessionIdPut**
> ChatSessionResponse updateChatSessionLlmChatSessionsSessionIdPut(sessionId, chatSessionUpdate)

Update Chat Session

Update an existing chat session

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getLLMApi();
final int sessionId = 56; // int | 
final ChatSessionUpdate chatSessionUpdate = ; // ChatSessionUpdate | 

try {
    final response = api.updateChatSessionLlmChatSessionsSessionIdPut(sessionId, chatSessionUpdate);
    print(response);
} catch on DioException (e) {
    print('Exception when calling LLMApi->updateChatSessionLlmChatSessionsSessionIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **sessionId** | **int**|  | 
 **chatSessionUpdate** | [**ChatSessionUpdate**](ChatSessionUpdate.md)|  | 

### Return type

[**ChatSessionResponse**](ChatSessionResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

