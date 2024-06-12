import 'package:flutter/material.dart';
import 'package:jakel_base/jakel_base.dart';
import 'package:jakel_base/restapi/counters/model/ClosedCountesrHistoryResponse.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/custom/MyPaginationWidget.dart';
import 'package:jakel_base/widgets/errorwidget/MyErrorWidget.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_base/widgets/nodatawidget/NoDataWidget.dart';

import '../../ClosedCountersHistoryViewModel.dart';

class ClosedCountersHistoryWidget extends StatefulWidget {
  final Function onSelected;

  const ClosedCountersHistoryWidget({Key? key, required this.onSelected})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ClosedCountersHistoryWidgetState();
  }
}

class _ClosedCountersHistoryWidgetState
    extends State<ClosedCountersHistoryWidget> {
  final viewModel = ClosedCountersHistoryViewModel();
  int pageNo = 1;
  int perPage = 20;
  List<ClosedCounter>? closedCounters;
  ClosedCountersHistoryResponse? countersResponse;
  ClosedCounter? _selected;
  final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();
  void _getData() {
    viewModel.getClosedCountersHistory(pageNo, perPage);
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints.expand(),
        padding: const EdgeInsets.all(4.0),
        child: apiWidget());
  }

  Widget apiWidget() {
    return StreamBuilder<ClosedCountersHistoryResponse>(
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
          if (responseData != null && responseData.closedCounter != null) {
            countersResponse = responseData;
            closedCounters = responseData.closedCounter;
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
    if (closedCounters == null || closedCounters!.isEmpty) {
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
            child: showSales(closedCounters!),
          ),
        ),
        getPageController()
      ],
    );
  }

  Widget getPageController() {
    if (countersResponse == null || countersResponse?.currentPage == null) {
      return Container();
    }

    return Card(
      child: MyPaginationWidget(
        onPageSelected: (page) {
          setState(() {
            MyLogUtils.logDebug("MyPaginationWidget page => $page");
            pageNo = page;
            _getData();
          });
        },
        perPage: countersResponse!.perPage!,
        currentPage: countersResponse!.currentPage!,
        lastPage: countersResponse!.lastPage!,
        totalCount: countersResponse!.totalRecords!,
        totalPages: countersResponse!.lastPage!,
      ),
    );
  }

  Widget showSales(List<ClosedCounter> salesList) {
    return Card(
      child:   Scrollbar(
        controller: _vertical,
        thumbVisibility: true,
        child: Scrollbar(
          controller: _horizontal,
          thumbVisibility: true,
          notificationPredicate: (notif) => notif.depth == 1,
          child: SingleChildScrollView(
            controller: _vertical,
            child: SingleChildScrollView(
              controller: _horizontal,
              scrollDirection: Axis.horizontal,
              child: tableWidget(salesList),
            ),
          ),
        ),
      )
    );
  }

  Widget tableWidget(List<ClosedCounter> filteredLists) {
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
          numeric: true,
          label: Text('Opening Balance',
              style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataColumn(
          numeric: true,
          label: Text('Closing Balance',
              style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataColumn(
          label:
              Text('Opened At', style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataColumn(
          label:
              Text('Closed At', style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataColumn(
          numeric: true,
          label: Text('Mismatch Amount',
              style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
      rows: getDtaRows(filteredLists),
    );
  }

  List<DataRow> getDtaRows(List<ClosedCounter> filteredLists) {
    List<DataRow> dataRows = List.empty(growable: true);
    int index = 0;
    for (ClosedCounter sale in filteredLists) {
      index += 1;
      Color color =
          (index % 2 == 0) ? getWhiteColor(context) : getWhiteColor(context);

      if (_selected != null && sale.id == _selected?.id) {
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
              child: Text("${index + ((pageNo - 1) * perPage)}.",
                  style: Theme.of(context).textTheme.bodyMedium),
            )),
            DataCell(Align(
              alignment: Alignment.centerLeft,
              child: Text("${sale.id}",
                  style: Theme.of(context).textTheme.bodyMedium),
            )),
            DataCell(Align(
              alignment: Alignment.centerLeft,
              child: Text("${sale.counter?.name}",
                  style: Theme.of(context).textTheme.bodyMedium),
            )),
            DataCell(
              Text(getReadableAmount(getCurrency(), sale.openingBalance ?? 0),
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
            DataCell(
              Text(getReadableAmount(getCurrency(), sale.closingBalance ?? 0),
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
            DataCell(
              Text('${sale.openedAt}',
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
            DataCell(
              Text('${sale.closedAt}',
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
            DataCell(
              Text(getReadableAmount(getCurrency(), sale.mismatchAmount ?? 0),
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
          ],
        ),
      );
    }
    return dataRows;
  }
}
