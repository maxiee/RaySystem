// Openapi Generator last run: : 2025-02-22T23:51:06.113292
import 'package:openapi_generator_annotations/openapi_generator_annotations.dart';
import 'package:openapi/openapi.dart' as generatedAPI;

@Openapi(
    inputSpec: RemoteSpec(path: 'http://127.0.0.1:8000/openapi.json'),
    generatorName: Generator.dio,
    outputDirectory: 'api',
    forceAlwaysRun: true,
    skipIfSpecIsUnchanged: false)
class API {}

final api = generatedAPI.Openapi(
  basePathOverride: 'http://127.0.0.1:8000',
).getDefaultApi();