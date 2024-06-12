import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jakel_base/constants.dart';
import 'package:jakel_base/restapi/sales/model/history/SalesResponse.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/errorwidget/MyErrorWidget.dart';
import 'package:jakel_base/widgets/nodatawidget/NoDataWidget.dart';
import 'package:jakel_pos/modules/offline/synctoserver/OfflineSyncingViewModel.dart';
import 'package:jakel_pos/modules/saleshistory/SalesHistoryViewModel.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/history/authority_to_delete_offline_sale.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/history/manager_authorization_widget.dart';
import 'package:jakel_pos/modules/utils/scroll_bar_utils.dart';

class OfflineSalesWidget extends StatefulWidget {
  final Function onSelected;

  const OfflineSalesWidget({Key? key, required this.onSelected})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegularSalesWidgetState();
  }
}

class _RegularSalesWidgetState extends State<OfflineSalesWidget> {
  final viewModel = SalesHistoryViewModel();
  final offlineViewModel = OfflineSyncingViewModel();

  final searchController = TextEditingController();
  final searchNode = FocusNode();
  String? searchText;
  int pageNo = 1;
  int perPage = 20;
  List<Sales>? sales;
  DateTime? fromDate, toDate;
  String? dateRangeText;
  String? filter;
  Sales? selectedSale;

  bool isFirstTime = true;
  final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  void _getSales() {
    setState(() {
      isFirstTime = true;
    });
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
    if (!isFirstTime) {
      return showSalesList();
    }
    return FutureBuilder(
        future: offlineViewModel.getOfflineSalesAsSale(),
        builder: (BuildContext context, AsyncSnapshot<List<Sales>> snapshot) {
          if (snapshot.hasError) {
            MyLogUtils.logDebug("getStoreManager snapshot :$snapshot");
            return MyErrorWidget(
                message: "Error.Please try again!", tryAgain: () {});
          }
          if (snapshot.hasData) {
            isFirstTime = false;
            sales = snapshot.data;
            return showSalesList();
          }
          return const Text("Loading ...");
        });
  }

  Widget searchWidget() {
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
          ],
        ),
      ),
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
      ],
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
          numeric: true,
          label: Text('Total Quantities',
              style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataColumn(
          label: Text('Payment Types',
              style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataColumn(
          label: Text('ACTION', style: Theme.of(context).textTheme.bodyMedium),
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
              child: Text("$index.",
                  style: Theme.of(context).textTheme.bodyMedium),
            )),
            DataCell(Align(
              alignment: Alignment.centerLeft,
              child: Text("${sale.offlineSaleId}",
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
            DataCell(
              Align(
                alignment: Alignment.centerLeft,
                child: MyOutlineButton(
                  text: "Delete",
                  onClick: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AuthorityToDeleteOfflineSale(
                          onSuccess: () async {
                            showToast("Authorized to delete the offline sale.",
                                context);
                            await offlineViewModel.deleteOfflineSale(
                                sale.offlineSaleId ??
                                    sale.offlineSaleReturnId ??
                                    noData);
                            setState(() {
                              isFirstTime = true;
                            });
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }
    return dataRows;
  }
}
