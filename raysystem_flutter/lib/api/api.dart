// Openapi Generator last run: : 2025-03-22T00:07:54.078903
import 'dart:io';
import 'package:openapi_generator_annotations/openapi_generator_annotations.dart';
import 'package:openapi/openapi.dart' as generatedAPI;

@Openapi(
    inputSpec: RemoteSpec(path: 'http://127.0.0.1:8000/openapi.json'),
    generatorName: Generator.dio,
    outputDirectory: 'api',
    forceAlwaysRun: true,
    skipIfSpecIsUnchanged: false)
class API {}

// 获取API基础URL，优先从环境变量获取，否则使用默认地址
String getBaseUrl() {
  return Platform.environment['RAYSYSTEM_API_BASE_URL'] ??
      'http://127.0.0.1:8000';
}

final api = generatedAPI.Openapi(
  basePathOverride: getBaseUrl(),
).getDefaultApi();

final notesApi = generatedAPI.Openapi(
  basePathOverride: getBaseUrl(),
).getNotesApi();