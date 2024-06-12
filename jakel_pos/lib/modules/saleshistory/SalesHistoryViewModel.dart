import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jakel_base/constants.dart';
import 'package:jakel_base/database/salereturnreason/SaleReturnReasonLocalApi.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/printer/service/my_printer_service.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsResponse.dart';
import 'package:jakel_base/restapi/customers/CustomerApi.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/restapi/managers/StoreManagersApi.dart';
import 'package:jakel_base/restapi/managers/model/StoreManagersResponse.dart';
import 'package:jakel_base/restapi/sales/SalesApi.dart';
import 'package:jakel_base/restapi/sales/model/CancelLayawayAmountRequest.dart';
import 'package:jakel_base/restapi/sales/model/SaleReturnsResponse.dart';
import 'package:jakel_base/restapi/sales/model/UpdateLayawayAmountRequest.dart';
import 'package:jakel_base/restapi/sales/model/UpdateLayawayLoyaltyPointsRequest.dart';
import 'package:jakel_base/restapi/sales/model/history/SalesResponse.dart';
import 'package:jakel_base/restapi/sales/model/history/SaveSaleResponse.dart';
import 'package:jakel_base/restapi/sales/model/void/VoidSaleReasonResponse.dart';
import 'package:jakel_base/restapi/sales/model/void/VoidSaleRequest.dart';
import 'package:jakel_base/sale/sale_helper.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/my_date_utils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/bookingpayments/booking_payments_widget.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/dialog/LayawayPaymentLoyaltyPointRequest.dart';
import 'package:rxdart/rxdart.dart';

import '../newsale/ui/widgets/select_loyalty_points_widget.dart';

class SalesHistoryViewModel extends BaseViewModel {
  var responseSubject = PublishSubject<SalesResponse>();

  Stream<SalesResponse> get responseStream => responseSubject.stream;

  var boolResponseSubject = PublishSubject<bool>();

  Stream<bool> get boolResponseStream => boolResponseSubject.stream;

  var stringResponseSubject = PublishSubject<SaveSaleResponse>();

  Stream<SaveSaleResponse> get stringResponseStream =>
      stringResponseSubject.stream;

  void closeObservable() {
    responseSubject.close();
    boolResponseSubject.close();
    stringResponseSubject.close();
  }

  Future<void> rePrintSale(String? title, Sale sale) async {
    var printerService = locator.get<MyPrinterService>();
    var printResult = await printerService.salePrint(title, sale, true, false);
    MyLogUtils.logDebug("Save sales printResult: $printResult");
  }

  Future<void> printVoidedSales(Sale sale) async {
    var printerService = locator.get<MyPrinterService>();
    var printResult =
        await printerService.salePrint("Voided Sale", sale, false, true);
    MyLogUtils.logDebug("Save sales printResult: $printResult");
  }

  void updateLayawayAmount(
      int saleId, UpdateLayawayAmountRequest request) async {
    var api = locator.get<SalesApi>();
    var printerService = locator.get<MyPrinterService>();

    try {
      var response = await api.updateLayawayAmount(saleId, request);

      if (response.sale != null) {
        String title = "Layaway Sale";
        if (isPendingLayawaySale(getSalesFromSale(response.sale!))) {
          title = "Pending Layaway Sale";
        }
        await printerService.salePrint(title, response.sale!, false, false);
      }

      var saleResponse = SalesResponse(
          currentPage: 1,
          totalRecords: 1,
          lastPage: 1,
          perPage: 1,
          sale: Sales.fromJson(response.sale?.toJson()));

      responseSubject.sink.add(saleResponse);
    } catch (e) {
      MyLogUtils.logDebug("updateLayawayAmount exception $e");
      responseSubject.sink.addError(e);
    }
  }

  Future<bool> cancelLayawayAmount(
      int saleId, CancelLayawayAmountRequest request) async {
    var api = locator.get<SalesApi>();
    var printerService = locator.get<MyPrinterService>();

    try {
      var response = await api.cancelLayawayAmount(saleId, request);

      if (response.sale != null) {
        String title = "Cancel Layaway Sale";
        await printerService.salePrint(title, response.sale! , false, false);
        return true;
      }
      return false;
    } catch (e) {
      MyLogUtils.logDebug("cancelLayawayAmount exception $e");
      return false;
    }
  }

  void voidASale(int saleId, VoidSaleRequest request) async {
    var api = locator.get<SalesApi>();

    try {
      var response = await api.voidSale(saleId, request);
      stringResponseSubject.sink.add(response);
    } catch (e) {
      MyLogUtils.logDebug("voidASale exception $e");
      responseSubject.sink.addError(e);
    }
  }

  void getRegularSales(
      int pageNo,
      int perPage,
      int customerId,
      int employeeId,
      DateTime? fromDate,
      DateTime? toDate,
      String? searchText,
      int? counterId) async {
    var api = locator.get<SalesApi>();

    if (searchText != null && searchText.isEmpty) {
      searchText = null;
    }

    try {
      var response = await api.getSalesHistory(
          pageNo,
          perPage,
          customerId,
          employeeId,
          dateYmdFromDate(fromDate),
          dateYmdFromDate(toDate),
          searchText,
          counterId);
      responseSubject.sink.add(response);
    } catch (e) {
      MyLogUtils.logDebug("getRegularSales exception $e");
      responseSubject.sink.addError(e);
    }
  }

  void getSaleReturnsHistory(
      int pageNo, int perPage, int customerId, int employeeId,String? search) async {
    var api = locator.get<SalesApi>();

    try {
      var response = await api.getSaleReturnsHistory(
          pageNo, perPage, customerId, employeeId, null, null,search);
      responseSubject.sink.add(response);
    } catch (e) {
      MyLogUtils.logDebug("getRegularSales exception $e");
      responseSubject.sink.addError(e);
    }
  }

  void getRegularSaleById(String saleId) async {
    var api = locator.get<SalesApi>();

    try {
      var response = await api.getSaleById(saleId);
      responseSubject.sink.add(response);
    } catch (e) {
      MyLogUtils.logDebug("getRegularSaleBySaleId exception $e");
      responseSubject.sink.addError(e);
    }
  }

  void getPendingLayawaySaleById(int saleId) async {
    var api = locator.get<SalesApi>();

    try {
      var response = await api.getPendingLayawaySale('$saleId');
      responseSubject.sink.add(response);
    } catch (e) {
      MyLogUtils.logDebug("getRegularSaleBySaleId exception $e");
      responseSubject.sink.addError(e);
    }
  }

  void getLayawaySales(
      int pageNo, int perPage, int customerId, int employeeId) async {
    var api = locator.get<SalesApi>();

    try {
      var response = await api.getLayawaySales(
          pageNo, perPage, customerId, employeeId, null, null);
      responseSubject.sink.add(response);
    } catch (e) {
      MyLogUtils.logDebug("getLayawaySales exception $e");
      responseSubject.sink.addError(e);
    }
  }

  void getVoidSales(
      int pageNo, int perPage, int customerId, int employeeId) async {
    var api = locator.get<SalesApi>();

    try {
      var response = await api.getVoidSalesHistory(
          pageNo, perPage, customerId, employeeId, null, null);

      MyLogUtils.logDebug("getVoidSales response : ${response.toJson()}");
      responseSubject.sink.add(response);
    } catch (e) {
      MyLogUtils.logDebug("getVoidSales exception $e");
      responseSubject.sink.addError(e);
    }
  }

  String getCustomerName(Sales sale) {
    return sale.userDetails?.firstName ?? noData;
  }

  String getCashier(Sales sale) {
    return sale.cashierDetails?.firstName ?? noData;
  }

  String getCounter(Sales sale) {
    return sale.counterDetails?.name ?? noData;
  }

  String getDateTime(Sales sale) {
    return "${sale.happenedAt ?? ""} ";
  }

  String getTotalAmount(Sales sale) {
    return getOnlyReadableAmount(sale.totalAmountPaid ?? 0.0);
  }

  String getTotalItems(Sales sale) {
    if (sale.saleItems != null) {
      return "${sale.saleItems?.length}";
    }
    return "0";
  }

  String getTotalReturnsItems(Sales sale) {
    if (sale.saleReturnItems != null) {
      return "${sale.saleReturnItems?.length}";
    }
    return "0";
  }

  String getTotalQuantities(Sales sale) {
    double totalQuantities = 0;
    if (sale.saleItems != null) {
      sale.saleItems?.forEach((element) {
        totalQuantities = totalQuantities + (element.quantity ?? 0);
      });
    }
    return getStringWithNoDecimal(totalQuantities);
  }

  String getTotalReturnQuantities(Sales sale) {
    double totalQuantities = 0;
    if (sale.saleReturnItems != null) {
      sale.saleReturnItems?.forEach((element) {
        totalQuantities = totalQuantities + (element.quantity ?? 0);
      });
    }
    return getStringWithNoDecimal(totalQuantities);
  }

  String getPaymentTypes(Sales sale) {
    String paymentType = "";
    if (sale.payments != null) {
      for (Payments payment in sale.payments!) {
        if (payment.paymentType != null) {
          paymentType = "$paymentType ${payment.paymentType!.name!}";
        }
      }
    }
    return paymentType;
  }

  String getSaleItemName(SaleItems item) {
    return item.product?.name ?? "";
  }

  String getSaleItemQty(SaleItems item) {
    return item.quantity != null
        ? 'x ${getStringWithNoDecimal(item.quantity)}'
        : "x 0";
  }

  String getSaleItemPrice(SaleItems item) {
    if ((item.pricePaidPerUnit ?? 0) <= 0) {
      return getReadableAmount(
          "RM", (item.totalPricePaid ?? 0) / (item.quantity ?? 1));
    }
    return getReadableAmount("RM", item.pricePaidPerUnit ?? 0);
  }

  String getPaymentName(Payments payments) {
    return payments.paymentType?.name ?? "";
  }

  String getPaymentAmount(Payments payments) {
    return getReadableAmount("RM", payments.amount ?? 0);
  }

  String getTax(Sales sale) {
    return getReadableAmount("RM", sale.totalTaxAmount);
  }

  String getRoundingAdjustment(Sales sale) {
    return getReadableAmount("RM", sale.saleRoundOffAmount);
  }

  String getLayawayPending(Sales sale) {
    return getReadableAmount("RM", sale.layawayPendingAmount);
  }

  String getTotalPaid(Sales sale) {
    if (isLayawaySaleType(sale.status)) {
      return getReadableAmount("RM", ((sale.totalAmountPaid ?? 0)));
    }
    return getReadableAmount(
        "RM", ((sale.totalAmountPaid ?? 0) + (sale.changeDue ?? 0)));
  }

  String getSubTotal(Sales sale) {
    double totalAmountPaid =
        (sale.totalAmountPaid ?? 0.0) + (sale.layawayPendingAmount ?? 0.0);
    double totalTax = (sale.totalTaxAmount ?? 0.0);
    double totalDiscount = (sale.totalDiscountAmount ?? 0.0);
    double saleRoundOffAmount = (sale.saleRoundOffAmount ?? 0.0);

    if (saleRoundOffAmount > 0) {
      return getReadableAmount(
          "RM",
          (totalAmountPaid + totalDiscount - (sale.saleRoundOffAmount ?? 0.0)) -
              totalTax);
    }

    return getReadableAmount(
        "RM",
        (totalAmountPaid +
                totalDiscount +
                (sale.saleRoundOffAmount ?? 0.0).abs()) -
            totalTax);
  }

  String getSalesHistorySubTotal(Sales sale) {
    double totalAmountPaid =
        (sale.totalAmountPaid ?? 0.0) + (sale.layawayPendingAmount ?? 0.0);
    double totalTax = (sale.totalTaxAmount ?? 0.0);
    double totalDiscount = (sale.totalDiscountAmount ?? 0.0);
    double saleRoundOffAmount = (sale.saleRoundOffAmount ?? 0.0);

    if (saleRoundOffAmount > 0) {
      return getReadableAmount(
          "RM",
          (totalAmountPaid + totalDiscount - (sale.saleRoundOffAmount ?? 0.0)) -
              totalTax);
    }

    // .abs() used to convert
    return getReadableAmount(
        "RM",
        (totalAmountPaid +
                totalDiscount +
                (sale.saleRoundOffAmount ?? 0.0).abs()) -
            totalTax);
  }

  String getPendingLayawaySalesHistorySubTotal(Sales sale) {
    double totalAmountPaid =
        (sale.totalAmountPaid ?? 0.0) + (sale.layawayPendingAmount ?? 0.0);
    double totalTax = (sale.totalTaxAmount ?? 0.0);
    double totalDiscount = (sale.totalDiscountAmount ?? 0.0);
    double saleRoundOffAmount = (sale.saleRoundOffAmount ?? 0.0);
    double totalPendingLayawayTax =
        getCalculatePendingLayawayTotalDiscountAmount(sale);
    if (saleRoundOffAmount > 0) {
      return getReadableAmount(
          "RM",
          (totalAmountPaid +
                  totalPendingLayawayTax +
                  totalDiscount -
                  (sale.saleRoundOffAmount ?? 0.0)) -
              totalTax);
    }

    // .abs() used to convert
    return getReadableAmount(
        "RM",
        (totalAmountPaid +
                totalPendingLayawayTax +
                totalDiscount +
                (sale.saleRoundOffAmount ?? 0.0).abs()) -
            totalTax);
  }

  String getTotalDiscountAmount(Sales sale) {
    return getReadableAmount("RM", sale.totalDiscountAmount);
  }

  String getPendingLayawayTotalDiscountAmount(Sales sale) {
    double totalPendingLayawayTax =
        getCalculatePendingLayawayTotalDiscountAmount(sale);
    return getReadableAmount("RM", totalPendingLayawayTax);
  }

  double getCalculatePendingLayawayTotalDiscountAmount(Sales sale) {
    double totalPendingLayawayTax = 0.0;
    if ((sale.saleItems ?? []).isNotEmpty) {
      for (SaleItems mSaleItems in sale.saleItems ?? []) {
        totalPendingLayawayTax = totalPendingLayawayTax+ (mSaleItems.totalDiscountAmount ?? 0.0);
      }
    }
    return totalPendingLayawayTax;
  }

  String getChangeDue(Sales sale) {
    return getReadableAmount("RM", sale.changeDue);
  }

  String getPendingLayawayAmount(Sales sale) {
    return getReadableAmount("RM", sale.layawayPendingAmount);
  }

  String totalAmount(Sales sale) {
    double totalAmount = 0.0;
    totalAmount =
        ((sale.totalAmountPaid ?? 0) + (sale.layawayPendingAmount ?? 0));
    // sale.saleItems?.forEach((element) {
    //   totalAmount =
    //       totalAmount + (element.pricePaidPerUnit! * element.quantity!);
    // });

    return getReadableAmount("RM", roundToNearestPossible(totalAmount));
  }

  Future<List<VoidSaleReasons>> getVoidSaleReasons() async {
    var api = locator.get<SalesApi>();
    var response = await api.getVoidSaleReason();
    return response.voidSaleReasons ?? [];
  }

  Future<List<StoreManagers>> getStoreManagers() async {
    var api = locator.get<StoreManagersApi>();
    var response = await api.getStoreManagers();
    return response.storeManagers ?? [];
  }

  List<Sales> filterSales(List<Sales> allSales, String? searchText) {
    if (searchText == null || searchText.isEmpty) {
      return allSales;
    }

    List<Sales> filtered = List.empty(growable: true);
    for (var element in allSales) {
      if ((element.id != null &&
              '${element.id}'.contains(searchText.toLowerCase())) ||
          (element.offlineSaleId != null &&
              element.offlineSaleId!.contains(searchText.toLowerCase())) ||
          (element.userDetails?.firstName != null &&
              element.userDetails!.firstName!
                  .toLowerCase()
                  .contains(searchText.toLowerCase())) ||
          (element.userDetails?.lastName != null &&
              element.userDetails!.lastName!
                  .toLowerCase()
                  .contains(searchText.toLowerCase())) ||
          (element.userDetails?.email != null &&
              element.userDetails!.email!
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))) {
        filtered.add(element);
      }
    }
    return filtered;
  }

  Future<List<SaleReturnReasons>> getSaleReturnReasons() async {
    var api = locator.get<SaleReturnReasonLocalApi>();
    List<SaleReturnReasons> reasons = await api.getAll();
    MyLogUtils.logDebug("getSaleReturnReasons : $reasons");
    return reasons;
  }

  void getCustomerDetails(int customersId, double pendingAmount,
      BuildContext context, int paymentTypesId) async {
    var api = locator.get<CustomerApi>();

    try {
      var response = await api.getCustomerDetail(customersId);
      // ignore: use_build_context_synchronously
      if (paymentTypesId == loyaltyPointPaymentId) {
        _showLoyaltyPaymentDialog(response, pendingAmount, context);
      } else if (paymentTypesId == bookingPaymentId) {
        _showBookingPaymentDialog(response, context);
      }
      //responseSubjectLoyaltyPaymentDetails.sink.add(response);
    } catch (e) {
      MyLogUtils.logDebug("getCustomerDetails exception $e");
      responseSubjectLoyaltyPaymentDetails.sink.addError(e);
    }
  }

  /// Booking Payment
  var responseSubjectBookingPaymentDetails = PublishSubject<BookingPayments>();

  Stream<BookingPayments> get responseStreamBookingPaymentDetails =>
      responseSubjectBookingPaymentDetails.stream;

  void closeObservableBookingPaymentDetails() {
    responseSubjectBookingPaymentDetails.close();
  }

  void _showBookingPaymentDialog(
      CustomersResponse response, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.all(10.0),
              width: 800,
              height: 700,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Booking Payments",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      MyInkWellWidget(
                          child: const Icon(Icons.close),
                          onTap: () {
                            Navigator.pop(context);
                          })
                    ],
                  ),
                  Expanded(
                      child: BookingPaymentWidget(
                    customerId: response.customer!.id,
                    onBookingPaymentSelected: (bookingPayments) {
                      responseSubjectBookingPaymentDetails.sink
                          .add(bookingPayments);
                      Navigator.pop(context);
                      // setState(() {
                      //   selectedBookingPayments = bookingPayments;
                      //   searchBookingPayment = true;
                      // });
                    },
                  ))
                ],
              ),
            ));
      },
    );
  }

  /// Loyalty Payment
  var responseSubjectLoyaltyPaymentDetails =
      PublishSubject<LayawayPaymentLoyaltyPointRequest>();

  Stream<LayawayPaymentLoyaltyPointRequest>
      get responseStreamLoyaltyPaymentDetails =>
          responseSubjectLoyaltyPaymentDetails.stream;

  void closeObservableLoyaltyPaymentDetails() {
    responseSubjectLoyaltyPaymentDetails.close();
  }

  void _showLoyaltyPaymentDialog(
      CustomersResponse response, double pendingAmount, BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => SelectLoyaltyPointsWidget(
            customers: response.customer!,
            totalPayableAmount: pendingAmount,
            savePoints: (points, amount) {
              MyLogUtils.logDebug("savePoints : $points & amount : $amount");
              LayawayPaymentLoyaltyPointRequest
                  mLayawayPaymentLoyaltyPointRequest =
                  LayawayPaymentLoyaltyPointRequest(
                      response.customer!.totalLoyaltyPoints.toString(),
                      points.toString(),
                      amount.toString());
              setEnteredAmount(double.parse(amount.toString()), pendingAmount);
              responseSubjectLoyaltyPaymentDetails.sink
                  .add(mLayawayPaymentLoyaltyPointRequest);
            },
            removePoints: () {}));
  }

  ///  enteredAmount
  var responseSubjectEnteredAmount = PublishSubject<double>();

  Stream<double> get responseStreamEnteredAmount =>
      responseSubjectEnteredAmount.stream;

  void closeObservableEnteredAmount() {
    responseSubjectEnteredAmount.close();
  }

  setEnteredAmount(double enteredAmount, double pendingAmount) {
    setBalanceChangeDue(enteredAmount - pendingAmount);
    responseSubjectEnteredAmount.sink.add(enteredAmount);
  }

  ///  balanceChangeDue
  var responseSubjectBalanceChangeDue = PublishSubject<double>();

  Stream<double> get responseStreamBalanceChangeDue =>
      responseSubjectBalanceChangeDue.stream;

  void closeObservableBalanceChangeDue() {
    responseSubjectBalanceChangeDue.close();
  }

  setBalanceChangeDue(double balanceChangeDue) {
    responseSubjectBalanceChangeDue.sink.add(balanceChangeDue);
  }
}
