# openapi.api.DefaultApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createSiteSitesPost**](DefaultApi.md#createsitesitespost) | **POST** /sites/ | Create Site
[**deleteSiteSitesSiteIdDelete**](DefaultApi.md#deletesitesitessiteiddelete) | **DELETE** /sites/{site_id} | Delete Site
[**heeloWorldHelloGet**](DefaultApi.md#heeloworldhelloget) | **GET** /hello | Heelo World
[**readSiteSitesSiteIdGet**](DefaultApi.md#readsitesitessiteidget) | **GET** /sites/{site_id} | Read Site
[**readSitesSitesGet**](DefaultApi.md#readsitessitesget) | **GET** /sites/ | Read Sites
[**rootGet**](DefaultApi.md#rootget) | **GET** / | Root


# **createSiteSitesPost**
> Site createSiteSitesPost(siteCreate)

Create Site

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();
final SiteCreate siteCreate = ; // SiteCreate | 

try {
    final response = api.createSiteSitesPost(siteCreate);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->createSiteSitesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **siteCreate** | [**SiteCreate**](SiteCreate.md)|  | 

### Return type

[**Site**](Site.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteSiteSitesSiteIdDelete**
> JsonObject deleteSiteSitesSiteIdDelete(siteId)

Delete Site

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();
final int siteId = 56; // int | 

try {
    final response = api.deleteSiteSitesSiteIdDelete(siteId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->deleteSiteSitesSiteIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **siteId** | **int**|  | 

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **heeloWorldHelloGet**
> JsonObject heeloWorldHelloGet()

Heelo World

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();

try {
    final response = api.heeloWorldHelloGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->heeloWorldHelloGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **readSiteSitesSiteIdGet**
> Site readSiteSitesSiteIdGet(siteId)

Read Site

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();
final int siteId = 56; // int | 

try {
    final response = api.readSiteSitesSiteIdGet(siteId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->readSiteSitesSiteIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **siteId** | **int**|  | 

### Return type

[**Site**](Site.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **readSitesSitesGet**
> BuiltList<Site> readSitesSitesGet(skip, limit)

Read Sites

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();
final int skip = 56; // int | 
final int limit = 56; // int | 

try {
    final response = api.readSitesSitesGet(skip, limit);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->readSitesSitesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **skip** | **int**|  | [optional] [default to 0]
 **limit** | **int**|  | [optional] [default to 100]

### Return type

[**BuiltList&lt;Site&gt;**](Site.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **rootGet**
> JsonObject rootGet()

Root

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();

try {
    final response = api.rootGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->rootGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

