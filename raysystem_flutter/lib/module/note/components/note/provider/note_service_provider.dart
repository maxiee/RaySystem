import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raysystem_flutter/module/note/api/note/api_note_service.dart';

final noteServiceProvider = Provider<ApiNoteService>((ref) => ApiNoteService());
