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
[**getChildNotesNotesTreeChildrenGet**](NotesApi.md#getchildnotesnotestreechildrenget) | **GET** /notes/tree/children | Get Child Notes
[**getNoteNotesNoteIdGet**](NotesApi.md#getnotenotesnoteidget) | **GET** /notes/{note_id} | Get Note
[**getNotePathNotesNoteIdPathGet**](NotesApi.md#getnotepathnotesnoteidpathget) | **GET** /notes/{note_id}/path | Get Note Path
[**listRecentNotesNotesGet**](NotesApi.md#listrecentnotesnotesget) | **GET** /notes/ | List Recent Notes
[**moveNoteNotesNoteIdMovePost**](NotesApi.md#movenotenotesnoteidmovepost) | **POST** /notes/{note_id}/move | Move Note
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

# **getChildNotesNotesTreeChildrenGet**
> NoteTreeResponse getChildNotesNotesTreeChildrenGet(parentId, limit, offset)

Get Child Notes

Get child notes for a given parent_id. If parent_id is None, returns root-level notes (notes without a parent). If parent_id is 0, it's treated as None (for easier frontend handling).

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getNotesApi();
final int parentId = 56; // int | Parent note ID, if None returns root notes
final int limit = 56; // int | Maximum number of notes to return
final int offset = 56; // int | Number of notes to skip

try {
    final response = api.getChildNotesNotesTreeChildrenGet(parentId, limit, offset);
    print(response);
} catch on DioException (e) {
    print('Exception when calling NotesApi->getChildNotesNotesTreeChildrenGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **parentId** | **int**| Parent note ID, if None returns root notes | [optional] 
 **limit** | **int**| Maximum number of notes to return | [optional] [default to 50]
 **offset** | **int**| Number of notes to skip | [optional] [default to 0]

### Return type

[**NoteTreeResponse**](NoteTreeResponse.md)

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

# **getNotePathNotesNoteIdPathGet**
> BuiltList<NoteResponse> getNotePathNotesNoteIdPathGet(noteId)

Get Note Path

Get the path from root to the specified note (breadcrumbs)

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getNotesApi();
final int noteId = 56; // int | 

try {
    final response = api.getNotePathNotesNoteIdPathGet(noteId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling NotesApi->getNotePathNotesNoteIdPathGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **noteId** | **int**|  | 

### Return type

[**BuiltList&lt;NoteResponse&gt;**](NoteResponse.md)

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

# **moveNoteNotesNoteIdMovePost**
> NoteResponse moveNoteNotesNoteIdMovePost(noteId, newParentId)

Move Note

Move a note to a new parent. If new_parent_id is None, the note becomes a root note.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getNotesApi();
final int noteId = 56; // int | 
final int newParentId = 56; // int | New parent ID, None for root level

try {
    final response = api.moveNoteNotesNoteIdMovePost(noteId, newParentId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling NotesApi->moveNoteNotesNoteIdMovePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **noteId** | **int**|  | 
 **newParentId** | **int**| New parent ID, None for root level | [optional] 

### Return type

[**NoteResponse**](NoteResponse.md)

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

