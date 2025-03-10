# openapi.api.NotesApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createNoteNotesPost**](NotesApi.md#createnotenotespost) | **POST** /notes/ | Create Note
[**deleteNoteNotesNoteIdDelete**](NotesApi.md#deletenotenotesnoteiddelete) | **DELETE** /notes/{note_id} | Delete Note
[**getNoteNotesNoteIdGet**](NotesApi.md#getnotenotesnoteidget) | **GET** /notes/{note_id} | Get Note
[**listRecentNotesNotesGet**](NotesApi.md#listrecentnotesnotesget) | **GET** /notes/ | List Recent Notes
[**searchNotesNotesSearchGet**](NotesApi.md#searchnotesnotessearchget) | **GET** /notes/search | Search Notes
[**updateNoteNotesNoteIdPut**](NotesApi.md#updatenotenotesnoteidput) | **PUT** /notes/{note_id} | Update Note


# **createNoteNotesPost**
> NoteResponse createNoteNotesPost(noteCreate)

Create Note

Create a new note with title and AppFlowy editor content

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getNotesApi();
final NoteCreate noteCreate = ; // NoteCreate | 

try {
    final response = api.createNoteNotesPost(noteCreate);
    print(response);
} catch on DioException (e) {
    print('Exception when calling NotesApi->createNoteNotesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **noteCreate** | [**NoteCreate**](NoteCreate.md)|  | 

### Return type

[**NoteResponse**](NoteResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteNoteNotesNoteIdDelete**
> bool deleteNoteNotesNoteIdDelete(noteId)

Delete Note

Delete a note by ID

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getNotesApi();
final int noteId = 56; // int | 

try {
    final response = api.deleteNoteNotesNoteIdDelete(noteId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling NotesApi->deleteNoteNotesNoteIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **noteId** | **int**|  | 

### Return type

**bool**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getNoteNotesNoteIdGet**
> NoteResponse getNoteNotesNoteIdGet(noteId)

Get Note

Get a specific note by ID

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getNotesApi();
final int noteId = 56; // int | 

try {
    final response = api.getNoteNotesNoteIdGet(noteId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling NotesApi->getNoteNotesNoteIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **noteId** | **int**|  | 

### Return type

[**NoteResponse**](NoteResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listRecentNotesNotesGet**
> NotesListResponse listRecentNotesNotesGet(limit, offset)

List Recent Notes

List recently updated notes sorted by update time (newest first)

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getNotesApi();
final int limit = 56; // int | Maximum number of notes to return
final int offset = 56; // int | Number of notes to skip

try {
    final response = api.listRecentNotesNotesGet(limit, offset);
    print(response);
} catch on DioException (e) {
    print('Exception when calling NotesApi->listRecentNotesNotesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Maximum number of notes to return | [optional] [default to 20]
 **offset** | **int**| Number of notes to skip | [optional] [default to 0]

### Return type

[**NotesListResponse**](NotesListResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchNotesNotesSearchGet**
> NotesListResponse searchNotesNotesSearchGet(q, limit, offset)

Search Notes

Search notes by title (fuzzy search)

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getNotesApi();
final String q = q_example; // String | Search query for note titles
final int limit = 56; // int | Maximum number of notes to return
final int offset = 56; // int | Number of notes to skip

try {
    final response = api.searchNotesNotesSearchGet(q, limit, offset);
    print(response);
} catch on DioException (e) {
    print('Exception when calling NotesApi->searchNotesNotesSearchGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**| Search query for note titles | 
 **limit** | **int**| Maximum number of notes to return | [optional] [default to 20]
 **offset** | **int**| Number of notes to skip | [optional] [default to 0]

### Return type

[**NotesListResponse**](NotesListResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateNoteNotesNoteIdPut**
> NoteResponse updateNoteNotesNoteIdPut(noteId, noteUpdate)

Update Note

Update an existing note

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getNotesApi();
final int noteId = 56; // int | 
final NoteUpdate noteUpdate = ; // NoteUpdate | 

try {
    final response = api.updateNoteNotesNoteIdPut(noteId, noteUpdate);
    print(response);
} catch on DioException (e) {
    print('Exception when calling NotesApi->updateNoteNotesNoteIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **noteId** | **int**|  | 
 **noteUpdate** | [**NoteUpdate**](NoteUpdate.md)|  | 

### Return type

[**NoteResponse**](NoteResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

