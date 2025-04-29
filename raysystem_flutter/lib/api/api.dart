// Openapi Generator last run: : 2025-04-29T23:00:47.522506
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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

/// 创建并配置一个 dio 实例，可选择性地设置自定义超时
///
/// [longTimeout] - 是否使用较长的超时时间，适用于 LLM API 等长时间运行的请求
Dio createConfiguredDio({bool longTimeout = false}) {
  final dio = generatedAPI.Openapi(
    basePathOverride: getBaseUrl(),
  ).dio;

  // 设置 API Key（如果存在）
  final apiKey = getApiKey();
  if (apiKey != null) {
    dio.options.headers['X-API-Key'] = apiKey;
  }

  // 如果需要，设置较长的超时时间
  if (longTimeout) {
    dio.options.connectTimeout = const Duration(milliseconds: 60000); // 60秒连接超时
    dio.options.receiveTimeout =
        const Duration(milliseconds: 240000); // 240秒接收超时
    dio.options.sendTimeout = const Duration(milliseconds: 60000); // 60秒发送超时
  }

  return dio;
}

final api = generatedAPI.Openapi(
  basePathOverride: getBaseUrl(),
  dio: createConfiguredDio(),
).getDefaultApi();

final notesApi = generatedAPI.Openapi(
  basePathOverride: getBaseUrl(),
  dio: createConfiguredDio(),
).getNotesApi();

final notesTitleApi = generatedAPI.Openapi(
  basePathOverride: getBaseUrl(),
  dio: createConfiguredDio(),
).getNoteTitlesApi();

final llmApi = generatedAPI.Openapi(
  basePathOverride: getBaseUrl(),
  dio: createConfiguredDio(longTimeout: true),
).getLLMApi();

/// SSE event types returned by the server
enum SSEEventType {
  start,
  data,
  complete,
  error,
}

/// Represents a parsed SSE event from the LLM streaming API
class SSEEvent {
  final SSEEventType type;
  final Map<String, dynamic>? data;
  final String? rawData;

  SSEEvent({
    required this.type,
    this.data,
    this.rawData,
  });

  /// Content from the message, if available
  String? get content => data?['content'] as String?;

  /// Whether the stream is complete
  bool get done => data?['done'] == true;

  /// Error message, if any
  String? get error => data?['error'] as String?;

  /// Model name, if provided (typically in completion event)
  String? get model => data?['model'] as String?;

  @override
  String toString() {
    return 'SSEEvent(type: $type, data: $data)';
  }
}

class LLMStreamClient {
  final Dio _dio;
  final String baseUrl;

  LLMStreamClient({required this.baseUrl}) : _dio = Dio() {
    // 设置基础URL和超时
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(milliseconds: 60000);
    _dio.options.receiveTimeout = const Duration(milliseconds: 240000);
    _dio.options.sendTimeout = const Duration(milliseconds: 60000);

    // 设置API密钥（如果存在）
    final apiKey = getApiKey();
    if (apiKey != null) {
      _dio.options.headers['X-API-Key'] = apiKey;
    }
  }

  /// 发送流式聊天请求并返回SSE事件流
  Future<Stream<SSEEvent>> streamChatCompletion({
    required generatedAPI.ChatCompletionRequest request,
    CancelToken? cancelToken,
  }) async {
    final options = Options(
      method: 'POST',
      headers: {
        'Accept': 'text/event-stream',
        'Content-Type': 'application/json',
      },
      responseType: ResponseType.stream,
    );

    try {
      // 将ChatCompletionRequest转换为普通Map (OpenAPI生成的类不能直接序列化)
      final requestMap = <String, dynamic>{
        'messages': request.messages
            .map((message) => {
                  'role': message.role,
                  'content': message.content,
                })
            .toList(),
      };

      // 添加可选的model_name参数
      if (request.modelName != null) {
        requestMap['model_name'] = request.modelName;
      }

      final response = await _dio.request<ResponseBody>(
        '/llm/chat_stream',
        data: requestMap,
        options: options,
        cancelToken: cancelToken,
      );

      // 创建原始行流（解决UTF8解码问题）
      final streamController = StreamController<String>();

      response.data!.stream.listen(
        (data) {
          // 使用UTF8解码器直接解码字节数据
          final text = utf8.decode(data);
          streamController.add(text);
        },
        onError: streamController.addError,
        onDone: streamController.close,
      );

      // 处理行分割
      final lineStream =
          streamController.stream.transform(const LineSplitter());

      // 解析SSE事件
      final eventController = StreamController<SSEEvent>();

      // 当前事件的缓冲数据
      var eventType = 'data';
      var eventData = '';

      // 处理流中的每一行
      lineStream.listen(
        (line) {
          if (line.isEmpty) {
            // 空行表示事件结束，处理当前事件
            if (eventData.isNotEmpty) {
              final event = _parseEvent(eventType, eventData);
              eventController.add(event);
            }
            // 重置事件数据
            eventType = 'data';
            eventData = '';
          } else if (line.startsWith('event:')) {
            // 事件类型行
            eventType = line.substring(6).trim();
          } else if (line.startsWith('data:')) {
            // 数据行
            eventData = line.substring(5).trim();
          }
        },
        onDone: () {
          // 处理最后一个事件（如果有）
          if (eventData.isNotEmpty) {
            final event = _parseEvent(eventType, eventData);
            eventController.add(event);
          }
          eventController.close();
        },
        onError: (error) {
          eventController.addError(error);
          eventController.close();
        },
      );

      return eventController.stream;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/llm/chat_stream'),
        error: 'Stream chat completion failed: $e',
      );
    }
  }

  /// 解析SSE事件
  SSEEvent _parseEvent(String eventType, String data) {
    final SSEEventType type;

    // 确定事件类型
    switch (eventType) {
      case 'start':
        type = SSEEventType.start;
        break;
      case 'complete':
        type = SSEEventType.complete;
        break;
      case 'error':
        type = SSEEventType.error;
        break;
      case 'data':
      default:
        type = SSEEventType.data;
    }

    // 解析JSON数据
    Map<String, dynamic>? jsonData;
    if (data.isNotEmpty) {
      try {
        jsonData = json.decode(data);
      } catch (e) {
        debugPrint('Error parsing event data: $e');
        // 返回原始数据，即使解析失败
      }
    }

    return SSEEvent(
      type: type,
      data: jsonData,
      rawData: data,
    );
  }

  /// 简化的API，只返回内容字符串流（向后兼容）
  Future<Stream<String>> streamContent({
    required generatedAPI.ChatCompletionRequest request,
    CancelToken? cancelToken,
  }) async {
    final sseStream = await streamChatCompletion(
      request: request,
      cancelToken: cancelToken,
    );

    // 过滤并映射事件为内容字符串
    final controller = StreamController<String>();

    sseStream.listen(
      (event) {
        // 处理内容事件
        if (event.type == SSEEventType.data && event.content != null) {
          controller.add(event.content!);
        }
        // 处理完成事件 - 完成事件中可能包含完整内容，导致重复，所以要避免
        else if (event.type == SSEEventType.complete) {
          // 流已完成，但不做额外处理，避免重复发送内容
        }
        // 处理错误事件
        else if (event.type == SSEEventType.error && event.error != null) {
          controller.addError(event.error!);
        }
      },
      onDone: () => controller.close(),
      onError: (error) {
        controller.addError(error);
        controller.close();
      },
    );

    return controller.stream;
  }
}

// 创建全局LLM流式API客户端实例
final llmStreamAPI = LLMStreamClient(baseUrl: getBaseUrl());