import 'package:flutter/material.dart';
import 'package:jakel_base/constants.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/widgets/custom/MyPaginationWidget.dart';
import 'package:jakel_base/widgets/errorwidget/MyErrorWidget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_base/widgets/nodatawidget/NoDataWidget.dart';
import 'package:jakel_pos/modules/customers/CustomersViewModel.dart';
import 'package:jakel_pos/modules/utils/scroll_bar_utils.dart';
import 'package:jakel_pos/routing/route_names.dart';

class CustomersListWidget extends StatefulWidget {
  final Function onSelected;

  const CustomersListWidget({Key? key, required this.onSelected})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CustomersListWidgetState();
  }
}

class _CustomersListWidgetState extends State<CustomersListWidget> {
  final viewModel = CustomersViewModel();
  final searchController = TextEditingController();
  final searchNode = FocusNode();
  int pageNo = 1;
  int perPage = 20;
  List<Customers> customers = [];
  CustomersResponse? customersResponse;
  Customers? selectedCustomers;

  @override
  void initState() {
    super.initState();
    _getSales();
  }

  void _getSales() {
    viewModel.getCustomers(pageNo, perPage);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      padding: const EdgeInsets.all(5.0),
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
    return StreamBuilder<CustomersResponse>(
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
          if (responseData != null && responseData.members != null) {
            customersResponse = responseData;
            customers.clear();
            customers.addAll(responseData.members ?? []);
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
              child: SizedBox(
                height: 50,
                child: TextField(
                  controller: searchController,
                  focusNode: searchNode,
                  onSubmitted: (text) {
                    searchValue(text);
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
                            pageNo = 1;
                            perPage = 20;
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
                      hintText: "Search by name or email or mobile number",
                      hintStyle:
                          const TextStyle(fontSize: 13, color: Colors.black45)),
                ),
              ),
            ),
            const SizedBox(
              width: 19,
            ),
            MyInkWellWidget(
                child: Container(
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.all(0.5),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      border: Border.all(
                          width: 0.1, color: Theme.of(context).dividerColor)),
                  child: Icon(
                    Icons.person_add_alt,
                    color: Theme.of(context).indicatorColor,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AddCustomerRoute,
                  );
                })
          ],
        ),
      ),
    );
  }

  searchValue(String searchValue) {
    pageNo = 1;
    perPage = 20;
    if (searchValue.isEmpty) {
      _getSales();
    } else {
      viewModel.searchCustomer(searchValue);
    }
  }

  Widget showSalesList() {
    if (customers.isEmpty) {
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
            constraints: const BoxConstraints.expand(),
            child: showSales(customers),
          ),
        ),
        getPageController()
      ],
    );
  }

  Widget getPageController() {
    if (customersResponse == null ||
        customersResponse?.currentPage == null ||
        (customersResponse?.totalRecords ?? 0) < 21) {
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
        perPage: perPage,
        currentPage: customersResponse!.currentPage!,
        lastPage: customersResponse!.lastPage!,
        totalCount: customersResponse!.totalRecords!,
        totalPages: customersResponse!.lastPage!,
      ),
    );
  }

  Widget showSales(List<Customers> lists) {
    return Card(child: CustomScrollController(child: tableWidget(lists)));
  }

  Widget tableWidget(List<Customers> filteredLists) {
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
          label: SelectableText('ID',
              style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataColumn(
          label: Text('Name', style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataColumn(
          label: Text('Email', style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataColumn(
          label: Text('Mobile', style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataColumn(
          label: Text('City', style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
      rows: getDtaRows(filteredLists),
    );
  }

  List<DataRow> getDtaRows(List<Customers> filteredLists) {
    List<DataRow> dataRows = List.empty(growable: true);
    int index = 0;
    for (Customers customer in filteredLists) {
      index += 1;
      Color color =
          (index % 2 == 0) ? getWhiteColor(context) : getWhiteColor(context);

      if (selectedCustomers != null && customer.id == selectedCustomers?.id) {
        color = Theme.of(context).colorScheme.onPrimaryContainer;
      }

      dataRows.add(
        DataRow(
          color: MaterialStateColor.resolveWith((states) {
            return color;
          }),
          onSelectChanged: (value) async {
            setState(() {
              selectedCustomers = customer;
              widget.onSelected(selectedCustomers);
            });
          },
          cells: <DataCell>[
            DataCell(
              Container(
                constraints: const BoxConstraints(
                    minWidth: 60, maxWidth: double.infinity),
                alignment: Alignment.centerLeft,
                child: Text(
                    customersResponse!.currentPage == null
                        ? '${(index)}'
                        : '${((customersResponse!.currentPage! - 1) * 20) + (index)}',
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
            DataCell(Container(
              constraints:
                  const BoxConstraints(minWidth: 60, maxWidth: double.infinity),
              alignment: Alignment.centerLeft,
              child: Text("${customer.id}",
                  style: Theme.of(context).textTheme.bodyMedium),
            )),
            DataCell(
              Container(
                constraints: const BoxConstraints(
                    minWidth: 100, maxWidth: double.infinity),
                alignment: Alignment.centerLeft,
                child: Text(viewModel.name(customer),
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
            DataCell(
              Container(
                constraints: const BoxConstraints(
                    minWidth: 100, maxWidth: double.infinity),
                alignment: Alignment.centerLeft,
                child: Text(customer.email ?? noData,
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
            DataCell(
              Text(customer.mobileNumber ?? noData,
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
            DataCell(Container(
              constraints: const BoxConstraints(
                  minWidth: 100, maxWidth: double.infinity),
              alignment: Alignment.centerLeft,
              child: Text(customer.city ?? noData,
                  style: Theme.of(context).textTheme.bodyMedium),
            )),
          ],
        ),
      );
    }
    return dataRows;
  }
}
