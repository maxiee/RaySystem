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
[**getInfosInfosGet**](DefaultApi.md#getinfosinfosget) | **GET** /infos/ | Get Infos
[**getMetricsSystemMetricsGet**](DefaultApi.md#getmetricssystemmetricsget) | **GET** /system/metrics | Get Metrics
[**heeloWorldHelloGet**](DefaultApi.md#heeloworldhelloget) | **GET** /hello | Heelo World
[**readSiteSitesSiteIdGet**](DefaultApi.md#readsitesitessiteidget) | **GET** /sites/{site_id} | Read Site
[**readSitesSitesGet**](DefaultApi.md#readsitessitesget) | **GET** /sites/ | Read Sites
[**recognizeTextOcrRecognizePost**](DefaultApi.md#recognizetextocrrecognizepost) | **POST** /ocr/recognize | Recognize Text
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

# **getInfosInfosGet**
> InfoList getInfosInfosGet(createdBefore, limit)

Get Infos

Get a paginated list of info items.  Args:     created_before: Optional timestamp to get items created before this time     limit: Number of items to return (max 100)     session: Database session  Returns:     InfoList containing the items, total count, and whether there are more items

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();
final DateTime createdBefore = 2013-10-20T19:20:30+01:00; // DateTime | Optional timestamp to get items created before this time
final int limit = 56; // int | Number of items to return per page

try {
    final response = api.getInfosInfosGet(createdBefore, limit);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->getInfosInfosGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createdBefore** | **DateTime**| Optional timestamp to get items created before this time | [optional] 
 **limit** | **int**| Number of items to return per page | [optional] [default to 20]

### Return type

[**InfoList**](InfoList.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMetricsSystemMetricsGet**
> ResponseGetMetricsSystemMetricsGet getMetricsSystemMetricsGet()

Get Metrics

Get current system metrics including: - CPU usage - Memory usage (including swap) - Disk usage and IO speeds - Network speeds  :return: SystemMetrics object containing all system metrics

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();

try {
    final response = api.getMetricsSystemMetricsGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->getMetricsSystemMetricsGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ResponseGetMetricsSystemMetricsGet**](ResponseGetMetricsSystemMetricsGet.md)

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

# **recognizeTextOcrRecognizePost**
> JsonObject recognizeTextOcrRecognizePost(file)

Recognize Text

接收图片文件并进行 OCR 文字识别  :param file: 上传的图片文件 :return: 识别出的文字内容

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();
final MultipartFile file = BINARY_DATA_HERE; // MultipartFile | 

try {
    final response = api.recognizeTextOcrRecognizePost(file);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->recognizeTextOcrRecognizePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **file** | **MultipartFile**|  | 

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: multipart/form-data
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

