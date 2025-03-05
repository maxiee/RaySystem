# openapi.model.ScheduledTaskResponse

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**taskType** | **String** |  | 
**scheduleType** | [**TaskScheduleType**](TaskScheduleType.md) |  | 
**interval** | **int** |  | 
**cronExpression** | **String** |  | [optional] 
**eventType** | **String** |  | [optional] 
**nextRun** | [**DateTime**](DateTime.md) |  | 
**tag** | **String** |  | 
**parameters** | [**JsonObject**](.md) |  | 
**enabled** | **bool** |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


