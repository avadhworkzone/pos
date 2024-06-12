import 'dart:math';

import '../restapi/me/model/CurrentUserResponse.dart';

// For now rounding is done for 2 decimal places even for calculations
const maxDecimalPlaces = 2;

double getDoubleValue(dynamic value) {
  return getRoundedValueForCalculations(value);
  // if (value != null) {
  //   if (value is int) {
  //     return value + 0.0;
  //   } else if (value is double) {
  //     return value;
  //   } else if (value is String) {
  //     return double.parse(value);
  //   }
  // }
  // return 0.0;
}

bool getValueCheck(String value) {
  if (value.isNotEmpty) {
    String getValue = value[value.length - 1];
    if (getValue == "." && value.length > 1) {
      return true;
    }
    int intValue = getValue.codeUnitAt(0);
    if (intValue < 58 && intValue > 47) {
      return true;
    }
    return false;
  }
  return true;
}

int getInValue(dynamic value) {
  if (value != null) {
    if (value is int) {
      return value;
    } else if (value is double) {
      return value.toInt();
    } else if (value is String) {
      if (value.contains(".")) {
        return double.parse(value).toInt();
      }
      return int.parse(value);
    }
  }
  return 0;
}

bool getBoolValue(dynamic value) {
  if (value != null) {
    if (value is int) {
      return value == 1;
    } else if (value is double) {
      return value > 0;
    } else if (value is bool) {
      return value;
    } else if (value is String) {
      return value == "true";
    }
  }
  return false;
}

double getRoundedDoubleValue(dynamic value) {
  if (value != null) {
    value = convert3DigitDecimalTo4DigitDecimal(value);
    if (value is int) {
      return value + 0.0;
    } else if (value is double) {
      return getDoubleValue(value.toStringAsFixed(2));
    } else if (value is String) {
      return double.parse(value);
    }
  }
  return 0.0;
}

// Ex: 50.915 -> Backend expectation is 50.92
// But rounding of 50.915 in flutter will give as 50.91.
// To overcome this, add an extra 1 in the last field as 50.915 -> 50.9151
// Flutter will convert this into 50.92 in rounding.
dynamic convert3DigitDecimalTo4DigitDecimal(dynamic value) {
  if (value is double) {
    String newValue = '$value';

    if (newValue.contains(".")) {
      List values = newValue.split(".");
      if (values.length > 1 && '${values.last}'.length == 3) {
        newValue = '${value}1';
      }
    }
    return double.parse(newValue);
  }
  return value;
}

bool isNumeric(String? value) {
  if (value == null) {
    return false;
  }
  try {
    double.parse(value);
    return true;
  } catch (e) {
    return false;
  }
}

/// If decimal number is 0 after dot, it will display only the first value before .
/// 1.0 => 1, 1.2=>1.2
String getStringWithNoDecimal(dynamic value) {
  double doubleValue = getDoubleValue(value);
  var splitValues = '$doubleValue'.split(".");

  if (splitValues.length > 1) {
    double decimalValue = getDoubleValue(splitValues[1]);
    if (decimalValue <= 0) {
      return splitValues[0];
    }
  }

  return '$doubleValue';
}

/// If decimal number is 0 after dot, it will display only the first value before .
/// 1.0 => 1, 1.2=>1.2
String getStringWithTwoDecimal(dynamic value) {
  double doubleValue = getDoubleValue(value);

  if (!'$doubleValue'.contains(".")) {
    return '$value.00';
  }
  var splitValues = '$doubleValue'.split(".");

  if (splitValues.length > 1) {
    String decimalValue = splitValues[1];
    if (decimalValue.length == 1) {
      return '${value}0';
    }
    if (decimalValue.length == 2) {
      return '$value';
    }
  }

  return '$doubleValue';
}

String getReadableAmount(String currency, dynamic amount) {
  String readableAmount = getOnlyReadableAmount(amount);
  if (readableAmount == "-0.00") {
    return "$currency 0.00";
  }
  return "$currency ${getOnlyReadableAmount(amount)}";
}

String getPercentageAmount(dynamic amount) {
  return "%  ${getOnlyReadableAmount(amount)}";
}

String getOnlyReadableAmount(dynamic amount) {
  double doubleAmount = 0.0;
  if (amount == null) {
    return doubleAmount.toStringAsFixed(2);
  }
  if (amount is int) {
    doubleAmount = double.parse("$amount");
  } else if (amount is String) {
    return amount;
  } else {
    doubleAmount = amount;
  }
  if (doubleAmount.toStringAsFixed(2) == "-0.00") {
    return "0.00";
  }
  return doubleAmount.toStringAsFixed(2);
}

double customRound(number, place) {
  var valueForPlace = pow(10, place);
  return (number * valueForPlace).round() / valueForPlace;
}

double roundToNearestPossible(double value) {
  List<RoundOffConfiguration> configs = List.empty(growable: true);
  configs.add(RoundOffConfiguration(decimalPlace: ".01", value: '-0.01'));
  configs.add(RoundOffConfiguration(decimalPlace: ".02", value: '-0.02'));
  configs.add(RoundOffConfiguration(decimalPlace: ".03", value: '0.02'));
  configs.add(RoundOffConfiguration(decimalPlace: ".04", value: '0.01'));
  configs.add(RoundOffConfiguration(decimalPlace: ".05", value: '0.00'));
  configs.add(RoundOffConfiguration(decimalPlace: ".06", value: '-0.01'));
  configs.add(RoundOffConfiguration(decimalPlace: ".07", value: '-0.02'));
  configs.add(RoundOffConfiguration(decimalPlace: ".08", value: '0.02'));
  configs.add(RoundOffConfiguration(decimalPlace: ".09", value: '0.01'));
  configs.add(RoundOffConfiguration(decimalPlace: ".00", value: '0.00'));

  double roundOffValue = 0.0;
  String totalAmount = '${getRoundedDoubleValue(value)}';
  if (totalAmount.contains(".")) {
    List<String> values = totalAmount.split(".");
    String decimalValue = values[1];
    String? lastCharacter = decimalValue.substring(1);

    if (lastCharacter.isNotEmpty) {
      lastCharacter = ".0$lastCharacter";

      for (var element in configs) {
        if (element.decimalPlace == lastCharacter) {
          roundOffValue = getDoubleValue(element.value);
        }
      }
    }
  }

  return value + roundOffValue;
}

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
