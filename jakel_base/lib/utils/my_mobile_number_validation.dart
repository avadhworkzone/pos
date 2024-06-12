bool isValidMobileNumber(String value) {
  String pattern =
      r'^(601((1[0-9]{8})|([02-46-9]{1}[0-9]{7})))|(65[689]\d{7})$';
  RegExp regExp = RegExp(pattern);

  return regExp.hasMatch(value);
}
