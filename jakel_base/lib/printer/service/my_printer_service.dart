import 'dart:collection';

import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsResponse.dart';
import 'package:jakel_base/restapi/bookingpayment/model/ResetBookingResponse.dart';
import 'package:jakel_base/restapi/cashmovement/model/CashMovementResponse.dart';
import 'package:jakel_base/restapi/sales/model/history/SaveSaleResponse.dart';
import 'package:printing/printing.dart';

import '../../restapi/counters/model/CloseCounterRequest.dart';
import '../../restapi/counters/model/GetCountersResponse.dart';
import '../../restapi/counters/model/ShiftDetailsResponse.dart';
import '../../restapi/counters/model/GetStoresResponse.dart';
import '../../restapi/customers/model/CustomersResponse.dart';
import '../../restapi/me/model/CurrentUserResponse.dart';
import '../../restapi/vouchers/model/VouchersListResponse.dart';

mixin MyPrinterService {
  void testManualPrint();

  void testAutoMaticPrint(Printer printer);

  Future<bool> salePrint(String? title, Sale sale, bool duplicateCopy, bool voidSale);

  Future<bool> bookingPaymentPrint(
      String? title, BookingPayments sale, bool duplicateCopy);

  Future<bool> resetBookingPaymentPrint(
      String? title, BookingPaymentProducts sale, bool duplicateCopy);

  Future<bool> cashMovementPrint(
      String? title, CashMovements sale, bool duplicateCopy);

  Future<bool> openCashDrawer();

  Future<bool> cashDeclarationReceipt(
      String? title,
      CounterClosingDetails counterClosingDetails,
      List<Denominations> denominations,
      HashMap<int, double>? paymentDeclaration);

  Future<bool> openCounterReceipt(String? title, Stores? store,
      Counters? counters, double openingBalance, bool duplicateCopy);

  Future<bool> printBirthdayVoucher(
      String? title, Customers customers, Vouchers vouchers);
}
