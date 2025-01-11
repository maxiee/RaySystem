import 'package:flutter/material.dart';
import 'package:raysystem_flutter/form/form_dialog.dart';
import 'package:raysystem_flutter/form/form_field.dart';

class FormManager {
  static Future<Map<String, dynamic>?> showForm({
    required BuildContext context,
    required String title,
    required List<RSFormField> fields,
  }) async {
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => FormDialog(
        title: title,
        fields: fields,
      ),
    );
  }
}
