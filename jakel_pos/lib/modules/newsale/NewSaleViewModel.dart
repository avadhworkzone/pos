import 'dart:convert';

import 'package:jakel_base/constants.dart';
import 'package:jakel_base/converter/bookingpayment/CartToBookingPaymentConverter.dart';
import 'package:jakel_base/converter/sale/CartSummaryToSaleConverter.dart';
import 'package:jakel_base/database/employee_group/EmployeeGroupLocalApi.dart';
import 'package:jakel_base/database/offlinedata/OfflineSalesDataApi.dart';
import 'package:jakel_base/database/products/ProductsLocalApi.dart';
import 'package:jakel_base/database/sale/OfflineSaleApi.dart';
import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/printer/service/my_printer_service.dart';
import 'package:jakel_base/restapi/bookingpayment/BookingPaymentApi.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsResponse.dart';
import 'package:jakel_base/restapi/bookingpayment/model/NewBookingRequest.dart';
import 'package:jakel_base/restapi/bookingpayment/model/ResetBookingRequest.dart';
import 'package:jakel_base/restapi/employees/model/EmployeeGroupResponse.dart';
import 'package:jakel_base/restapi/managers/model/StoreManagersResponse.dart';
import 'package:jakel_base/restapi/sales/SalesApi.dart';
import 'package:jakel_base/restapi/sales/model/history/SaveSaleResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/my_date_utils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:jakel_pos/modules/downloaddata/DownloadDataViewModel.dart';
import 'package:jakel_pos/modules/loyaltycampaigns/LoyaltyCampaignsViewModel.dart';
import 'package:jakel_pos/modules/newsale/helper/new_on_hold_sale_helper.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synchronized/synchronized.dart';

import '../app_locator.dart';
import '../offline/database/onholdsales/OnHoldSalesLocalApi.dart';
import '../vouchers/validate/voucher_config_service.dart';
import 'helper/new_sale_helper.dart';

class NewSaleViewModel extends BaseViewModel {
  // Use this object to prevent concurrent access to data
  var lock = Lock();

  var responseSubject = PublishSubject<SaveSaleResponse>();

  Stream<SaveSaleResponse> get responseStream => responseSubject.stream;

  var boolResponseSubject = PublishSubject<bool>();

  Stream<bool> get boolResponseStream => boolResponseSubject.stream;
  final loyaltyCampaignsViewModel = LoyaltyCampaignsViewModel();

  void closeObservable() {
    responseSubject.close();
    boolResponseSubject.close();
  }

  void saveNewBookingPayment(
      CartSummary cartSummary, StoreManagers? mStoreManagers) async {
    await lock.synchronized(() async {
      var result = await saveNewBookingsAndGetResult(
          cartSummary, true, true, mStoreManagers);
      if (result != null) {
        boolResponseSubject.sink.add(result);
      } else {
        responseSubject.sink.addError("Failed to save new bookings");
      }
    });
  }

  void saveNewSale(
      CartSummary cartSummary, StoreManagers? mStoreManagers) async {
    cartSummary = await getLoyaltyCampaigns(cartSummary);
    await lock.synchronized(() async {
      var response = await saveNewSaleAndGetResult(
          cartSummary, true, true, mStoreManagers);
      if (response != null) {
        var offlineSaleDataApi = locator.get<OfflineSalesDataApi>();
        if (response.sale != null) {
          await offlineSaleDataApi.saveSale(response.sale!);
        }
        if (response.sale != null &&
            response.sale?.vouchers != null &&
            response.sale!.vouchers!.isNotEmpty) {
          // sync vouchers
          DownloadDataViewModel().downloadVouchersList(() {}, () {});
        }
        // Sync Gift cards , if sale was made with gift cards.
        cartSummary.payments?.forEach((element) {
          if (element.giftCardId != null) {
            DownloadDataViewModel().downloadGiftCards(() {});
          }
        });

        responseSubject.sink.add(response);
      } else {
        responseSubject.sink.addError("Failed to save new sale");
      }
    });
  }

  Future<CartSummary> getLoyaltyCampaigns(CartSummary cartSummary) async {
    return await loyaltyCampaignsViewModel
        .getValidLoyaltyCampaignsToCart(cartSummary);
  }

  Future<bool?> saveNewBookingsAndGetResult(
      CartSummary cartSummary,
      bool saveOffline,
      bool printReceipt,
      StoreManagers? mStoreManagers) async {
    var printerService = locator.get<MyPrinterService>();
    var offlineSaleApi = locator.get<OfflineSaleApi>();

    cartSummary.offlineSaleId = cartSummary.offlineSaleId ??
        await getOfflineSaleId(cartSummary.customers?.id ?? 0);

    NewBookingRequest request = await getNewBookingRequestObject(
        cartSummary, cartSummary.offlineSaleId!, mStoreManagers);

    try {
      var api = locator.get<BookingPaymentApi>();

      var response = await api.storeNewBooking(request);

      MyLogUtils.logDebug("storeNewBooking response : ${response.message}");

      if (response.message == "The offline id has already been taken.") {
        await offlineSaleApi.delete(cartSummary.offlineSaleId ?? noData);
      }

      if (response.bookingPaymentStore != null) {
        await deleteOnHoldSale(cartSummary, true);
        await offlineSaleApi.delete(cartSummary.offlineSaleId ?? noData);

        if (printReceipt) {
          // Print receipt
          await printerService.bookingPaymentPrint(
              "Booking Payment", response.bookingPaymentStore!, false);

          await printerService.bookingPaymentPrint(
              "Booking Payment", response.bookingPaymentStore!, true);
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      MyLogUtils.logDebug("saveNewBookingsAndGetResult exception : $e");
      if (saveOffline) {
        await _proceedWithOfflineBookingsSale(cartSummary, printerService);
        return true;
      }
    }
    return null;
  }

  Future<BookingPayments?> _proceedWithOfflineBookingsSale(
      CartSummary cartSummary, MyPrinterService printerService) async {
    MyLogUtils.logDebug(
        "_proceedWithOfflineBookingsSale cartSummary : ${cartSummary.offlineSaleId}");
    // Store sale in local db
    var offlineSaleApi = locator.get<OfflineSaleApi>();
    await offlineSaleApi.save([cartSummary]);

    // Create Converter instance
    var converterApi = locator.get<CartToBookingPaymentConverter>();

    // Get BookingPayment object using converter
    BookingPayments? offlineBookingPayment =
        await converterApi.getBookingPaymentFromCart(cartSummary);

    // Print the booking payment
    if (offlineBookingPayment != null) {
      await printerService.bookingPaymentPrint(
          null, offlineBookingPayment, false);
      await printerService.bookingPaymentPrint(
          null, offlineBookingPayment, false);
    }

    boolResponseSubject.sink.add(true);
    return offlineBookingPayment;
  }

  Future<SaveSaleResponse?> saveNewSaleAndGetResult(CartSummary cartSummary,
      bool saveOffline, bool printReceipt, StoreManagers? mStoreManager) async {
    MyLogUtils.logDebug(
        "saveNewSaleAndGetResult cartSummary: ${cartSummary.toJson()}");
    var printerService = locator.get<MyPrinterService>();
    var saleRestApi = locator.get<SalesApi>();
    var voucherConfigService = appLocator.get<VoucherConfigService>();
    var offlineSaleApi = locator.get<OfflineSaleApi>();
    //In this offlineId is also set to cart summary
    var request = await getSaleRequestForNewSale(
        cartSummary,
        voucherConfigService,
        cartSummary.offlineSaleId ??
            await getOfflineSaleId(cartSummary.customers?.id ?? 0),
        mStoreManager);

    MyLogUtils.logDebug("Save sales request: ${request.toJson()}");

    // For regular sales, lets store the data offline first Before syncing.

    // if (saveOffline &&
    //     cartSummary.saleTye == SaleTye.REGULAR &&
    //     !cartSummary.isExchangeOrReturns()) {
    //   return _doOfflineSale(
    //       cartSummary, printerService, printReceipt, offlineSaleApi);
    // }

    try {
      var response = await saleRestApi.saveNewSale(request);

      MyLogUtils.logDebug("Save sales jsonEncode : ${jsonEncode(response)}");

      await afterSale(printReceipt, response, cartSummary, offlineSaleApi,
          printerService, true);

      return response;
    } catch (e) {
      MyLogUtils.logDebug("Save sales exception : $e");
      if (saveOffline) {
        return await _doOfflineSale(
            cartSummary, printerService, printReceipt, offlineSaleApi);
      }
    }

    return null;
  }

  Future<SaveSaleResponse> _doOfflineSale(
      CartSummary cartSummary,
      MyPrinterService printerService,
      bool printReceipt,
      OfflineSaleApi offlineSaleApi) async {
    MyLogUtils.logDebug("_doOfflineSale cartSummary : ${cartSummary.toJson()}");

    Sale? offlineSale = await _proceedWithOfflineSale(
        cartSummary, printerService, printReceipt);

    var response = SaveSaleResponse(sale: offlineSale);

    await afterSale(printReceipt, response, cartSummary, offlineSaleApi,
        printerService, false);

    MyLogUtils.logDebug("_doOfflineSale response : ${response.toJson()}");
    return response;
  }

  Future<void> afterSale(
      bool printReceipt,
      SaveSaleResponse response,
      CartSummary cartSummary,
      OfflineSaleApi offlineSaleApi,
      MyPrinterService printerService,
      bool isSynced) async {
    // Print receipt
    if (printReceipt) {
      await printSalesAndSalesReturns(
          response, cartSummary, offlineSaleApi, printReceipt, printerService);
    }

    // Clear offline sale data & on Hold sale
    await clearOfflineSaleAndHoldSale(response, cartSummary, isSynced);
  }

  Future<void> clearOfflineSaleAndHoldSale(
      SaveSaleResponse response, CartSummary cartSummary, bool isSynced) async {
    Sale? sale = response.sale;
    Sale? saleReturn = response.saleReturn;

    var offlineSaleApi = locator.get<OfflineSaleApi>();
    if (sale != null) {
      await deleteOnHoldSale(cartSummary, true);
      if (isSynced) {
        await offlineSaleApi.delete(sale.offlineSaleId ?? noData);
      }
    }

    if (saleReturn != null) {
      await deleteOnHoldSale(cartSummary, true);
      if (isSynced) {
        await offlineSaleApi.delete(saleReturn.offlineSaleReturnId ?? noData);
      }
    }
  }

  Future<void> printSalesAndSalesReturns(
      SaveSaleResponse response,
      CartSummary cartSummary,
      OfflineSaleApi offlineSaleApi,
      bool printReceipt,
      MyPrinterService printerService) async {
    Sale? sale = response.sale;
    Sale? saleReturn = response.saleReturn;

    // Only New Sale Items
    if (sale != null) {
      if (printReceipt) {
        var printResult =
            await printerService.salePrint(null, sale, false, false);
        printResult = await printerService.salePrint(null, sale, true, false);
        MyLogUtils.logDebug("Save new sale printResult: $printResult");
      }
    }

    // ONLY RETURN ITEMS
    if (saleReturn != null) {
      if (printReceipt) {
        var printResult =
            await printerService.salePrint(null, saleReturn, false, false);
        printResult =
            await printerService.salePrint(null, saleReturn, true, false);
        MyLogUtils.logDebug("Save saleReturn printResult: $printResult");
      }
    }

    // // Only New Sale Items
    // if (response.sale != null && response.saleReturn == null) {
    //   await deleteOnHoldSale(cartSummary);
    //   await offlineSaleApi.delete(response.sale!.offlineSaleId ?? noData);
    //   if (printReceipt) {
    //     var printResult =
    //         await printerService.salePrint(null, response.sale!, false);
    //     printResult =
    //         await printerService.salePrint(null, response.sale!, false);
    //     MyLogUtils.logDebug("Save new sale printResult: $printResult");
    //   }
    // }
    //
    // // Sale along with return items
    // if (response.saleReturn != null) {
    //   await deleteOnHoldSale(cartSummary);
    //   await offlineSaleApi
    //       .delete(response.saleReturn!.offlineSaleReturnId ?? noData);
    //
    //   if (printReceipt) {
    //     if (response.sale != null) {
    //       // New sale items
    //       if (response.sale?.saleItems != null) {
    //         response.saleReturn?.setSaleItems(response.sale?.saleItems ?? []);
    //       }
    //       // Payments from new sale
    //       if (response.sale?.payments != null) {
    //         response.saleReturn?.setPayments(response.sale?.payments ?? []);
    //       }
    //
    //       response.saleReturn
    //           ?.setBillReferenceNumber(response.sale?.billReferenceNumber);
    //
    //       response.saleReturn?.setSaleNotes(response.sale?.saleNotes);
    //     }
    //     var printResult =
    //         await printerService.salePrint(null, response.saleReturn!, false);
    //     printResult =
    //         await printerService.salePrint(null, response.saleReturn!, false);
    //     MyLogUtils.logDebug("Save saleReturn printResult: $printResult");
    //   }
    // }
  }

  Future<Sale?> _proceedWithOfflineSale(CartSummary cartSummary,
      MyPrinterService printerService, bool printReceipt) async {
    var offlineSaleApi = locator.get<OfflineSaleApi>();
    await offlineSaleApi.save([cartSummary]);

    var converterApi = locator.get<CartSummaryToSaleConverter>();

    Sale? offlineSale = await converterApi.getSaleFromCartSummary(cartSummary);
    offlineSale?.userDetails?.currentSalePoints =
        getDoubleValue(cartSummary.getTotalLoyaltyPoints());

    responseSubject.sink.add(SaveSaleResponse(sale: offlineSale));
    return offlineSale;
  }

  Future<bool> saveToOnHoldSale(CartSummary cartSummary) async {
    cartSummary.offlineSaleId ??=
        await getOfflineSaleId(cartSummary.customers?.id ?? 0);
    var onHoldApi = appLocator.get<OnHoldSalesLocalApi>();
    await onHoldApi.save(cartSummary);

    // Send to Backend via APi
    var request = await getOnHoldSaleRequestFromCartSummary(
        cartSummary,
        cartSummary.offlineSaleId ??
            await getOfflineSaleId(cartSummary.customers?.id ?? 0),
        await getHoldSaleTypes(
            cartSummary.isLayAwaySale, cartSummary.isBookingSale));

    var saleRestApi = locator.get<SalesApi>();
    saleRestApi.holdSale(request);

    return true;
  }

  Future<List<CartSummary>> getAllOnHoldSales() async {
    var onHoldApi = appLocator.get<OnHoldSalesLocalApi>();
    var productsApi = locator.get<ProductsLocalApi>();
    List<CartSummary> allOnHoldSales = await onHoldApi.getAll();
    for (var element in allOnHoldSales) {
      element.cartItems?.forEach((element) async {
        element.product =
            await productsApi.productById(element.product?.id ?? 0);
      });
    }
    return allOnHoldSales;
  }

  Future<bool> deleteOnHoldSale(
      CartSummary cartSummary, bool? afterSaleComplete) async {
    var onHoldApi = appLocator.get<OnHoldSalesLocalApi>();

    // var onHoldSaleData = await onHoldApi.getById(cartSummary.offlineSaleId!);
    //
    // MyLogUtils.logDebug("deleteOnHoldSale onHoldSaleData :$onHoldSaleData");

    bool result = await onHoldApi.delete(cartSummary.offlineSaleId!);

    MyLogUtils.logDebug(
        "deleteOnHoldSale :$result && afterSaleComplete : $afterSaleComplete");

    // Send to Backend via APi
    var request = await getOnHoldSaleRequestFromCartSummary(
        cartSummary,
        cartSummary.offlineSaleId ??
            await getOfflineSaleId(cartSummary.customers?.id ?? 0),
        await getHoldSaleTypes(
            cartSummary.isLayAwaySale, cartSummary.isBookingSale));

    var saleRestApi = locator.get<SalesApi>();

    if (afterSaleComplete != null) {
      if (afterSaleComplete) {
        if (result) {
          MyLogUtils.logDebug("deleteOnHoldSale  call completeHoldSale api.");
          request.setCompleteAt(dateTimeYmdHis24Hour());
          saleRestApi.completeHoldSale(request);
        }
      } else {
        request.setCanceledAt(dateTimeYmdHis24Hour());
        saleRestApi.cancelHoldSale(request);
      }
    }

    return result;
  }

  Future<bool> onHoldSaleReleased(CartSummary cartSummary) async {
    // Send to Backend via APi
    var request = await getOnHoldSaleRequestFromCartSummary(
        cartSummary,
        cartSummary.offlineSaleId ??
            await getOfflineSaleId(cartSummary.customers?.id ?? 0),
        await getHoldSaleTypes(
            cartSummary.isLayAwaySale, cartSummary.isBookingSale));
    request.setReleasedAt(dateTimeYmdHis24Hour());
    var saleRestApi = locator.get<SalesApi>();
    return saleRestApi.releaseHoldSale(request);
  }

  // Future<bool> onHoldSaleCompleted(CartSummary cartSummary) async {
  //   // Send to Backend via APi
  //   var request = await getOnHoldSaleRequestFromCartSummary(
  //       cartSummary,
  //       cartSummary.offlineSaleId ??
  //           await getOfflineSaleId(cartSummary.customers?.id ?? 0),
  //       await getHoldSaleTypes(
  //           cartSummary.isLayAwaySale, cartSummary.isBookingSale));
  //   var saleRestApi = locator.get<SalesApi>();
  //   request.setCompleteAt(dateTimeYmdHis24Hour());
  //   return saleRestApi.completeHoldSale(request);
  // }

  bool isPromotersAttachedToAllItems(
      CartSummary cartSummary, int minimumPromoterCounterNeeded) {
    var result = true;
    cartSummary.cartItems?.forEach((element) {
      if (element.getIsSelectItem()) {
        if (element.saleReturnsItemData == null) {
          if (element.promoters == null ||
              element.promoters!.isEmpty ||
              ((element.promoters?.length ?? 0) <
                  minimumPromoterCounterNeeded)) {
            result = false;
          }
        }
      }
    });
    return result;
  }

  ///Validate employee group limit.
  Future<bool> validEmployeeGroupConfiguration(CartSummary mCartSummary,
      [CartItem? cartItem]) async {
    try {
      int id = (mCartSummary.employees!.employeeGroup!.id ?? 0);
      double usedLimit = (mCartSummary.employees!.usedLimit ?? 0.0);

      var localApi = locator.get<EmployeeGroupLocalApi>();
      EmployeeGroup getEmployeeGroup = await localApi.getById(id);

      MyLogUtils.logDebug(
          "EmployeeGroup configuration data : ${jsonEncode(getEmployeeGroup)}");

      double itemPurchaseLimit =
          (getDoubleValue(getEmployeeGroup.itemPurchaseLimit ?? 0.0));

      if (mCartSummary.employees == null) {
        return true;
      }

      if (itemPurchaseLimit == 0.0) {
        return false;
      } else if ((getEmployeeGroup.purchaseLimitType?.name ?? "") ==
          "By Amount") {
        if ((usedLimit + mCartSummary.getTotalAmount()) > itemPurchaseLimit) {
          return false;
        }
      } else if ((getEmployeeGroup.purchaseLimitType?.name ?? "") ==
          "By Items") {
        num itemsCount = 0;
        mCartSummary.cartItems?.forEach((element) {
          itemsCount += (element.qty ?? 0);
        });
        if ((usedLimit + itemsCount) > itemPurchaseLimit) {
          return false;
        }
      } else if ((getEmployeeGroup.purchaseLimitType?.name ?? "") ==
          "By Sale") {
        if (usedLimit >= itemPurchaseLimit) {
          return false;
        }
      }
      return true;
    } catch (e) {
      MyLogUtils.logDebug("getEmployeesGroup failed with exception $e");
      return true;
    }
  }

  /// resetBookingPayment
  void resetBookingPayment(
      CartSummary cartSummary) async {
    await lock.synchronized(() async {
      var result = await resetBookingsAndGetResult(
          cartSummary, true, true);
      if (result != null) {
        boolResponseSubject.sink.add(result);
      } else {
        responseSubject.sink.addError("Failed to save new bookings");
      }
    });
  }

  Future<bool?> resetBookingsAndGetResult(
      CartSummary cartSummary,
      bool saveOffline,
      bool printReceipt,) async {
    var printerService = locator.get<MyPrinterService>();
    var offlineSaleApi = locator.get<OfflineSaleApi>();

    cartSummary.offlineSaleId = cartSummary.offlineSaleId ??
        await getOfflineSaleId(cartSummary.customers?.id ?? 0);

    ResetBookingRequest request = await getResetBookingRequestObject(
        cartSummary, cartSummary.offlineSaleId!);

    try {
      var api = locator.get<BookingPaymentApi>();

      var response = await api.resetBookingsProducts(cartSummary.returnBookingSaleId,request);

      MyLogUtils.logDebug("storeNewBooking response : ${jsonEncode(response)}");

      if (response.bookingPaymentProducts != null) {
        await deleteOnHoldSale(cartSummary, true);
        await offlineSaleApi.delete(cartSummary.offlineSaleId ?? noData);

        if (printReceipt) {
          // Print receipt
          await printerService.resetBookingPaymentPrint(
              "Reset Booking Payment", response.bookingPaymentProducts!, false);

          await printerService.resetBookingPaymentPrint(
              "Reset Booking Payment", response.bookingPaymentProducts!, true);
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      MyLogUtils.logDebug("saveNewBookingsAndGetResult exception : $e");
      if (saveOffline) {
        await _proceedWithOfflineBookingsSale(cartSummary, printerService);
        return true;
      }
    }
    return null;
  }

}
