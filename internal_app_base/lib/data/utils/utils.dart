

const maxDecimalPlaces = 2;

double getRoundedValueForCalculations(dynamic value) {
  double finalValue = 0.0;
  if (value != null) {
    if (value is int) {
      finalValue = value + 0.0;
    } else if (value is double) {
      finalValue = value;
    } else if (value is String) {
      finalValue = double.parse(value);
    }
  }
  return double.parse(finalValue.toStringAsFixed(maxDecimalPlaces));
}