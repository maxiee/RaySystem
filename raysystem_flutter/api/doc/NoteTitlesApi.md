# openapi.api.NoteTitlesApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addNoteTitleNotesNoteIdTitlesPost**](NoteTitlesApi.md#addnotetitlenotesnoteidtitlespost) | **POST** /notes/{note_id}/titles | Add Note Title
[**deleteNoteTitleNotesTitlesTitleIdDelete**](NoteTitlesApi.md#deletenotetitlenotestitlestitleiddelete) | **DELETE** /notes/titles/{title_id} | Delete Note Title
[**getNoteTitlesNotesNoteIdTitlesGet**](NoteTitlesApi.md#getnotetitlesnotesnoteidtitlesget) | **GET** /notes/{note_id}/titles | Get Note Titles
[**updateNoteTitleNotesTitlesTitleIdPut**](NoteTitlesApi.md#updatenotetitlenotestitlestitleidput) | **PUT** /notes/titles/{title_id} | Update Note Title


# **addNoteTitleNotesNoteIdTitlesPost**
> NoteTitleResponse addNoteTitleNotesNoteIdTitlesPost(noteId, noteTitleCreate)

Add Note Title

Add a new title to a note

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getNoteTitlesApi();
final int noteId = 56; // int | 
final NoteTitleCreate noteTitleCreate = ; // NoteTitleCreate | 

try {
    final response = api.addNoteTitleNotesNoteIdTitlesPost(noteId, noteTitleCreate);
    print(response);
} catch on DioException (e) {
    print('Exception when calling NoteTitlesApi->addNoteTitleNotesNoteIdTitlesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **noteId** | **int**|  | 
 **noteTitleCreate** | [**NoteTitleCreate**](NoteTitleCreate.md)|  | 

### Return type

[**NoteTitleResponse**](NoteTitleResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteNoteTitleNotesTitlesTitleIdDelete**
> bool deleteNoteTitleNotesTitlesTitleIdDelete(titleId)

Delete Note Title

Delete a note title  Note: Cannot delete a note's only title or its primary title

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getNoteTitlesApi();
final int titleId = 56; // int | 

try {
    final response = api.deleteNoteTitleNotesTitlesTitleIdDelete(titleId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling NoteTitlesApi->deleteNoteTitleNotesTitlesTitleIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **titleId** | **int**|  | 

### Return type

**bool**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getNoteTitlesNotesNoteIdTitlesGet**
> BuiltList<NoteTitleResponse> getNoteTitlesNotesNoteIdTitlesGet(noteId)

Get Note Titles

Get all titles for a note

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getNoteTitlesApi();
final int noteId = 56; // int | 

try {
    final response = api.getNoteTitlesNotesNoteIdTitlesGet(noteId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling NoteTitlesApi->getNoteTitlesNotesNoteIdTitlesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **noteId** | **int**|  | 

### Return type

[**BuiltList&lt;NoteTitleResponse&gt;**](NoteTitleResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateNoteTitleNotesTitlesTitleIdPut**
> NoteTitleResponse updateNoteTitleNotesTitlesTitleIdPut(titleId, noteTitleUpdate)

Update Note Title

Update an existing note title

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getNoteTitlesApi();
final int titleId = 56; // int | 
final NoteTitleUpdate noteTitleUpdate = ; // NoteTitleUpdate | 

try {
    final response = api.updateNoteTitleNotesTitlesTitleIdPut(titleId, noteTitleUpdate);
    print(response);
} catch on DioException (e) {
    print('Exception when calling NoteTitlesApi->updateNoteTitleNotesTitlesTitleIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **titleId** | **int**|  | 
 **noteTitleUpdate** | [**NoteTitleUpdate**](NoteTitleUpdate.md)|  | 

### Return type

[**NoteTitleResponse**](NoteTitleResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

