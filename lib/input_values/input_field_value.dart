class InputFieldValue {
  final String value;
  final InputFieldStatusEnum status;

  InputFieldValue({
    required this.value,
    required this.status,
  });
}

enum InputFieldStatusEnum {
  updated,
  initial,
  matched,
  notMatched,
}
