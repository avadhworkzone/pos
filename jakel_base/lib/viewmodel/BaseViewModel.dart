import 'dart:convert';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:jakel_base/database/companyconfig/CompanyConfigLocalApi.dart';
import 'package:jakel_base/database/holdsaletypes/HoldSaleTypesLocalApi.dart';
import 'package:jakel_base/database/offlinedata/OfflineCloseCounterDataApi.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsResponse.dart';
import 'package:jakel_base/restapi/cashmovement/model/CashMovementResponse.dart';
import 'package:jakel_base/restapi/companyconfiguration/model/CompanyConfigurationResponse.dart';
import 'package:jakel_base/restapi/sales/model/HoldSaleTypesResponse.dart';
import 'package:jakel_base/serialportdevices/service/display_device_service.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:rxdart/rxdart.dart';

import '../database/counter/CounterLocalApi.dart';
import '../database/offlinedata/OfflineOpenCounterDataApi.dart';
import '../database/user/UserLocalApi.dart';
import '../locator.dart';
import '../printer/service/my_printer_service.dart';
import '../restapi/counters/model/GetCountersResponse.dart';
import '../restapi/counters/model/GetStoresResponse.dart';
import '../restapi/customers/model/CustomersResponse.dart';
import '../restapi/me/model/CurrentUserResponse.dart';
import '../restapi/vouchers/model/VouchersListResponse.dart';
import '../utils/my_unique_id.dart';

const int cashPaymentId = 1;
const int creditNotePaymentId = 2;
const int bookingPaymentId = 3;
const int loyaltyPointPaymentId = 4;
const int giftCardPaymentId = 5;

// 20 CHARACTERS OF 2 LINES
const int maxCharactersAcceptedByDisplayDevice = 40;

final cashInTypeId = 1;
final cashOutTypeId = 2;

class BaseViewModel {

  static double getAmountChangeDue = 0.00;

  void addError(PublishSubject responseSubject, Object e) {
    responseSubject.sink.addError(e);
  }

  Future<bool> openCashDrawer() async {
    var printerService = locator.get<MyPrinterService>();
    return await printerService.openCashDrawer();
  }

  Future<bool> createMessageForCustomerDisplay(
      String productName, String price) async {
    // KALMIA INSTANT HYACINTHS (M), RM 180.00
    var message = productName;
    var messageLength = productName.length;
    var priceLength = price.length + 1;
    // 1 extra for space in between name & price.

    if ((messageLength + priceLength) > maxCharactersAcceptedByDisplayDevice) {
      var neededProductNameLength =
          maxCharactersAcceptedByDisplayDevice - (priceLength + 3);
      // 3 extra to add 3 dots after product name
      message =
          "${productName.substring(0, neededProductNameLength)}... $price";
    } else {
      message = "$productName $price";
    }

    MyLogUtils.logDebug(
        "createMessageForCustomerDisplay message: $message & length : ${message.length}");

    return await sendMessageToDisplayDevice(message);
  }

  Future<bool> sendMessageToDisplayDevice(String message) async {
    var displayService = locator.get<DisplayDeviceService>();
    // Reset Device
    message = message.trim();
    await clearDisplayDeviceMessage(displayService);

    String emptySpaces = "";
    if (message.length < maxCharactersAcceptedByDisplayDevice) {
      int emptySpacesNeeded =
          maxCharactersAcceptedByDisplayDevice - message.length;
      for (int i = 0; i < emptySpacesNeeded; i++) {
        emptySpaces = " $emptySpaces";
      }
    }

    message = '$emptySpaces$message';

    if (message.length > maxCharactersAcceptedByDisplayDevice) {
      message = message.substring(0, maxCharactersAcceptedByDisplayDevice);
    }

    // KALMIA INSTANT HYACINTHS (M), RM 180.00
    return await displayService.sendMessage(message);
  }

  Future<void> clearDisplayDeviceMessage(
      DisplayDeviceService displayService) async {
    await displayService
        .sendMessage("                                        ");
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<bool> resetDisplayDevice() async {
    String thankYouMessage = "     Thank you!     .  Have a great day! ";
    return await sendMessageToDisplayDevice(thankYouMessage);
  }

  Future<bool> printBookingPayment(
      String title, BookingPayments payments, bool isDuplicate) {
    var printerService = locator.get<MyPrinterService>();
    return printerService.bookingPaymentPrint(title, payments, isDuplicate);
  }

  Future<bool> printCashMovementPayment(
      String title, CashMovements cash, bool isDuplicate) {
    var printerService = locator.get<MyPrinterService>();
    return printerService.cashMovementPrint(title, cash, isDuplicate);
  }

  Future<bool> printOpenCounter(String title, Stores? store, Counters? counters,
      double openingBalance, bool isDuplicate) {
    var printerService = locator.get<MyPrinterService>();
    return printerService.openCounterReceipt(
        title, store, counters, openingBalance, isDuplicate);
  }

  Future<List<RoundOffConfiguration>?> getAllRoundOffConfiguration() async {
    var api = locator.get<UserLocalApi>();
    var response = await api.getCurrentUser();
    return response?.roundOffConfiguration;
  }

  Future<CompanyConfigurationResponse?> getCompanyConfig() async {
    var api = locator.get<CompanyConfigLocalApi>();
    var response = await api.getConfig();
    return response;
  }

  Future<String> getOfflineSaleId(int customerId) async {
    var counterLocalApi = locator.get<CounterLocalApi>();
    Stores? stores = await counterLocalApi.getStore();
    Counters? counters = await counterLocalApi.getCounter();
    return getOfflineSaleUniqueId(
        customerId, counters?.id ?? 0, stores?.id ?? 0);
  }

  Future<int> getHoldSaleTypes(bool isLayWaySale, bool isBookingSale) async {//
    var api = locator.get<HoldSaleTypesLocalApi>();
    List<Types> types = await api.getAll();
    MyLogUtils.logDebug("getHoldSaleTypes : ${jsonEncode(types)} \n isLaywaySale - $isLayWaySale, \n isBookingSale - $isBookingSale");

    if (isLayWaySale) {
      List<Types> layWaySaleConfig  = types.where((i) => (i.key == "LAYAWAY_SALE")).toList();
      return layWaySaleConfig[0].id ?? 1;
    }

    if (isBookingSale) {
      List<Types> bookingSaleConfig  = types.where((i) => (i.key == "BOOKING_PAYMENT")).toList();
      return bookingSaleConfig[0].id ?? 1;
    }

    List<Types> regularConfig  = types.where((i) => (i.key == "REGULAR_SALE")).toList();
    return regularConfig[0].id ?? 1;
  }

  Future<bool> printBirthdayVoucher(
      String? title, Customers customers, Vouchers vouchers) {
    var printerService = locator.get<MyPrinterService>();
    return printerService.printBirthdayVoucher(title, customers, vouchers);
  }

  Future<bool> showOpenCounterScreen() async {
    try {
      // Check this to support offline mode
      var offlineOpenCounterApi = locator.get<OfflineOpenCounterDataApi>();
      var request = await offlineOpenCounterApi.getCurrentOpenedCounter();

      MyLogUtils.logDebug(
          "showOpenCounterScreen request : ${request?.toJson()}");

      if (request == null) {
        return true;
      }

      var localUserApi = locator.get<UserLocalApi>();
      var currentUser = await localUserApi.getCurrentUser();
      if (currentUser != null && currentUser.counter != null) {
        return false;
      }

      return true;
    } catch (e) {
      MyLogUtils.logDebug("showOpenCounterScreen error : $e");
      return false;
    }
  }
}
