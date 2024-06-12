import 'package:flutter/material.dart';
import 'package:jakel_base/constants.dart';
import 'package:jakel_base/database/offlinedata/cashmovement/CashMovementRequest.dart';
import 'package:jakel_base/jakel_base.dart';
import 'package:jakel_base/restapi/counters/model/CloseCounterRequest.dart';
import 'package:jakel_base/restapi/counters/model/OpenCounterRequest.dart';
import 'package:jakel_base/restapi/sales/model/history/SalesResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/custom/MyLeftRightWidget.dart';
import 'package:jakel_base/widgets/errorwidget/MyErrorWidget.dart';

import '../../../../routing/route_names.dart';
import '../../LocalCountersViewModel.dart';

class LocalCounterInfoWidget extends StatefulWidget {
  final OpenCounterRequest counterRequest;

  const LocalCounterInfoWidget({Key? key, required this.counterRequest})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LocalCounterInfoWidgetState();
  }
}

class _LocalCounterInfoWidgetState extends State<LocalCounterInfoWidget> {
  final viewModel = LocalCountersViewModel();
  CloseCounterRequest? closeCounterRequest;
  List<Sales>? sales;
  List<Sales>? notSyncedSales;
  List<CashMovementRequest>? notSyncedCashMovements;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: 430, width: double.infinity, child: counterInfoApiWidget()),
        const SizedBox(
          height: 10,
        ),
        const Expanded(child: Card())
      ],
    );
  }

  Widget counterInfoApiWidget() {
    return FutureBuilder(
        future: viewModel
            .getClosedCounter(widget.counterRequest.openedByPosAt ?? ''),
        builder: (BuildContext context,
            AsyncSnapshot<CloseCounterRequest?> snapshot) {
          if (snapshot.hasError) {
            closeCounterRequest = null;
            return MyErrorWidget(
                message: "Failed to fetch data. Please try again later!",
                tryAgain: () {
                  setState(() {});
                });
          }
          MyLogUtils.logDebug("snapshot.hasData : ${snapshot.hasData}");
          if (snapshot.hasData) {
            closeCounterRequest = snapshot.data;
            return getSalesInfoApi();
          }
          return const Text("Loading ...");
        });
  }

  Widget getSalesInfoApi() {
    return FutureBuilder(
        future:
            viewModel.getSalesData(widget.counterRequest.openedByPosAt ?? ''),
        builder: (BuildContext context, AsyncSnapshot<List<Sales>> snapshot) {
          if (snapshot.hasError) {
            sales = null;
            return MyErrorWidget(
                message: "Failed to fetch data. Please try again later!",
                tryAgain: () {
                  setState(() {});
                });
          }
          if (snapshot.hasData) {
            sales = snapshot.data;
            return getNotSyncedSalesInfoApi();
          }
          return const Text("Loading ...");
        });
  }

  Widget getNotSyncedSalesInfoApi() {
    return FutureBuilder(
        future: viewModel.getNotSyncedSalesForThisShift(
            widget.counterRequest.openedByPosAt ?? ''),
        builder: (BuildContext context, AsyncSnapshot<List<Sales>> snapshot) {
          if (snapshot.hasError) {
            sales = null;
            return MyErrorWidget(
                message: "Failed to fetch data. Please try again later!",
                tryAgain: () {
                  setState(() {});
                });
          }
          if (snapshot.hasData) {
            notSyncedSales = snapshot.data;
            return getCashMovementData();
          }
          return const Text("Loading ...");
        });
  }

  Widget getCashMovementData() {
    return FutureBuilder(
        future: viewModel.getNotSyncedCashMovements(
            widget.counterRequest.openedByPosAt ?? ''),
        builder: (BuildContext context,
            AsyncSnapshot<List<CashMovementRequest>> snapshot) {
          if (snapshot.hasError) {
            sales = null;
            return MyErrorWidget(
                message: "Failed to fetch data. Please try again later!",
                tryAgain: () {
                  setState(() {});
                });
          }
          if (snapshot.hasData) {
            notSyncedCashMovements = snapshot.data;
            return counterInfoWidget();
          }
          return const Text("Loading ...");
        });
  }

  Widget counterInfoWidget() {
    return Card(
        child: Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          closeCounterNotSynced(),
          const SizedBox(
            height: 15,
          ),
          openNewCounter(),
          const Divider(),
          MyLeftRightWidget(
              lText: 'Opening At',
              rText: widget.counterRequest.openedByPosAt ?? ''),
          const Divider(),
          MyLeftRightWidget(
              lText: 'Opening Balance',
              rText: getReadableAmount(
                  getCurrency(), widget.counterRequest.openingBalance)),
          const Divider(),
          MyLeftRightWidget(lText: 'Total Sales', rText: '${sales?.length}'),
          const Divider(),
          MyLeftRightWidget(
              lText: 'Not Synced Sales', rText: '${notSyncedSales?.length}'),
          const Divider(),
          MyLeftRightWidget(
              lText: 'Not Synced Cash Movements',
              rText: '${notSyncedCashMovements?.length}'),
          const Divider(),
          MyLeftRightWidget(
              lText: 'Counter Status',
              rText: widget.counterRequest.closedByPosAt == null
                  ? 'Not Closed'
                  : 'Closed'),
          const Divider(),
          MyLeftRightWidget(
              lText: 'Closed at',
              rText: closeCounterRequest?.closedByPosAt ?? noData),
          const Divider(),
          MyLeftRightWidget(
            lText: 'Open Counter Synced To Cloud',
            rText: widget.counterRequest.isSyncedToCloud == true ? 'Yes' : 'NO',
            rStyle: widget.counterRequest.isSyncedToCloud == true
                ? const TextStyle(
                    color: Colors.green, fontWeight: FontWeight.bold)
                : const TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          MyLeftRightWidget(
            lText: 'Close Counter Data Synced To Cloud',
            rText: closeCounterRequest == null ? 'Yes' : 'NO',
            rStyle: closeCounterRequest == null
                ? const TextStyle(
                    color: Colors.green, fontWeight: FontWeight.bold)
                : const TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ));
  }

  Widget closeCounterNotSynced() {
    if (isCounterClosedAndNotSynced()) {
      return const Text(
        "Previous close counter data is not synced to cloud.\n"
        "Please make sure to sync this data to cloud by connecting to valid network.Click refresh to check status.\n"
        "Would you like to open counter in offline ?",
        style: TextStyle(color: Colors.redAccent),
      );
    }

    return Container();
  }

  Widget openNewCounter() {
    if (isCounterClosedAndNotSynced()) {
      return MyOutlineButton(
          text: "Open Counter In Offline Mode",
          onClick: () {
            Navigator.pushNamed(context, OpenCounterRoute);
          });
    }

    return Container();
  }

  bool isCounterClosedAndNotSynced() {
    return widget.counterRequest.closedByPosAt != null &&
        closeCounterRequest != null;
  }
}
