// Openapi Generator last run: : 2025-01-11T20:04:20.825810
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