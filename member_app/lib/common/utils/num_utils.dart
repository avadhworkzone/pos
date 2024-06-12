import 'dart:math';


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
  if(readableAmount=="-0.00"){
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

double customRound(dynamic value) {
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
  var valueForPlace = pow(10, 2);
  return (finalValue * valueForPlace).round() / valueForPlace;
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
