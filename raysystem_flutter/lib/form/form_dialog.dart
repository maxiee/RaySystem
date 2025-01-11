import 'package:flutter/material.dart';
import 'package:raysystem_flutter/form/form_field.dart';

class FormDialog extends StatefulWidget {
  final List<RSFormField> fields;
  final String title;

  const FormDialog({
    super.key,
    required this.fields,
    required this.title,
  });

  @override
  State<FormDialog> createState() => _FormDialogState();
}

class _FormDialogState extends State<FormDialog> {
  final Map<String, dynamic> _values = {};

  @override
  void initState() {
    super.initState();
    for (var field in widget.fields) {
      _values[field.id] = field.defaultValue;
    }
  }

  Widget _buildField(RSFormField field) {
    switch (field.type) {
      case FieldType.text:
        return TextFormField(
          decoration: InputDecoration(labelText: field.label),
          initialValue: field.defaultValue?.toString(),
          onChanged: (value) => _values[field.id] = value,
        );
      case FieldType.number:
        return TextFormField(
          decoration: InputDecoration(labelText: field.label),
          keyboardType: TextInputType.number,
          initialValue: field.defaultValue?.toString(),
          onChanged: (value) => _values[field.id] = num.tryParse(value),
        );
      case FieldType.checkbox:
        return CheckboxListTile(
          title: Text(field.label),
          value: _values[field.id] ?? false,
          onChanged: (value) => setState(() => _values[field.id] = value),
        );
      case FieldType.dropdown:
        return DropdownButtonFormField<String>(
          decoration: InputDecoration(labelText: field.label),
          value: _values[field.id],
          items: field.options
              ?.map((o) => DropdownMenuItem(
                    value: o,
                    child: Text(o),
                  ))
              .toList(),
          onChanged: (value) => setState(() => _values[field.id] = value),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.fields.map(_buildField).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_values),
          child: const Text('确定'),
        ),
      ],
    );
  }
}
