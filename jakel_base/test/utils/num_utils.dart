import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jakel_base/utils/my_date_utils.dart';
import 'package:jakel_base/utils/num_utils.dart';

void main() {
  test('Should return double value as 2.00', () {
    expect(2.00, getDoubleValue("2.000000"));
  });

  test('Should return double value as 1.96', () {
    expect(1.96, getDoubleValue(1.95555555555));
  });

  test('Should return double value as 37.91', () {
    expect(37.91, getDoubleValue(37.905));
  });
}
