import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/sales/model/history/SalesResponse.dart';
import 'package:jakel_base/sale/sale_helper.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';

import 'package:jakel_base/widgets/appbgwidget/MyBackgroundWidget.dart';
import 'package:jakel_pos/modules/saleshistory/ui/sale_history_inherited_widget.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/bookingpayments/booking_payment_detail_widget.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/bookingpayments/booking_payments_widget.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/history/layaway_sales_widget.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/history/offline_sales_widget.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/history/regular_sales_detail_widget.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/history/regular_sales_widget.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/history/sale_returns_list_widget.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/history/void_sales_widget.dart';

class SalesHistoryScreen extends StatefulWidget {
  final Function proceedToSaleReturns;
  final Function resetProductsInBookingPayments;

  const SalesHistoryScreen(
      {Key? key,
      required this.proceedToSaleReturns,
      required this.resetProductsInBookingPayments})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SalesHistoryScreenState();
  }
}

enum SalesHistoryType {
  REGULAR,
  VOID,
  LAYAWAY,
  BOOKING_PAYMENT,
  SALE_RETURNS,
  OFFLINE_SALES
}

class _SalesHistoryScreenState extends State<SalesHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Map<SalesHistoryType, Widget> tabChildrenWidgets = {};
  Map<SalesHistoryType, Widget> tabWidgets = {};
  HashMap<int, Sales> updatedSaleMap = HashMap();

  bool showReturnButton = false;
  bool _showVoidSale = false;
  int count = 0;
  late SaleHistoryDataModel saleHistoryDataModel;
  String titleInPrintReceipt = "";

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Tab Children Widgets
    saleHistoryDataModel = SaleHistoryDataModel(
        refreshLayawaySales: false, refreshRegularSales: false, updatedSaleMap);

    _populateTabChildren();

    // Tab widgets
    _populateTabs();

    _tabController =
        TabController(length: tabChildrenWidgets.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SaleHistoryInheritedWidget(
      saleHistoryDataModel: saleHistoryDataModel,
      child: MyBackgroundWidget(child: rootWidget()),
    ));
  }

  void _populateTabChildren() {
    tabChildrenWidgets[SalesHistoryType.REGULAR] =
        RegularSalesWidget(onSelected: (sale) {
      setState(() {
        titleInPrintReceipt = "";
        if (isLayawaySale(sale)) {
          titleInPrintReceipt = "Layaway Sale";
        }
        // when sale is selected from the list, check if its updated sale is
        // already available in the sale detail widget using inherited widget.
        // This is because to avoid reloading of entire sale page to just get updated sale in detail page.
        // Anyways, updated sale will be available in sale detail page.
        var updatedSale = saleHistoryDataModel.updatedSaleMap[sale.id];
        if (updatedSale != null) {
          saleHistoryDataModel.selectedSale = updatedSale;
        } else {
          saleHistoryDataModel.selectedSale = sale;
        }

        showReturnButton = true;
        _showVoidSale = true;
        saleHistoryDataModel.selectedBookingPayment = null;
      });
    });

    tabChildrenWidgets[SalesHistoryType.SALE_RETURNS] =
        SaleReturnsListWidget(onSelected: (sale) {
      setState(() {
        titleInPrintReceipt = "RETURNS";
        saleHistoryDataModel.selectedSale = sale;
        showReturnButton = false;
        _showVoidSale = false;
        saleHistoryDataModel.selectedBookingPayment = null;
      });
    });

    tabChildrenWidgets[SalesHistoryType.LAYAWAY] =
        LayawaySalesWidget(onSelected: (sale) {
      setState(() {
        titleInPrintReceipt = "Pending Layaway Sale";
        var updatedSale = saleHistoryDataModel.updatedSaleMap[sale.id];
        if (updatedSale != null) {
          saleHistoryDataModel.selectedSale = updatedSale;
        } else {
          saleHistoryDataModel.selectedSale = sale;
        }

        showReturnButton = false;
        _showVoidSale = false;
        saleHistoryDataModel.selectedBookingPayment = null;
      });
    });

    tabChildrenWidgets[SalesHistoryType.BOOKING_PAYMENT] =
        BookingPaymentWidget(onBookingPaymentSelected: (sale) {
      setState(() {
        MyLogUtils.logDebug("BookingPaymentWidget sale  : ${sale.toJson()}");
        titleInPrintReceipt = "Booking Payment";
        saleHistoryDataModel.selectedSale = null;
        showReturnButton = false;
        saleHistoryDataModel.selectedBookingPayment = sale;
        _showVoidSale = false;

        MyLogUtils.logDebug("BookingPaymentWidget saleHistoryDataModel"
            ".selectedBookingPayment  : ${saleHistoryDataModel.selectedBookingPayment?.toJson()}");
      });
    });

    tabChildrenWidgets[SalesHistoryType.VOID] =
        VoidSalesWidget(onVoided: (sale) {
      setState(() {
        titleInPrintReceipt = "Voided Sale";
        saleHistoryDataModel.selectedSale = sale;
        showReturnButton = false;
        saleHistoryDataModel.selectedBookingPayment = null;
        _showVoidSale = false;
      });
    });

    tabChildrenWidgets[SalesHistoryType.OFFLINE_SALES] =
        OfflineSalesWidget(onSelected: (sale) {
      setState(() {
        titleInPrintReceipt = "";
        if (isLayawaySale(sale)) {
          titleInPrintReceipt = "Layaway Sale";
        }
        // when sale is selected from the list, check if its updated sale is
        // already available in the sale detail widget using inherited widget.
        // This is because to avoid reloading of entire sale page to just get updated sale in detail page.
        // Anyways, updated sale will be available in sale detail page.
        var updatedSale = saleHistoryDataModel.updatedSaleMap[sale.id];
        if (updatedSale != null) {
          saleHistoryDataModel.selectedSale = updatedSale;
        } else {
          saleHistoryDataModel.selectedSale = sale;
        }

        showReturnButton = false;
        _showVoidSale = false;
        saleHistoryDataModel.selectedBookingPayment = null;
      });
    });
  }

  void _populateTabs() {
    tabWidgets[SalesHistoryType.REGULAR] = const Tab(
      text: 'Regular & Completed Layaway Sales',
    );
    tabWidgets[SalesHistoryType.SALE_RETURNS] = const Tab(
      text: 'Sale Returns',
    );

    tabWidgets[SalesHistoryType.LAYAWAY] = const Tab(
      text: 'Pending Layaway Sales',
    );

    tabWidgets[SalesHistoryType.BOOKING_PAYMENT] = const Tab(
      text: 'Booking Payments',
    );

    tabWidgets[SalesHistoryType.VOID] = const Tab(
      text: 'Void Sales',
    );

    tabWidgets[SalesHistoryType.OFFLINE_SALES] = const Tab(
      text: 'Offline Sales',
    );
  }

  Widget rootWidget() {
    List<Widget> widgets = List.empty(growable: true);

    // Tab children view
    widgets.add(
      Expanded(flex: 5, child: mainWidget(context)),
    );

    //Detail View
    if (saleHistoryDataModel.selectedSale != null) {
      widgets.add(Expanded(
          flex: 3,
          child: RegularSalesDetailWidget(
            titleInPrintReceipt: titleInPrintReceipt,
            showVoidSale: _showVoidSale,
            showReturnButton: showReturnButton,
            proceedToSaleReturns: widget.proceedToSaleReturns,
            refreshWidgetsWithSale: (updatedSale) {
              setState(() {
                saleHistoryDataModel.updatedSaleMap[updatedSale.id] =
                    updatedSale;

                saleHistoryDataModel.selectedSale = updatedSale;
                saleHistoryDataModel.refreshLayawaySales = true;
                saleHistoryDataModel.refreshRegularSales = true;
              });
            },
            refreshWidgetWithPendingLayawaySales: () {
              setState(() {
                tabChildrenWidgets[SalesHistoryType.LAYAWAY] = Expanded(
                    child: Container(
                  color: Colors.white,
                ));

                saleHistoryDataModel.selectedSale = null;
                Timer(const Duration(milliseconds: 20), () {
                  setState(() {
                    tabChildrenWidgets[SalesHistoryType.LAYAWAY] =
                        LayawaySalesWidget(onSelected: (sale) {
                      setState(() {
                        titleInPrintReceipt = "Pending Layaway Sale";
                        var updatedSale =
                            saleHistoryDataModel.updatedSaleMap[sale.id];
                        if (updatedSale != null) {
                          saleHistoryDataModel.selectedSale = updatedSale;
                        } else {
                          saleHistoryDataModel.selectedSale = sale;
                        }

                        showReturnButton = false;
                        _showVoidSale = false;
                        saleHistoryDataModel.selectedBookingPayment = null;
                      });
                    });
                  });
                });
              });
            },
          )));
    }

    if (saleHistoryDataModel.selectedBookingPayment != null) {
      widgets.add(Expanded(
          flex: 3,
          child: BookingPaymentDetailWidget(
              selectedBookingPayment:
                  saleHistoryDataModel.selectedBookingPayment!,
              resetProductsInBookingPayments: widget.resetProductsInBookingPayments,
              refreshWidget: () {
                setState(() {
                  tabChildrenWidgets[SalesHistoryType.BOOKING_PAYMENT] =
                      Container();

                  // saleHistoryDataModel.selectedBookingPayment = null;
                  Future.delayed(const Duration(milliseconds: 10), () {
                    // Here you can write your code
                    setState(() {
                      tabChildrenWidgets[SalesHistoryType.BOOKING_PAYMENT] =
                          BookingPaymentWidget(
                              onBookingPaymentSelected: (sale) {
                        setState(() {
                          MyLogUtils.logDebug(
                              "BookingPaymentWidget sale  : ${sale.toJson()}");
                          titleInPrintReceipt = "Booking Payment";
                          saleHistoryDataModel.selectedSale = null;
                          showReturnButton = false;
                          saleHistoryDataModel.selectedBookingPayment = sale;
                          _showVoidSale = false;

                          MyLogUtils.logDebug(
                              "BookingPaymentWidget saleHistoryDataModel"
                              ".selectedBookingPayment  : ${saleHistoryDataModel.selectedBookingPayment?.toJson()}");
                        });
                      });
                    });
                  });
                });
              })));
    }

    if (saleHistoryDataModel.selectedSale == null &&
        saleHistoryDataModel.selectedBookingPayment == null) {
      widgets.add(Expanded(
          flex: 3,
          child: Card(
              child: Center(
            child: Text(
              "Select a sale to view in detail",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ))));
    }

    return Container(
        margin: const EdgeInsets.all(5.0),
        child: Row(
          children: widgets,
        ));
  }

  Widget mainWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        tabBarWidget(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: List.from(tabChildrenWidgets.values),
          ),
        )
      ],
    );
  }

  Widget tabBarWidget() {
    return Container(
      color: getWhiteColor(context),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
      child: TabBar(
          isScrollable: true,
          // give the indicator a decoration (color and border radius)
          controller: _tabController,
          labelStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
          unselectedLabelStyle: TextStyle(
              fontSize: 13,
              color: Theme.of(context).primaryColor.withOpacity(0.4)),
          indicator: ShapeDecoration(
            shape: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1,
                    style: BorderStyle.solid)),
          ),
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Theme.of(context).primaryColor.withOpacity(0.6),
          tabs: List.from(tabWidgets.values)),
    );
  }
}
