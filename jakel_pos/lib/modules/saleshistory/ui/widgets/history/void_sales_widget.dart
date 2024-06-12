import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jakel_base/restapi/sales/model/history/SalesResponse.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/my_date_utils.dart';
import 'package:jakel_base/widgets/custom/MyPaginationWidget.dart';
import 'package:jakel_base/widgets/date/SelectDateRangeDialog.dart';
import 'package:jakel_base/widgets/errorwidget/MyErrorWidget.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_base/widgets/nodatawidget/NoDataWidget.dart';
import 'package:jakel_pos/modules/saleshistory/SalesHistoryViewModel.dart';
import 'package:jakel_pos/modules/utils/scroll_bar_utils.dart';

class VoidSalesWidget extends StatefulWidget {
  final Function onVoided;

  const VoidSalesWidget({Key? key, required this.onVoided}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VoidSalesWidgetState();
  }
}

class _VoidSalesWidgetState extends State<VoidSalesWidget> {
  final viewModel = SalesHistoryViewModel();
  final searchController = TextEditingController();
  final searchNode = FocusNode();
  String? searchText;
  int pageNo = 1;
  int perPage = 20;
  List<Sales>? sales;
  DateTime? fromDate, toDate;
  String? dateRangeText;
  String? filter;
  SalesResponse? salesResponse;
  Sales? selectedSale;

  final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();

  @override
  void initState() {
    super.initState();
    _getSales();
  }

  void _getSales() {
    viewModel.getVoidSales(pageNo, perPage, 0, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          searchWidget(),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: apiWidget(),
          )
        ],
      ),
    );
  }

  Widget apiWidget() {
    return StreamBuilder<SalesResponse>(
      stream: viewModel.responseSubject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          MyLogUtils.logDebug("apiWidget waiting");
          return const MyLoadingWidget();
        }
        if (snapshot.hasError) {
          MyLogUtils.logDebug("apiWidget hasError");
          return MyErrorWidget(
              message: "Error.Please try again!", tryAgain: _getSales);
        }
        if (snapshot.connectionState == ConnectionState.active) {
          var responseData = snapshot.data;
          if (responseData != null && responseData.sales != null) {
            salesResponse = responseData;
            sales = responseData.sales;
            return showSalesList();
          } else {
            return MyErrorWidget(
                message: "Error.Please try again!", tryAgain: _getSales);
          }
        }
        return Container();
      },
    );
  }

  Widget searchWidget() {
    return Container();
    // Commented Search widget for now.
    return Card(
      child: Container(
        margin: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: TextField(
                  controller: searchController,
                  focusNode: searchNode,
                  onSubmitted: (text) {},
                  style: const TextStyle(fontSize: 14, color: Colors.black45),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.only(left: 10.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor, width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor, width: 0.5),
                      ),
                      prefixIcon: InkWell(
                        child: Container(
                          width: 50,
                          height: 50,
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.all(0.5),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5)),
                              color: Theme.of(context)
                                  .colorScheme
                                  .tertiaryContainer,
                              border: Border.all(
                                  width: 0.1,
                                  color: Theme.of(context).dividerColor)),
                          child: Icon(
                            Icons.search_outlined,
                            color: Theme.of(context).indicatorColor,
                          ),
                        ),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            searchController.text = "";
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          padding: const EdgeInsets.all(0.5),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(5)),
                              color: Theme.of(context)
                                  .colorScheme
                                  .tertiaryContainer,
                              border: Border.all(
                                  width: 0.1,
                                  color: Theme.of(context).dividerColor)),
                          child: Icon(
                            Icons.clear,
                            color: Theme.of(context).indicatorColor,
                          ),
                        ),
                      ),
                      hintText: "Search by Sale ID or Customer",
                      hintStyle:
                          const TextStyle(fontSize: 13, color: Colors.black45)),
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: getCalendarSelectionWidget(),
            )
          ],
        ),
      ),
    );
  }

  Widget getCalendarSelectionWidget() {
    return Container();
    // Comment calendar for now.
    return Align(
      alignment: Alignment.centerRight,
      child: IntrinsicWidth(
          child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        margin: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            border:
                Border.all(width: 0.5, color: Theme.of(context).primaryColor)),
        child: InkWell(
          onLongPress: () {
            showToast(
                "Cashier can see sales only for last valid return days limit configured in the backend.",
                context);
          },
          onTap: () {
            setState(() {
              showDialog(
                  context: context,
                  builder: (context) {
                    return SelectDateRangeDialog(
                      onDateSelected: onDateSelected,
                    );
                  });
            });
          },
          hoverColor: Colors.black45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(dateRangeText ?? "",
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                Icons.date_range,
                size: 15,
                color: Colors.black45,
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      )),
    );
  }

  void onDateSelected(DateTime? fromDate, DateTime? toDate, String? title) {
    setState(() {
      MyLogUtils.logDebug("fromDate : $fromDate, toDate : $toDate");

      this.fromDate = fromDate;
      this.toDate = toDate;

      if (fromDate != null) {
        dateRangeText = dateYmd(fromDate.millisecondsSinceEpoch);
      }
      if (toDate != null) {
        dateRangeText =
            "$dateRangeText  to ${dateYmd(toDate.millisecondsSinceEpoch)}";
      }

      if (title != null) {
        dateRangeText = title;
      }
      _getSales();
    });
  }

  Widget showSalesList() {
    if (sales == null || sales!.isEmpty) {
      return const NoDataWidget();
    }
    return Container(
      constraints: const BoxConstraints.expand(),
      child: customerListWidget(),
    );
  }

  Widget customerListWidget() {
    return Column(
      children: [
        Expanded(
          child: Container(
            constraints: BoxConstraints.expand(),
            child: showSales(sales!),
          ),
        ),
        searchText == null ? getPageController() : Container()
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
            _getSales();
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

  Widget showSales(List<Sales> salesList) {
    return Card(child: CustomScrollController(child:tableWidget(salesList)));
  }

  Widget tableWidget(List<Sales> filteredLists) {
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
          label:
              Text('Receipt No', style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataColumn(
          label: Text('Member', style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataColumn(
          label:
              Text('Date Time', style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataColumn(
          numeric: true,
          label: Text('Amount', style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataColumn(
          numeric: true,
          label: Text('Total Items',
              style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataColumn(
          label: Text('Payment Types',
              style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
      rows: getDtaRows(filteredLists),
    );
  }

  List<DataRow> getDtaRows(List<Sales> filteredLists) {
    List<DataRow> dataRows = List.empty(growable: true);
    int index = 0;
    for (Sales sale in filteredLists) {
      index += 1;
      Color color =
          (index % 2 == 0) ? getWhiteColor(context) : getWhiteColor(context);

      if (selectedSale != null && sale.id == selectedSale?.id) {
        color = Theme.of(context).colorScheme.onPrimaryContainer;
      }

      dataRows.add(
        DataRow(
          color: MaterialStateColor.resolveWith((states) {
            return color;
          }),
          onSelectChanged: (value) async {
            setState(() {
              selectedSale = sale;
              widget.onVoided(selectedSale);
            });
          },
          cells: <DataCell>[
            DataCell(Align(
              alignment: Alignment.centerLeft,
              child: Text("$index.",
                  style: Theme.of(context).textTheme.bodyMedium),
            )),
            DataCell(Align(
              alignment: Alignment.center,
              child: Text("${sale.id}",
                  style: Theme.of(context).textTheme.bodyMedium),
            )),
            DataCell(
              Align(
                alignment: Alignment.centerLeft,
                child: Text(viewModel.getCustomerName(sale),
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
            DataCell(
              Align(
                alignment: Alignment.centerLeft,
                child: Text(viewModel.getDateTime(sale),
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
            DataCell(
              Text(viewModel.getTotalAmount(sale),
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
            DataCell(
              Text(viewModel.getTotalItems(sale),
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
            DataCell(
              Align(
                alignment: Alignment.centerLeft,
                child: Text(viewModel.getPaymentTypes(sale),
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
          ],
        ),
      );
    }
    return dataRows;
  }
}
