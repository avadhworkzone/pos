import 'dart:collection';

import 'package:jakel_base/printer/service/my_printer_service.dart';
import 'package:jakel_base/printer/types/all_types_sale_print.dart';
import 'package:jakel_base/printer/types/cash_movement_in_out_print.dart';
import 'package:jakel_base/printer/types/new_booking_payment_print.dart';
import 'package:jakel_base/printer/types/open_cash_drawer_via_print_esc.dart';
import 'package:jakel_base/printer/types/open_counter_print.dart';
import 'package:jakel_base/printer/types/reset_booking_payment_print.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsResponse.dart';
import 'package:jakel_base/restapi/bookingpayment/model/ResetBookingResponse.dart';
import 'package:jakel_base/restapi/cashmovement/model/CashMovementResponse.dart';
import 'package:jakel_base/restapi/counters/model/CloseCounterRequest.dart';
import 'package:jakel_base/restapi/counters/model/ShiftDetailsResponse.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/restapi/sales/model/history/SaveSaleResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/VouchersListResponse.dart';
import 'package:printing/printing.dart';
import 'package:printing/src/printer.dart';

import '../../database/printer/PrinterLocalApi.dart';
import '../../database/printer/model/MyPrinter.dart';
import '../../locator.dart';
import '../../restapi/counters/model/GetCountersResponse.dart';
import '../../restapi/counters/model/GetStoresResponse.dart';
import '../../utils/MyLogUtils.dart';
import '../types/birthday_voucher_print.dart';
import '../types/cashier_declaration_receipt.dart';
import '../types/test_printing.dart';

class MyPrinterServiceImpl with MyPrinterService {
  @override
  Future<bool> salePrint(
      String? title, Sale sale, bool duplicateCopy, bool voidSale) async {
    return printSaleData(title, sale, duplicateCopy,voidSale);
  }

  @override
  Future<bool> bookingPaymentPrint(
      String? title, BookingPayments sale, bool duplicateCopy) {
    return printNewBookingPayment(title, sale, duplicateCopy);
  }

  @override
  Future<bool> resetBookingPaymentPrint(
      String? title, BookingPaymentProducts sale, bool duplicateCopy) {
    return printResetBookingPayment(title, sale, duplicateCopy);
  }

  @override
  Future<bool> cashMovementPrint(
      String? title, CashMovements cashMovement, bool duplicateCopy) {
    return printCashMovement(title, cashMovement, duplicateCopy);
  }

  @override
  void testAutoMaticPrint(Printer printer) {
    printPdfDirect(printer);
  }

  @override
  void testManualPrint() async {
    printPdf();
  }

  @override
  Future<bool> openCashDrawer() async {
    var localPrinter = locator.get<PrinterLocalApi>();
    MyPrinter? printer = await localPrinter.getMyPrinter();

    MyLogUtils.logDebug("openCashDrawer printer : ${printer?.toJson()}");

    if (printer != null) {
      return openCashDrawerViaPrinter(printer.name);
    }

    return false;
  }

  @override
  Future<bool> cashDeclarationReceipt(
      String? title,
      CounterClosingDetails counterClosingDetails,
      List<Denominations> denominations,
      HashMap<int, double>? paymentDeclaration) {
    return printCashDeclarationReceipt(
        title, counterClosingDetails, denominations, paymentDeclaration);
  }

  @override
  Future<bool> openCounterReceipt(String? title, Stores? store,
      Counters? counters, double openingBalance, bool duplicateCopy) {
    return printOpenCounter(
        title, store, counters, openingBalance, duplicateCopy);
  }

  @override
  Future<bool> printBirthdayVoucher(
      String? title, Customers customers, Vouchers vouchers) {
    return birthdayVoucherPrint(title, customers, vouchers);
  }
}
