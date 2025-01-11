class RSFormField {
  final String id;
  final String label;
  final FieldType type;
  final dynamic defaultValue;
  final List<String>? options; // For dropdown

  RSFormField({
    required this.id,
    required this.label,
    required this.type,
    this.defaultValue,
    this.options,
  });
}

enum FieldType {
  text,
  number,
  checkbox,
  dropdown,
}
