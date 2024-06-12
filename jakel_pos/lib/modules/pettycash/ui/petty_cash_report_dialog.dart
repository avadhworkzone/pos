import 'package:flutter/material.dart';
import 'package:jakel_base/jakel_base.dart';
import 'package:jakel_base/restapi/pettycash/model/PettyCashUsagesResponse.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';
import 'package:jakel_base/widgets/custom/MyPaginationWidget.dart';
import 'package:jakel_base/widgets/errorwidget/MyErrorWidget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_base/widgets/nodatawidget/NoDataWidget.dart';

import '../PettyCashViewModel.dart';

class PettyCashReportDialog extends StatefulWidget {
  final bool showAsDialog;

  const PettyCashReportDialog({
    Key? key,
    required this.showAsDialog,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PettyCashReportDialogState();
  }
}

class _PettyCashReportDialogState extends State<PettyCashReportDialog> {
  int pageNo = 1;
  int perPage = 10;
  List<PettyCashUsages>? sales;
  final viewModel = PettyCashViewModel();
  PettyCashUsagesResponse? salesResponse;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() {
    viewModel.getPettyCashUsages(pageNo, perPage);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showAsDialog) {
      return getRootWidget();
    }
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.7,
          child: MyDataContainerWidget(
            child: getRootWidget(),
          ),
        ));
  }

  Widget getRootWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: getChildren(),
    );
  }

  List<Widget> getChildren() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(getHeader());

    widgets.add(const SizedBox(
      height: 10,
    ));
    widgets.add(const Divider());

    widgets.add(Expanded(
      child: apiWidget(),
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));
    return widgets;
  }

  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Petty cash usage report",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        widget.showAsDialog
            ? MyInkWellWidget(
                child: const Icon(Icons.close),
                onTap: () {
                  Navigator.pop(context);
                })
            : SizedBox()
      ],
    );
  }

  Widget apiWidget() {
    return StreamBuilder<PettyCashUsagesResponse>(
      stream: viewModel.usageResponseSubject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          MyLogUtils.logDebug("apiWidget waiting");
          return const MyLoadingWidget();
        }
        if (snapshot.hasError) {
          MyLogUtils.logDebug("apiWidget hasError");
          return MyErrorWidget(
              message: "Error.Please try again!",
              tryAgain: () {
                _getData();
              });
        }
        if (snapshot.connectionState == ConnectionState.active) {
          var responseData = snapshot.data;
          if (responseData != null && responseData.pettyCashUsages != null) {
            salesResponse = responseData;
            sales = responseData.pettyCashUsages;
            return showSalesList();
          } else {
            return MyErrorWidget(
                message: "Error.Please try again!",
                tryAgain: () {
                  _getData();
                });
          }
        }
        return Container();
      },
    );
  }

  Widget showSalesList() {
    if (sales == null || sales!.isEmpty) {
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
            child: showSales(sales!),
          ),
        ),
        getPageController()
      ],
    );
  }

  Widget getPageController() {
    if (salesResponse == null || salesResponse?.currentPage == null) {
      return Container();
    }

    return Card(
      child: MyPaginationWidget(
        onPageSelected: (page) {
          setState(() {
            pageNo = page;
            _getData();
          });
        },
        perPage: salesResponse!.perPage!,
        currentPage: salesResponse!.currentPage!,
        lastPage: salesResponse!.lastPage!,
        totalCount: salesResponse!.totalRecords!,
        totalPages: salesResponse!.lastPage!,
      ),
    );
  }

  Widget showSales(List<PettyCashUsages> salesList) {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: FittedBox(
          child: tableWidget(salesList),
        ),
      ),
    );
  }

  Widget tableWidget(List<PettyCashUsages> filteredLists) {
    return DataTable(
      horizontalMargin: 10,
      dividerThickness: 0.0,
      showCheckboxColumn: false,
      headingRowColor: MaterialStateColor.resolveWith(
          (states) => Theme.of(context).colorScheme.tertiaryContainer),
      headingTextStyle: Theme.of(context).textTheme.subtitle1,
      columns: <DataColumn>[
        DataColumn(
          label: Text('ID', style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataColumn(
          label: Text('Reason', style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataColumn(
          label:
              Text('Date Time', style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataColumn(
          numeric: true,
          label: Text('Amount', style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
      rows: getDtaRows(filteredLists),
    );
  }

  List<DataRow> getDtaRows(List<PettyCashUsages> filteredLists) {
    List<DataRow> dataRows = List.empty(growable: true);
    int index = 0;
    for (PettyCashUsages sale in filteredLists) {
      index += 1;
      Color color =
          (index % 2 == 0) ? getWhiteColor(context) : getWhiteColor(context);

      dataRows.add(
        DataRow(
          color: MaterialStateColor.resolveWith((states) {
            return color;
          }),
          onSelectChanged: (value) async {},
          cells: <DataCell>[
            DataCell(Align(
              alignment: Alignment.centerLeft,
              child: Text("${sale.id}",
                  style: Theme.of(context).textTheme.bodySmall),
            )),
            DataCell(
              Align(
                alignment: Alignment.centerLeft,
                child: Text(sale.reason ?? '',
                    style: Theme.of(context).textTheme.bodySmall),
              ),
            ),
            DataCell(
              Align(
                alignment: Alignment.centerLeft,
                child: Text(sale.createdAt ?? "",
                    style: Theme.of(context).textTheme.bodySmall),
              ),
            ),
            DataCell(
              Text(getReadableAmount(getCurrency(), sale.amount),
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          ],
        ),
      );
    }
    return dataRows;
  }
}
