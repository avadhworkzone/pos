import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/products/model/ProductsResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/widgets/errorwidget/MyErrorWidget.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_base/widgets/nodatawidget/NoDataWidget.dart';
import 'package:jakel_pos/modules/products/ProductsViewModel.dart';
import 'package:jakel_pos/modules/products/ui/widgets/products_list_data_table_source_widget.dart';
import 'package:jakel_base/widgets/custom/my_paginated_data_table_widget.dart';


class ProductsListWidget extends StatefulWidget {
  final Function onSelected;

  const ProductsListWidget({Key? key, required this.onSelected})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProductsListWidgetState();
  }
}

class _ProductsListWidgetState extends State<ProductsListWidget>
    implements ProductsDataTableSourceInterface {
  final viewModel = ProductsViewModel();
  final searchController = TextEditingController();
  final searchNode = FocusNode();
  List<Products>? products;
  DateTime? fromDate, toDate;
  String? dateRangeText;
  String? filter;
  Products? selectedProduct;
  late PaginatedDataTableWidget mPaginatedDataTableWidget ;
  int sortColumnIndex = 0;
  bool sortAscending = true;
  String searchText = "";


  @override
  void initState() {
    super.initState();
    _getSales();
  }

  void _getSales() async {
    await viewModel.getProductsOffline(searchText);
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
    return StreamBuilder<ProductsResponse>(
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
          if (responseData != null && responseData.products != null) {
            products = responseData.products;
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
                    if (searchText != text) {
                      mPaginatedDataTableWidget.createState().bHandleFirst =true;
                      searchText = text;
                      searchController.selection = TextSelection.collapsed(
                          offset: searchController.text.length);
                      sortAscending = true;
                      _getSales();
                    }
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
                        onTap: () {
                          if (searchText != searchController.text) {
                            mPaginatedDataTableWidget.createState().bHandleFirst =true;

                            searchText = searchController.text;
                            searchController.selection =
                                TextSelection.collapsed(
                                    offset: searchController.text.length);
                            sortAscending = true;
                            _getSales();
                          }
                        },
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
                          if (searchText == searchController.text &&
                              searchText.isNotEmpty) {
                            mPaginatedDataTableWidget.createState().bHandleFirst =true;
                            searchText = searchController.text = "";
                            sortAscending = true;
                            _getSales();
                          }
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
                      hintText: "Search by name or code or upc",
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
    if (products == null || products!.isEmpty) {
      return const NoDataWidget();
    }
    return
     Container(
        constraints: const BoxConstraints.expand(),
        color: Colors.white,
        child: showSales(products!),
      );
  }

  Widget showSales(List<Products> lists) {
    return Card(
        child: tableWidget(lists),
    );
  }

  Widget tableWidget(List<Products> filteredLists) {
    final _dtSource = ProductsDataTableSource(
        filteredLists, context, selectedProduct, viewModel, this);
    mPaginatedDataTableWidget = PaginatedDataTableWidget(
      rowsPerPage: 20,
      showCheckboxColumn: false,
      columns: _colGen(_dtSource, viewModel),
      source: _dtSource,
      sortColumnIndex: sortColumnIndex,
      sortAscending: sortAscending,
    );
    return mPaginatedDataTableWidget;
  }

  List<DataColumn> _colGen(
    ProductsDataTableSource _src,
    ProductsViewModel _provider,
  ) =>
      <DataColumn>[
        DataColumn(
          label: Center(
            child: SelectableText(
              '  Index  ',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataColumn(
          label: Center(
            child: SelectableText(
              '  ID  ',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          // tooltip: 'ID',
          onSort: (colIndex, asc) {
            _sort<num>((user) => user.id??0, colIndex, asc, _src, _provider);
          },
        ),
        DataColumn(
          label: Center(
              child: Text('  Name  ',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium)),
          onSort: (colIndex, asc) {
            _sort<String>((user) => user.name??"", colIndex, asc, _src, _provider);
          },
        ),
        DataColumn(
          label: Center(
              child: Text('  Upc  ',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium)),
          onSort: (colIndex, asc) {
            _sort<String>((user) => user.upc??"", colIndex, asc, _src, _provider);
          },
        ),
        DataColumn(
          label: Center(
              child: Text('  Ean  ',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium)),
          onSort: (colIndex, asc) {
            _sort<String>((user) => user.ean??"", colIndex, asc, _src, _provider);
          },
        ),
        DataColumn(
          label: Center(
            child: Text('  Article Number  ',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          // tooltip: 'Article Number',
          onSort: (colIndex, asc) {
            _sort<String>(
                (user) => user.articleNumber??"", colIndex, asc, _src, _provider);
          },
        ),
        DataColumn(
          label: Center(
              child: Text('  Code  ',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium)),
        ),
        DataColumn(
          label: Center(
              child: Text('  Price  ',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium)),
        ),
        DataColumn(
          label: Center(
            child: Text('  Unit Of Measure  ',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
        DataColumn(
          label: Center(
              child: Text('  Season  ',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium)),
        ),
      ];

  void _sort<T>(
    Comparable<T> Function(Products user) getField,
    int colIndex,
    bool asc,
    ProductsDataTableSource src,
    ProductsViewModel provider,
  ) {
    setState(() {
      src.sort<T>(getField, asc);
      sortAscending = asc;
      sortColumnIndex = colIndex;
    });
  }

  @override
  onClickProductsTable(Products mProduct) {
    selectedProduct = mProduct;
    widget.onSelected(mProduct);
  }
}
