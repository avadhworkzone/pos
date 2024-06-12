import 'package:flutter_test/flutter_test.dart';

import 'package:jakel_base/utils/my_mobile_number_validation.dart';

void main() {
  test('Should return true', () {
    expect(true, isValidMobileNumber("601112145678"));
  });

  test('Should return true', () {
    expect(true, isValidMobileNumber("601116286079"));
  });

  test('Should return true', () {
    expect(true, isValidMobileNumber("60141234567"));
  });

  test('Should return true', () {
    expect(true, isValidMobileNumber("6561234567"));
  });

  test('Should return true', () {
    expect(true, isValidMobileNumber("6581234567"));
  });

  test('Should return true', () {
    expect(true, isValidMobileNumber("6591234567"));
  });

  test('Should return true', () {
    expect(true, isValidMobileNumber("60133919297"));
  });

  test('Should return true', () {
    expect(true, isValidMobileNumber("60101234567"));
  });

  test('Should return false', () {
    expect(false, isValidMobileNumber("60151234567"));
  });

  test('Should return true', () {
    expect(true, isValidMobileNumber("601126286079"));
  });
}
