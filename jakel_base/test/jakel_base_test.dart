import 'package:flutter_test/flutter_test.dart';

void main() {
  test('adds one to input values', () {
    print("value of 100/3 = ${100 / 3}");
    print("value of 33.333333333333336*3 = ${33.333333333333336 * 3}");
    print("value of 33.33333333333333*3 = ${33.33333333333333 * 3}");
    print("value of 33.333333333333*3 = ${33.333333333333 * 3}");
    print("value of 33.3333333333*3 = ${33.3333333333 * 3}");
    print("value of 33.33333333*3 = ${33.33333333 * 3}");
    print("------------------------------------------");
    print("value of 99.5/3 =  ${99.5 / 3}");
    print("value of 33.166666666666664*3 =  ${33.166666666666664 * 3}");
    print("value of 33.16666666666*3 = ${33.16666666666 * 3}");
    print("value of 33.16666666*3 = ${33.16666666 * 3}");
    print("value of 33.1666666*3 = ${33.1666666 * 3}");
    print("value of 33.1666*3 = ${33.1666 * 3}");
    print("------------------------------------------");
    print("value of 99.25/3 =  ${99.25 / 3}");
    print("value of 33.083333333333336*3 =  ${33.083333333333336 * 3}");
    print("------------------------------------------");
    expect(100, 33.333333333333336 * 3);
  });
}
