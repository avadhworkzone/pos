import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/counters/model/PaymentDeclarationAttemptsResponse.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/widgets/errorwidget/MyErrorWidget.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_base/widgets/nodatawidget/NoDataWidget.dart';

import '../PaymentDeclarationAttemptsViewModel.dart';

class PaymentDeclarationAttemptsListWidget extends StatefulWidget {
  final Function onSelected;

  const PaymentDeclarationAttemptsListWidget(
      {Key? key, required this.onSelected})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PaymentDeclarationAttemptsListWidgetState();
  }
}

class _PaymentDeclarationAttemptsListWidgetState
    extends State<PaymentDeclarationAttemptsListWidget> {
  final viewModel = PaymentDeclarationAttemptsViewModel();

  List<CounterUpdateDeclarationAttempts>? attemptsList;
  CounterUpdateDeclarationAttempts? _selected;

  void _getData() {
    viewModel.getPaymentDeclarationAttempt();
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints.expand(), child: apiWidget());
  }

  Widget apiWidget() {
    return StreamBuilder<PaymentDeclarationAttemptsResponse>(
      stream: viewModel.responseSubject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          MyLogUtils.logDebug("apiWidget waiting");
          return const MyLoadingWidget();
        }
        if (snapshot.hasError) {
          MyLogUtils.logDebug("apiWidget hasError");
          return MyErrorWidget(
              message: "Error.Please try again!", tryAgain: _getData);
        }
        if (snapshot.connectionState == ConnectionState.active) {
          var responseData = snapshot.data;
          if (responseData != null &&
              responseData.counterUpdateDeclarationAttempts != null) {
            attemptsList = responseData.counterUpdateDeclarationAttempts;
            return showSalesList();
          } else {
            return MyErrorWidget(
                message: "Error.Please try again!", tryAgain: _getData);
          }
        }
        return Container();
      },
    );
  }

  Widget showSalesList() {
    if (attemptsList == null || attemptsList!.isEmpty) {
      return const NoDataWidget();
    }
    return Container(
      constraints: const BoxConstraints.expand(),
      child: listWidget(),
    );
  }

  Widget listWidget() {
    return Column(
      children: [
        Expanded(
          child: Container(
            constraints: const BoxConstraints.expand(),
            child: showSales(attemptsList!),
          ),
        ),
      ],
    );
  }

  Widget showSales(List<CounterUpdateDeclarationAttempts> salesList) {
    return Card(
        child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: tableWidget(salesList),
    ));
  }

  Widget tableWidget(List<CounterUpdateDeclarationAttempts> filteredLists) {
    return DataTable(
      horizontalMargin: 10,
      dividerThickness: 0.0,
      showCheckboxColumn: false,
      headingRowColor: MaterialStateColor.resolveWith(
          (states) => Theme.of(context).colorScheme.tertiaryContainer),
      headingTextStyle: Theme.of(context).textTheme.subtitle1,
      columns: <DataColumn>[
        DataColumn(
          label: Text('#', style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataColumn(
          label: Text('Id', style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataColumn(
          label: Text('Counter Name',
              style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataColumn(
          label: Text('Date & Time',
              style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
      rows: getDtaRows(filteredLists),
    );
  }

  List<DataRow> getDtaRows(
      List<CounterUpdateDeclarationAttempts> filteredLists) {
    List<DataRow> dataRows = List.empty(growable: true);
    int index = 0;
    for (CounterUpdateDeclarationAttempts sale in filteredLists) {
      index += 1;
      Color color =
          (index % 2 == 0) ? getWhiteColor(context) : getWhiteColor(context);

      if (_selected != null && sale.offlineId == _selected?.offlineId) {
        color = Theme.of(context).colorScheme.onPrimaryContainer;
      }

      dataRows.add(
        DataRow(
          color: MaterialStateColor.resolveWith((states) {
            return color;
          }),
          onSelectChanged: (value) async {
            setState(() {
              _selected = sale;
              widget.onSelected(_selected);
            });
          },
          cells: <DataCell>[
            DataCell(Align(
              alignment: Alignment.centerLeft,
              child: Text("${index}.",
                  style: Theme.of(context).textTheme.bodyMedium),
            )),
            DataCell(Align(
              alignment: Alignment.centerLeft,
              child: Text("${sale.offlineId}",
                  style: Theme.of(context).textTheme.bodyMedium),
            )),
            DataCell(Align(
              alignment: Alignment.centerLeft,
              child: Text("${sale.counterName}",
                  style: Theme.of(context).textTheme.bodyMedium),
            )),
            DataCell(
              Text('${sale.happenedAt}',
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
          ],
        ),
      );
    }
    return dataRows;
  }
}
