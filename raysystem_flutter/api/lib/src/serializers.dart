//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:openapi/src/date_serializer.dart';
import 'package:openapi/src/model/date.dart';

import 'package:openapi/src/model/chat_completion_request.dart';
import 'package:openapi/src/model/chat_completion_response.dart';
import 'package:openapi/src/model/chat_message_input.dart';
import 'package:openapi/src/model/chat_message_output.dart';
import 'package:openapi/src/model/chat_session_create.dart';
import 'package:openapi/src/model/chat_session_response.dart';
import 'package:openapi/src/model/chat_session_update.dart';
import 'package:openapi/src/model/chat_sessions_list_response.dart';
import 'package:openapi/src/model/disk_metrics.dart';
import 'package:openapi/src/model/http_validation_error.dart';
import 'package:openapi/src/model/info_list.dart';
import 'package:openapi/src/model/info_response.dart';
import 'package:openapi/src/model/info_stats.dart';
import 'package:openapi/src/model/list_models_response.dart';
import 'package:openapi/src/model/memory_metrics.dart';
import 'package:openapi/src/model/model_info.dart';
import 'package:openapi/src/model/network_metrics.dart';
import 'package:openapi/src/model/note_create.dart';
import 'package:openapi/src/model/note_response.dart';
import 'package:openapi/src/model/note_title_create.dart';
import 'package:openapi/src/model/note_title_response.dart';
import 'package:openapi/src/model/note_title_update.dart';
import 'package:openapi/src/model/note_tree_response.dart';
import 'package:openapi/src/model/note_update.dart';
import 'package:openapi/src/model/notes_list_response.dart';
import 'package:openapi/src/model/people_create.dart';
import 'package:openapi/src/model/people_list_response.dart';
import 'package:openapi/src/model/people_name_create.dart';
import 'package:openapi/src/model/people_name_response.dart';
import 'package:openapi/src/model/people_response.dart';
import 'package:openapi/src/model/people_update.dart';
import 'package:openapi/src/model/response_get_metrics_system_metrics_get.dart';
import 'package:openapi/src/model/scheduled_task_response.dart';
import 'package:openapi/src/model/site.dart';
import 'package:openapi/src/model/site_create.dart';
import 'package:openapi/src/model/system_metrics.dart';
import 'package:openapi/src/model/task_schedule_type.dart';
import 'package:openapi/src/model/validation_error.dart';
import 'package:openapi/src/model/validation_error_loc_inner.dart';

part 'serializers.g.dart';

@SerializersFor([
  ChatCompletionRequest,
  ChatCompletionResponse,
  ChatMessageInput,
  ChatMessageOutput,
  ChatSessionCreate,
  ChatSessionResponse,
  ChatSessionUpdate,
  ChatSessionsListResponse,
  DiskMetrics,
  HTTPValidationError,
  InfoList,
  InfoResponse,
  InfoStats,
  ListModelsResponse,
  MemoryMetrics,
  ModelInfo,
  NetworkMetrics,
  NoteCreate,
  NoteResponse,
  NoteTitleCreate,
  NoteTitleResponse,
  NoteTitleUpdate,
  NoteTreeResponse,
  NoteUpdate,
  NotesListResponse,
  PeopleCreate,
  PeopleListResponse,
  PeopleNameCreate,
  PeopleNameResponse,
  PeopleResponse,
  PeopleUpdate,
  ResponseGetMetricsSystemMetricsGet,
  ScheduledTaskResponse,
  Site,
  SiteCreate,
  SystemMetrics,
  TaskScheduleType,
  ValidationError,
  ValidationErrorLocInner,
])
Serializers serializers = (_$serializers.toBuilder()
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(NoteTitleResponse)]),
        () => ListBuilder<NoteTitleResponse>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(NoteResponse)]),
        () => ListBuilder<NoteResponse>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(PeopleNameResponse)]),
        () => ListBuilder<PeopleNameResponse>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Site)]),
        () => ListBuilder<Site>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(PeopleResponse)]),
        () => ListBuilder<PeopleResponse>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(ScheduledTaskResponse)]),
        () => ListBuilder<ScheduledTaskResponse>(),
      )
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer()))
    .build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
