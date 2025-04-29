import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';
import 'package:raysystem_flutter/api/api.dart';

final notesApiProvider = Provider<NotesApi>((ref) => notesApi);
