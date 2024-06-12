String getStringValue(dynamic value) {
  if (value != null) {
    if (value is int) {
      return '$value';
    } else if (value is double) {
      return '$value';
    } else if (value is bool) {
      return '$value';
    }
  }
  return '$value';
}
