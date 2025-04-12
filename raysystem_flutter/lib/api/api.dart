// Openapi Generator last run: : 2025-04-12T14:20:38.999582
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

// 获取API Key，从环境变量获取
String? getApiKey() {
  return Platform.environment['RAY_SYSTEM_KEY'];
}

// 获取API基础URL，优先从环境变量获取，否则使用默认地址
String getBaseUrl() {
  return Platform.environment['RAYSYSTEM_API_BASE_URL'] ??
      'http://127.0.0.1:8000';
}

final api = generatedAPI.Openapi(
  basePathOverride: getBaseUrl(),
  dio: (() {
    final dio = generatedAPI.Openapi(
      basePathOverride: getBaseUrl(),
    ).dio;
    final apiKey = getApiKey();
    if (apiKey != null) {
      dio.options.headers['X-API-Key'] = apiKey;
    }
    return dio;
  })(),
).getDefaultApi();

final notesApi = generatedAPI.Openapi(
  basePathOverride: getBaseUrl(),
  dio: (() {
    final dio = generatedAPI.Openapi(
      basePathOverride: getBaseUrl(),
    ).dio;
    final apiKey = getApiKey();
    if (apiKey != null) {
      dio.options.headers['X-API-Key'] = apiKey;
    }
    return dio;
  })(),
).getNotesApi();

final notesTitleApi = generatedAPI.Openapi(
  basePathOverride: getBaseUrl(),
  dio: (() {
    final dio = generatedAPI.Openapi(
      basePathOverride: getBaseUrl(),
    ).dio;
    final apiKey = getApiKey();
    if (apiKey != null) {
      dio.options.headers['X-API-Key'] = apiKey;
    }
    return dio;
  })(),
).getNoteTitlesApi();

final llmApi = generatedAPI.Openapi(
  basePathOverride: getBaseUrl(),
  dio: (() {
    final dio = generatedAPI.Openapi(
      basePathOverride: getBaseUrl(),
    ).dio;
    final apiKey = getApiKey();
    if (apiKey != null) {
      dio.options.headers['X-API-Key'] = apiKey;
    }
    return dio;
  })(),
).getLLMApi();
