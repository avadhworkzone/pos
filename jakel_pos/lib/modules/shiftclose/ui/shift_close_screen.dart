import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/counters/model/CloseCounterRequest.dart';
import 'package:jakel_base/restapi/counters/model/ShiftDetailsResponse.dart';
import 'package:jakel_base/restapi/managers/model/StoreManagersResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:jakel_base/widgets/appbgwidget/MyBackgroundWidget.dart';
import 'package:jakel_base/widgets/errorwidget/MyErrorWidget.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_pos/modules/offline/synctoserver/OfflineSyncingViewModel.dart';
import 'package:jakel_pos/modules/shiftclose/ShiftCloseViewModel.dart';
import 'package:jakel_pos/modules/shiftclose/model/ShiftCloseDeclarationModel.dart';
import 'package:jakel_pos/modules/shiftclose/ui/widgets/denominations_widget.dart';
import 'package:jakel_pos/modules/shiftclose/ui/widgets/shift_close_inherited_widget.dart';
import 'package:jakel_pos/modules/shiftclose/ui/widgets/shift_details_widget.dart';

import '../../newsale/NewSaleViewModel.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';

class ShiftCloseScreen extends StatefulWidget {
  const ShiftCloseScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ShiftCloseScreenState();
  }
}

class _ShiftCloseScreenState extends State<ShiftCloseScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  final viewModel = ShiftCloseViewModel();

  ShiftDetailsResponse? response;

  var declaration = ShiftCloseDeclarationModel(isDeclarationDone: false);
  final saleViewModel = NewSaleViewModel();
  final offlineSyncingViewModel = OfflineSyncingViewModel();

  int totalOnHoldSales = 0;
  int totalOfflineSales = 0;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    viewModel.getShiftClosingDetails();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MyBackgroundWidget(
            child: ShiftCloseInheritedWidget(
      shiftDeclaration: declaration,
      child: apiWidget(),
    )));
  }

  Widget apiWidget() {
    return StreamBuilder<ShiftDetailsResponse>(
      stream: viewModel.responseSubject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyLoadingWidget();
        }
        if (snapshot.hasError) {
          MyLogUtils.logDebug("apiWidget hasError");
          return MyErrorWidget(
              message: "Error.Please try again!",
              tryAgain: () {
                setState(() {
                  viewModel.getShiftClosingDetails();
                });
              });
        }
        if (snapshot.connectionState == ConnectionState.active) {
          var responseData = snapshot.data;
          if (responseData != null &&
              responseData.counterClosingDetails != null) {
            response = responseData;
            return getOnHoldSales();
          } else {
            return MyErrorWidget(
                message: "Error.Please try again!",
                tryAgain: () {
                  setState(() {
                    viewModel.getShiftClosingDetails();
                  });
                });
          }
        }
        return Container();
      },
    );
  }

  Widget getOnHoldSales() {
    return FutureBuilder(
        future: saleViewModel.getAllOnHoldSales(),
        builder:
            (BuildContext context, AsyncSnapshot<List<CartSummary>> snapshot) {
          if (snapshot.hasError) {
            MyLogUtils.logDebug("snapshot.hasError : ${snapshot.hasError}");
            return Container();
          }
          if (snapshot.hasData) {
            if (snapshot.data != null && snapshot.data!.isNotEmpty) {
              totalOnHoldSales = snapshot.data!.length;
            }
            return getOfflineSales();
          }
          return Container();
        });
  }

  Widget getOfflineSales() {
    return FutureBuilder(
        future: offlineSyncingViewModel.getAllOfflineSales(),
        builder:
            (BuildContext context, AsyncSnapshot<List<CartSummary>> snapshot) {
          if (snapshot.hasError) {
            MyLogUtils.logDebug("snapshot.hasError : ${snapshot.hasError}");
            return Container();
          }
          if (snapshot.hasData) {
            if (snapshot.data != null && snapshot.data!.isNotEmpty) {
              totalOfflineSales = snapshot.data!.length;
            }
            return rootWidget();
          }
          return Container();
        });
  }

  Widget rootWidget() {
    declaration.closingDetails = response?.counterClosingDetails;

    if (declaration.paymentDeclaration == null) {
      declaration.paymentDeclaration = HashMap();
      declaration.closingDetails?.payments?.forEach((element) {
        if (element.paymentTypeId != bookingPaymentId &&
            element.paymentTypeId != creditNotePaymentId &&
            element.paymentTypeId != loyaltyPointPaymentId) {
          declaration.paymentDeclaration?[element.paymentTypeId ?? 0] = 0.0;
        }
      });
    }

    List<Widget> widgets = List.empty(growable: true);
    // Tab children view
    widgets.add(
      Expanded(
          flex: 5,
          child: Card(
            child: Container(
              padding: const EdgeInsets.all(5.0),
              constraints: const BoxConstraints.expand(),
              child: ShiftDetailsWidget(
                  isHoldSalesAvailable: totalOnHoldSales > 0,
                  onStoreManagerSelected: _selectStoreManager,
                  counter: response!.counterClosingDetails!,
                  onRemoveDeclaration: _removeDeclaration,
                  onDeclarationUpdated: _onDeclarationUpdated,
                  printDeclaration: _printDeclaration,
                  onDeclarationDone: _onDeclarationDone),
            ),
          )),
    );

    //Detail View
    widgets.add(Expanded(
        flex: 3,
        child: Card(
          child: totalOnHoldSales > 0
              ? const Center(
                  child: Text(
                      "Please clear hold sales to proceed with declaration."),
                )
              : DenominationsWidget(
                  counter: response!.counterClosingDetails!,
                  updateEnteredCash: _updateEnteredCash),
        )));

    return Container(
        margin: const EdgeInsets.all(5.0),
        child: Row(
          children: widgets,
        ));
  }

  void _onDeclarationDone() {
    try {
      setState(() {
        declaration.isDeclarationDone = true;
        declaration.paymentMismatch = false;

        // 1. First check all the payment types except for static payment types.
        declaration.closingDetails?.payments?.forEach((element) {
          if (element.paymentTypeId != bookingPaymentId &&
              element.paymentTypeId != creditNotePaymentId &&
              element.paymentTypeId != loyaltyPointPaymentId &&
              element.paymentTypeId != cashPaymentId) {
            MyLogUtils.logDebug(
                "_onDeclarationDone payment expected : ${element.total}");

            MyLogUtils.logDebug(
                "_onDeclarationDone payment declaration : ${declaration.paymentDeclaration?[element.paymentTypeId] ?? 0.0}");

            if (element.total !=
                (declaration.paymentDeclaration?[element.paymentTypeId] ??
                    0.0)) {
              declaration.paymentMismatch = true;
            }
          }
        });

        MyLogUtils.logDebug(
            "_onDeclarationDone Payment Mismatch for non static payment types: ${declaration.paymentMismatch}");

        // If paymentMismatch is true for other payments, no need to check cash
        // If paymentMismatch is false for other payments, check for cash payment
        if (!(declaration.paymentMismatch ?? false)) {
          // Check for cash payment
          double expectedCash =
              viewModel.getExpectedCash(declaration.closingDetails!);

          MyLogUtils.logDebug(
              "_onDeclarationDone expectedCash : $expectedCash");

          double declaredCash =
              declaration.paymentDeclaration?[cashPaymentId] ?? 0.0;

          MyLogUtils.logDebug(
              "_onDeclarationDone declaredCash : $expectedCash");

          if (expectedCash - declaredCash > 0) {
            declaration.paymentMismatch = true;
          }
        }
        MyLogUtils.logDebug(
            "_onDeclarationDone Payment Mismatch for cash : ${declaration.paymentMismatch}");
      });
      _printDeclaration();
    } on Exception catch (e) {
      MyLogUtils.logDebug("Exception :$e");
    }
  }

  void _printDeclaration() {
    viewModel.updatePrintReceiptDeclaration(
      "Cashier Declaration",
      declaration.closingDetails!,
      declaration.denominations ?? [],
      declaration.paymentDeclaration!,
    );
  }

  void _onDeclarationUpdated(HashMap<int, double> paymentDeclared) {
    setState(() {
      declaration.paymentDeclaration = paymentDeclared;

      MyLogUtils.logDebug("paymentDeclared : $paymentDeclared");
      MyLogUtils.logDebug(
          " declaration.paymentDeclaration : ${declaration.paymentDeclaration}");
    });
  }

  void _removeDeclaration() {
    setState(() {
      declaration.isDeclarationDone = false;
    });
  }

  void _updateEnteredCash(
      List<Denominations> denominations, double totalCashAmount) {
    MyLogUtils.logDebug("_updateEnteredCash : $totalCashAmount");

    setState(() {
      declaration.paymentDeclaration?[cashPaymentId] = totalCashAmount;
      declaration.denominations = denominations;
    });
  }

  void _selectStoreManager(StoreManagers storeManagers) {
    setState(() {
      declaration.storeManagers = storeManagers;
    });
  }
}
