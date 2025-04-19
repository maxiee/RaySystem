# openapi.api.ChatSessionsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createChatSessionLlmChatSessionsPost_0**](ChatSessionsApi.md#createchatsessionllmchatsessionspost_0) | **POST** /llm/chat-sessions/ | Create Chat Session
[**deleteChatSessionLlmChatSessionsSessionIdDelete_0**](ChatSessionsApi.md#deletechatsessionllmchatsessionssessioniddelete_0) | **DELETE** /llm/chat-sessions/{session_id} | Delete Chat Session
[**getChatSessionLlmChatSessionsSessionIdGet_0**](ChatSessionsApi.md#getchatsessionllmchatsessionssessionidget_0) | **GET** /llm/chat-sessions/{session_id} | Get Chat Session
[**listChatSessionsLlmChatSessionsGet_0**](ChatSessionsApi.md#listchatsessionsllmchatsessionsget_0) | **GET** /llm/chat-sessions/ | List Chat Sessions
[**updateChatSessionLlmChatSessionsSessionIdPut_0**](ChatSessionsApi.md#updatechatsessionllmchatsessionssessionidput_0) | **PUT** /llm/chat-sessions/{session_id} | Update Chat Session


# **createChatSessionLlmChatSessionsPost_0**
> ChatSessionResponse createChatSessionLlmChatSessionsPost_0(chatSessionCreate)

Create Chat Session

Create a new chat session with the specified title, model name, and content

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getChatSessionsApi();
final ChatSessionCreate chatSessionCreate = ; // ChatSessionCreate | 

try {
    final response = api.createChatSessionLlmChatSessionsPost_0(chatSessionCreate);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ChatSessionsApi->createChatSessionLlmChatSessionsPost_0: $e\n');
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

# **deleteChatSessionLlmChatSessionsSessionIdDelete_0**
> bool deleteChatSessionLlmChatSessionsSessionIdDelete_0(sessionId)

Delete Chat Session

Delete a chat session by ID

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getChatSessionsApi();
final int sessionId = 56; // int | 

try {
    final response = api.deleteChatSessionLlmChatSessionsSessionIdDelete_0(sessionId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ChatSessionsApi->deleteChatSessionLlmChatSessionsSessionIdDelete_0: $e\n');
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

# **getChatSessionLlmChatSessionsSessionIdGet_0**
> ChatSessionResponse getChatSessionLlmChatSessionsSessionIdGet_0(sessionId)

Get Chat Session

Get a specific chat session by ID

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getChatSessionsApi();
final int sessionId = 56; // int | 

try {
    final response = api.getChatSessionLlmChatSessionsSessionIdGet_0(sessionId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ChatSessionsApi->getChatSessionLlmChatSessionsSessionIdGet_0: $e\n');
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

# **listChatSessionsLlmChatSessionsGet_0**
> ChatSessionsListResponse listChatSessionsLlmChatSessionsGet_0(limit, offset)

List Chat Sessions

List recently updated chat sessions sorted by update time (newest first)

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getChatSessionsApi();
final int limit = 56; // int | Maximum number of chat sessions to return
final int offset = 56; // int | Number of chat sessions to skip

try {
    final response = api.listChatSessionsLlmChatSessionsGet_0(limit, offset);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ChatSessionsApi->listChatSessionsLlmChatSessionsGet_0: $e\n');
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

# **updateChatSessionLlmChatSessionsSessionIdPut_0**
> ChatSessionResponse updateChatSessionLlmChatSessionsSessionIdPut_0(sessionId, chatSessionUpdate)

Update Chat Session

Update an existing chat session

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getChatSessionsApi();
final int sessionId = 56; // int | 
final ChatSessionUpdate chatSessionUpdate = ; // ChatSessionUpdate | 

try {
    final response = api.updateChatSessionLlmChatSessionsSessionIdPut_0(sessionId, chatSessionUpdate);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ChatSessionsApi->updateChatSessionLlmChatSessionsSessionIdPut_0: $e\n');
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

