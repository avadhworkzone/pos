import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/vouchers/model/VouchersListResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/widgets/custom/my_paginated_data_table_widget.dart';
import 'package:jakel_base/widgets/errorwidget/MyErrorWidget.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_base/widgets/nodatawidget/NoDataWidget.dart';
import 'package:jakel_pos/modules/Vouchers/VouchersViewModel.dart';

import 'vouchers_list_data_table_source_widget.dart';

class VouchersListWidget extends StatefulWidget {
  final Function onSelected;

  const VouchersListWidget({Key? key, required this.onSelected})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VouchersListWidgetState();
  }
}

class _VouchersListWidgetState extends State<VouchersListWidget>
    implements VouchersDataTableSourceInterface {
  final viewModel = VouchersViewModel();
  final searchController = TextEditingController();
  final searchNode = FocusNode();
  String searchText = "";
  String? dateRangeText;
  String? filter;
  List<Vouchers>? listVouchers;
  VouchersListResponse? vouchersResponse;
  Vouchers? selectedVouchers;
  late PaginatedDataTableWidget mPaginatedDataTableWidget;
  int sortColumnIndex = 0;
  bool sortAscending = true;

  @override
  void initState() {
    super.initState();
    _getVoucherList();
  }

  void _getVoucherList() async {
    await viewModel.getVoucherListOffline(sSearch: searchText);
  }

  @override
  Widget build(BuildContext context) {
    MyLogUtils.logDebug("Search text : $searchText");
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

  /// search tab view
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
                      mPaginatedDataTableWidget.createState().bHandleFirst =
                          true;
                      searchText = text;
                      searchController.selection = TextSelection.collapsed(
                          offset: searchController.text.length);
                      // viewModel.sortAscending = true;
                      _getVoucherList();
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
                            mPaginatedDataTableWidget
                                .createState()
                                .bHandleFirst = true;
                            searchText = searchController.text;
                            searchController.selection =
                                TextSelection.collapsed(
                                    offset: searchController.text.length);
                            // viewModel.sortAscending = true;
                            _getVoucherList();
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
                            mPaginatedDataTableWidget
                                .createState()
                                .bHandleFirst = true;
                            searchText = searchController.text = "";
                            // viewModel.sortAscending = true;
                            _getVoucherList();
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
                      hintText: "Search by Vouchers Id and Discount Number",
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

  /// after get api response it's working
  Widget apiWidget() {
    return StreamBuilder<VouchersListResponse>(
      stream: viewModel.responseVouchersListSubject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          MyLogUtils.logDebug("apiWidget waiting");
          return const MyLoadingWidget();
        }
        if (snapshot.hasError) {
          MyLogUtils.logDebug("apiWidget hasError");
          return MyErrorWidget(
              message: "Error.Please try again!", tryAgain: _getVoucherList);
        }
        if (snapshot.connectionState == ConnectionState.active) {
          var responseData = snapshot.data;
          if (responseData != null && responseData.vouchers != null) {
            vouchersResponse = responseData;
            listVouchers = responseData.vouchers;
            return showVouchersList();
          } else {
            return MyErrorWidget(
                message: "Error.Please try again!", tryAgain: _getVoucherList);
          }
        }
        return Container();
      },
    );
  }

  Widget showVouchersList() {
    if (listVouchers == null || listVouchers!.isEmpty) {
      return const NoDataWidget();
    }
    return Container(
      constraints: const BoxConstraints.expand(),
      color: Colors.white,
      child: showVouchers(listVouchers!),
    );
  }

  Widget showVouchers(List<Vouchers> lists) {
    return Card(
        child: vouchersTableWidget(lists),
    );
  }

  Widget vouchersTableWidget(List<Vouchers> filteredLists) {
    final _dtSource = VouchersDataTableSource(
        filteredLists, context, selectedVouchers, viewModel, this);
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

  /// Set Tab bar name
  List<DataColumn> _colGen(
    VouchersDataTableSource _src,
    VouchersViewModel _provider,
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
          onSort: (colIndex, asc) {
            _sort<num>((user) => user.id ?? 0, colIndex, asc, _src, _provider);
          },
        ),
        DataColumn(
          label: Center(
            child: SelectableText(
              '  Customer ID  ',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataColumn(
          label: Center(
            child: SelectableText(
              '  Discount Type  ',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataColumn(
          label: Center(
            child: SelectableText(
              '  Discount Number  ',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          onSort: (colIndex, asc) {
            _sort<String>(
                (user) => user.number ?? "", colIndex, asc, _src, _provider);
          },
        ),
        DataColumn(
          label: Center(
            child: SelectableText(
              ' Minimum Spend Amount  ',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataColumn(
          label: Center(
            child: SelectableText(
              ' Percentage  ',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataColumn(
          label: Center(
            child: SelectableText(
              ' Flat Amount  ',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataColumn(
          label: Center(
            child: SelectableText(
              ' Expiry Date  ',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ];

  /// Tab on id and Discount Number
  void _sort<T>(
    Comparable<T> Function(Vouchers user) getField,
    int colIndex,
    bool asc,
    VouchersDataTableSource src,
    VouchersViewModel provider,
  ) {
    setState(() {
      src.sort<T>(getField, asc);
      sortAscending = asc;
      sortColumnIndex = colIndex;
    });
  }

  ///click on Vouchers list
  @override
  onClickProductsTable(Vouchers mVouchers) {
    selectedVouchers = mVouchers;
    widget.onSelected(mVouchers);
  }
}
