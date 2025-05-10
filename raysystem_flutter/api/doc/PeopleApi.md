# openapi.api.PeopleApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createPeopleNamePeoplePeopleIdNamesPost**](PeopleApi.md#createpeoplenamepeoplepeopleidnamespost) | **POST** /people/{people_id}/names | Create People Name
[**createPeoplePeoplePost**](PeopleApi.md#createpeoplepeoplepost) | **POST** /people/ | Create People
[**deletePeopleNamePeopleNamesNameIdDelete**](PeopleApi.md#deletepeoplenamepeoplenamesnameiddelete) | **DELETE** /people/names/{name_id} | Delete People Name
[**deletePeoplePeoplePeopleIdDelete**](PeopleApi.md#deletepeoplepeoplepeopleiddelete) | **DELETE** /people/{people_id} | Delete People
[**getPeopleNamesPeoplePeopleIdNamesGet**](PeopleApi.md#getpeoplenamespeoplepeopleidnamesget) | **GET** /people/{people_id}/names | Get People Names
[**getPeoplePeoplePeopleIdGet**](PeopleApi.md#getpeoplepeoplepeopleidget) | **GET** /people/{people_id} | Get People
[**searchPeoplePeopleSearchGet**](PeopleApi.md#searchpeoplepeoplesearchget) | **GET** /people/search | Search People
[**updatePeopleNamePeopleNamesNameIdPut**](PeopleApi.md#updatepeoplenamepeoplenamesnameidput) | **PUT** /people/names/{name_id} | Update People Name
[**updatePeoplePeoplePeopleIdPut**](PeopleApi.md#updatepeoplepeoplepeopleidput) | **PUT** /people/{people_id} | Update People


# **createPeopleNamePeoplePeopleIdNamesPost**
> PeopleNameResponse createPeopleNamePeoplePeopleIdNamesPost(peopleId, peopleNameCreate)

Create People Name

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getPeopleApi();
final int peopleId = 56; // int | 
final PeopleNameCreate peopleNameCreate = ; // PeopleNameCreate | 

try {
    final response = api.createPeopleNamePeoplePeopleIdNamesPost(peopleId, peopleNameCreate);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PeopleApi->createPeopleNamePeoplePeopleIdNamesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **peopleId** | **int**|  | 
 **peopleNameCreate** | [**PeopleNameCreate**](PeopleNameCreate.md)|  | 

### Return type

[**PeopleNameResponse**](PeopleNameResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createPeoplePeoplePost**
> PeopleResponse createPeoplePeoplePost(peopleCreate)

Create People

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getPeopleApi();
final PeopleCreate peopleCreate = ; // PeopleCreate | 

try {
    final response = api.createPeoplePeoplePost(peopleCreate);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PeopleApi->createPeoplePeoplePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **peopleCreate** | [**PeopleCreate**](PeopleCreate.md)|  | 

### Return type

[**PeopleResponse**](PeopleResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deletePeopleNamePeopleNamesNameIdDelete**
> bool deletePeopleNamePeopleNamesNameIdDelete(nameId)

Delete People Name

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getPeopleApi();
final int nameId = 56; // int | 

try {
    final response = api.deletePeopleNamePeopleNamesNameIdDelete(nameId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PeopleApi->deletePeopleNamePeopleNamesNameIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **nameId** | **int**|  | 

### Return type

**bool**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deletePeoplePeoplePeopleIdDelete**
> bool deletePeoplePeoplePeopleIdDelete(peopleId)

Delete People

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getPeopleApi();
final int peopleId = 56; // int | 

try {
    final response = api.deletePeoplePeoplePeopleIdDelete(peopleId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PeopleApi->deletePeoplePeoplePeopleIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **peopleId** | **int**|  | 

### Return type

**bool**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPeopleNamesPeoplePeopleIdNamesGet**
> BuiltList<PeopleNameResponse> getPeopleNamesPeoplePeopleIdNamesGet(peopleId)

Get People Names

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getPeopleApi();
final int peopleId = 56; // int | 

try {
    final response = api.getPeopleNamesPeoplePeopleIdNamesGet(peopleId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PeopleApi->getPeopleNamesPeoplePeopleIdNamesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **peopleId** | **int**|  | 

### Return type

[**BuiltList&lt;PeopleNameResponse&gt;**](PeopleNameResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPeoplePeoplePeopleIdGet**
> PeopleResponse getPeoplePeoplePeopleIdGet(peopleId)

Get People

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getPeopleApi();
final int peopleId = 56; // int | 

try {
    final response = api.getPeoplePeoplePeopleIdGet(peopleId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PeopleApi->getPeoplePeoplePeopleIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **peopleId** | **int**|  | 

### Return type

[**PeopleResponse**](PeopleResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchPeoplePeopleSearchGet**
> BuiltList<PeopleResponse> searchPeoplePeopleSearchGet(name)

Search People

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getPeopleApi();
final String name = name_example; // String | 

try {
    final response = api.searchPeoplePeopleSearchGet(name);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PeopleApi->searchPeoplePeopleSearchGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **name** | **String**|  | 

### Return type

[**BuiltList&lt;PeopleResponse&gt;**](PeopleResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updatePeopleNamePeopleNamesNameIdPut**
> PeopleNameResponse updatePeopleNamePeopleNamesNameIdPut(nameId, peopleNameCreate)

Update People Name

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getPeopleApi();
final int nameId = 56; // int | 
final PeopleNameCreate peopleNameCreate = ; // PeopleNameCreate | 

try {
    final response = api.updatePeopleNamePeopleNamesNameIdPut(nameId, peopleNameCreate);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PeopleApi->updatePeopleNamePeopleNamesNameIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **nameId** | **int**|  | 
 **peopleNameCreate** | [**PeopleNameCreate**](PeopleNameCreate.md)|  | 

### Return type

[**PeopleNameResponse**](PeopleNameResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updatePeoplePeoplePeopleIdPut**
> PeopleResponse updatePeoplePeoplePeopleIdPut(peopleId, peopleUpdate)

Update People

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getPeopleApi();
final int peopleId = 56; // int | 
final PeopleUpdate peopleUpdate = ; // PeopleUpdate | 

try {
    final response = api.updatePeoplePeoplePeopleIdPut(peopleId, peopleUpdate);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PeopleApi->updatePeoplePeoplePeopleIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **peopleId** | **int**|  | 
 **peopleUpdate** | [**PeopleUpdate**](PeopleUpdate.md)|  | 

### Return type

[**PeopleResponse**](PeopleResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

