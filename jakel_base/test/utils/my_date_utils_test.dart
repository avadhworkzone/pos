import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jakel_base/utils/my_date_utils.dart';

void main() {
  var today = DateTime.now();

  test('Should return checkIsValidTime as true', () {
    expect(
        true,
        checkIsValidTime(
            DateFormat('yyyy-MM-dd').format(today), "03:03:00", "12:30:00"));
  });

  test('Should return checkIsValidTime as true', () {
    expect(
        true,
        checkIsValidTime(
            DateFormat('yyyy-MM-dd').format(today), "03:03:00", "14:30:00"));
  });

  test('Should return checkIsValidTime as true', () {
    expect(
        true,
        checkIsValidTime(
            DateFormat('yyyy-MM-dd').format(today), null, "14:30:00"));
  });

  test('Should return checkIsValidTime as true', () {
    expect(
        true,
        checkIsValidTime(
            DateFormat('yyyy-MM-dd').format(today), "03:03:00", null));
  });

  test('Should return checkIsValidTime as false', () {
    expect(
        false,
        checkIsValidTime(
            DateFormat('yyyy-MM-dd').format(today.add(Duration(days: 1))),
            "03:03:00",
            "14:30:00"));
  });

  test('Should return checkIsValidTime as false', () {
    expect(
        false,
        checkIsValidTime(
            DateFormat('yyyy-MM-dd').format(today),
        "11:03:00",
        "14:30:00")
    );
  });
}
