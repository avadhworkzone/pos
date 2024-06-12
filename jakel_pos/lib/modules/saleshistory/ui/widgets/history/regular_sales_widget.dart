import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jakel_base/restapi/counters/model/GetCountersResponse.dart';
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
import 'package:jakel_pos/modules/opencounter/viewmodel/CountersViewModel.dart';
import 'package:jakel_pos/modules/saleshistory/SalesHistoryViewModel.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:jakel_pos/modules/utils/scroll_bar_utils.dart';

class RegularSalesWidget extends StatefulWidget {
  final Function onSelected;

  const RegularSalesWidget({Key? key, required this.onSelected})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegularSalesWidgetState();
  }
}

class _RegularSalesWidgetState extends State<RegularSalesWidget> {
  final viewModel = SalesHistoryViewModel();
  final searchController = TextEditingController();
  final countersViewModel = CountersViewModel();
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
  Counters? selectedCounter;
  bool searchSaleFromDifferentStore = false;
  final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();

  @override
  void initState() {
    super.initState();
    _getSales();
  }

  void _getSales() {
    if (searchSaleFromDifferentStore) {
      if (searchText != null && searchText!.isNotEmpty) {
        viewModel.getRegularSaleById(searchText ?? '');
      }
    } else {
      viewModel.getRegularSales(pageNo, perPage, 0, 0, fromDate, toDate??fromDate,
          searchText, selectedCounter?.id);
    }
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
          isOtherStoreSale(),
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
    return Card(
      child: Container(
        margin: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              flex: 2,
              child: searchFieldWidget(),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: getCounterSelectionWidget(),
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

  Widget getCounterSelectionWidget() {
    return SizedBox(
      height: 50,
      child: DropdownSearch<Counters>(
        compareFn: (item1, item2) {
          return false;
        },
        dropdownDecoratorProps: const DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
              labelText: "Select counter",
              hintText: "Select counter",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(3)))),
        ),
        clearButtonProps: const ClearButtonProps(isVisible: true),
        popupProps: const PopupProps.menu(
          showSelectedItems: true,
        ),
        asyncItems: (String filter) =>
            countersViewModel.getCountersForCurrentStore(),
        onChanged: (value) {
          setState(() {
            selectedCounter = value;
            _getSales();
          });
        },
        itemAsString: (item) {
          return item.name!;
        },
        selectedItem: selectedCounter,
      ),
    );
  }

  Widget isOtherStoreSale() {
    return SizedBox(
        height: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Search sale from different store using invoice id ?',
                style: TextStyle(
                    fontSize: 12, color: Theme.of(context).primaryColor)),
            Checkbox(
                value: searchSaleFromDifferentStore,
                onChanged: (value) {
                  setState(() {
                    if (value != null) {
                      searchSaleFromDifferentStore = value;
                    }
                  });
                })
          ],
        ));
  }

  Widget searchFieldWidget() {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: searchController,
        focusNode: searchNode,
        onSubmitted: (text) {
          setState(() {
            searchText = text;
            _getSales();
          });
        },
        style: const TextStyle(fontSize: 14, color: Colors.black45),
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.only(left: 10.0),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 0.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 0.5),
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
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    border: Border.all(
                        width: 0.1, color: Theme.of(context).dividerColor)),
                child: Icon(
                  Icons.search_outlined,
                  color: Theme.of(context).indicatorColor,
                ),
              ),
            ),
            suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  searchText = null;
                  searchController.text = "";
                  _getSales();
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
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    border: Border.all(
                        width: 0.1, color: Theme.of(context).dividerColor)),
                child: Icon(
                  Icons.clear,
                  color: Theme.of(context).indicatorColor,
                ),
              ),
            ),
            hintText: "Search by Sale ID or Customer",
            hintStyle: const TextStyle(fontSize: 13, color: Colors.black45)),
      ),
    );
  }

  Widget getCalendarSelectionWidget() {
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

      if (fromDate == null && toDate == null) {
        dateRangeText = null;
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
            MyLogUtils.logDebug("MyPaginationWidget page => $page");
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
          label:
              Text('Counter No', style: Theme.of(context).textTheme.bodyMedium),
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
          numeric: true,
          label: Text('Total Quantities',
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
              widget.onSelected(selectedSale);
            });
          },
          cells: <DataCell>[
            DataCell(Align(
              alignment: Alignment.centerLeft,
              child: SelectableText("${index + ((pageNo - 1) * perPage)}.",
                  style: Theme.of(context).textTheme.bodyMedium),
            )),
            DataCell(Align(
              alignment: Alignment.centerLeft,
              child: SelectableText("${sale.offlineSaleId}",
                  style: Theme.of(context).textTheme.bodyMedium),
            )),
            DataCell(Align(
              alignment: Alignment.centerLeft,
              child: Text("${sale.counterDetails?.name}",
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
              Text(viewModel.getTotalQuantities(sale),
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
