import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsResponse.dart';
import 'package:jakel_base/restapi/sales/model/history/SalesResponse.dart';
import 'package:jakel_pos/modules/home/model/HomeMenuItem.dart';

class SaleHistoryInheritedWidget extends InheritedWidget {
  const SaleHistoryInheritedWidget({
    Key? key,
    required this.saleHistoryDataModel,
    required Widget child,
  }) : super(key: key, child: child);

  final SaleHistoryDataModel saleHistoryDataModel;

  static SaleHistoryInheritedWidget of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<SaleHistoryInheritedWidget>()
        as SaleHistoryInheritedWidget;
  }

  @override
  bool updateShouldNotify(SaleHistoryInheritedWidget old) {
    return saleHistoryDataModel != old.saleHistoryDataModel;
  }
}

class SaleHistoryDataModel {
  late Sales? selectedSale;
  final HashMap<int, Sales> updatedSaleMap;
  late bool refreshRegularSales;
  late bool refreshLayawaySales;
  late BookingPayments? selectedBookingPayment;

  SaleHistoryDataModel(this.updatedSaleMap,
      {this.selectedSale,
      required this.refreshRegularSales,
      required this.refreshLayawaySales,
      this.selectedBookingPayment});
}
