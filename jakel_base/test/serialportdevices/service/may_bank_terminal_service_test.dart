import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jakel_base/serialportdevices/service/may_bank_terminal_service_impl.dart';

void main() {
  test('Should return MBB data not null', () {
    var data = MayBankTerminalServiceImpl()
        .getMayBankPaymentDataFromMbbResponse(Uint8List.fromList([
      2,
      2,
      82,
      50,
      48,
      48,
      52,
      50,
      56,
      51,
      51,
      50,
      88,
      88,
      88,
      88,
      88,
      88,
      53,
      56,
      56,
      48,
      32,
      32,
      32,
      88,
      88,
      88,
      88,
      48,
      48,
      49,
      54,
      48,
      57,
      48,
      49,
      49,
      54,
      48,
      57,
      48,
      49,
      50,
      50,
      49,
      50,
      50,
      57,
      48,
      48,
      48,
      48,
      56,
      49,
      48,
      48,
      48,
      48,
      48,
      49,
      48,
      51,
      57,
      57,
      57,
      57,
      57,
      57,
      57,
      57,
      48,
      48,
      48,
      48,
      50,
      55,
      48,
      48,
      57,
      48,
      48,
      50,
      53,
      49,
      48,
      65,
      48,
      48,
      48,
      48,
      48,
      48,
      54,
      49,
      53,
      48,
      48,
      48,
      49,
      55,
      66,
      55,
      56,
      67,
      52,
      66,
      70,
      51,
      49,
      56,
      50,
      68,
      56,
      53,
      57,
      32,
      32,
      32,
      32,
      32,
      32,
      32,
      32,
      32,
      32,
      32,
      32,
      32,
      32,
      32,
      32,
      32,
      32,
      32,
      32,
      32,
      32,
      32,
      32,
      32,
      32,
      48,
      56,
      3
    ]));
    expect(true, data != null);
  });
  //
  // test('Should return 000000003431', () {
  //   var data = MayBankTerminalServiceImpl().getAmountAsTwelveCharacters(34.31);
  //   expect("000000003431", data);
  // });
  //
  // test('Should return 000000003430', () {
  //   var data = MayBankTerminalServiceImpl().getAmountAsTwelveCharacters(34.3);
  //   expect("000000003430", data);
  // });
  //
  //
  // test('Should return 000000034300', () {
  //   var data = MayBankTerminalServiceImpl().getAmountAsTwelveCharacters(343.0);
  //   expect("000000034300", data);
  // });
  //
  // test('Should return 000000034355', () {
  //   var data = MayBankTerminalServiceImpl().getAmountAsTwelveCharacters(343.55);
  //   expect("000000034355", data);
  // });
  //
  // test('Should return 000000034350', () {
  //   var data = MayBankTerminalServiceImpl().getAmountAsTwelveCharacters(343.50);
  //   expect("000000034350", data);
  // });
}
