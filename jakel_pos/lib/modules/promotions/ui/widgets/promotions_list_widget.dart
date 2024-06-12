import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/widgets/custom/my_paginated_data_table_widget.dart';
import 'package:jakel_base/widgets/errorwidget/MyErrorWidget.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_base/widgets/nodatawidget/NoDataWidget.dart';
import 'package:jakel_pos/modules/promotions/PromotionsViewModel.dart';
import 'package:jakel_pos/modules/promotions/ui/widgets/promotions_list_data_table_source_widget.dart';

class PromotionsListWidget extends StatefulWidget {
  final Function onSelected;

  const PromotionsListWidget({Key? key, required this.onSelected})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PromotionsListWidgetState();
  }
}

class _PromotionsListWidgetState extends State<PromotionsListWidget>
    implements PromotionsDataTableSourceInterface {
  final viewModel = PromotionsViewModel();
  final searchController = TextEditingController();
  final searchNode = FocusNode();
  List<Promotions>? promotions;
  String? dateRangeText;
  String? filter;
  PromotionsResponse? response;
  Promotions? selectedPromotions;
  late PaginatedDataTableWidget mPaginatedDataTableWidget;

  int sortColumnIndex = 0;
  bool sortAscending = true;
  String searchText = "";

  @override
  void initState() {
    super.initState();
    _getPromotionsList();
  }

  void _getPromotionsList() async {
    await viewModel.getPromotionsOffline(searchText);
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
    return StreamBuilder<PromotionsResponse>(
      stream: viewModel.responseSubject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          MyLogUtils.logDebug("apiWidget waiting");
          return const MyLoadingWidget();
        }
        if (snapshot.hasError) {
          MyLogUtils.logDebug("apiWidget hasError");
          return MyErrorWidget(
              message: "Error.Please try again!", tryAgain: _getPromotionsList);
        }
        if (snapshot.connectionState == ConnectionState.active) {
          var responseData = snapshot.data;
          if (responseData != null && responseData.promotions != null) {
            promotions = responseData.promotions;
            return showSalesList();
          } else {
            return MyErrorWidget(
                message: "Error.Please try again!",
                tryAgain: _getPromotionsList);
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
                      mPaginatedDataTableWidget.createState().bHandleFirst =
                          true;
                      searchText = text;
                      searchController.selection = TextSelection.collapsed(
                          offset: searchController.text.length);
                      sortAscending = true;
                      _getPromotionsList();
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
                            sortAscending = true;
                            _getPromotionsList();
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
                            sortAscending = true;
                            _getPromotionsList();
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
                      hintText: "Search by promotion name",
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
    if (promotions == null || promotions!.isEmpty) {
      return const NoDataWidget();
    }
    return Container(
      constraints: const BoxConstraints.expand(),
      child: showSales(promotions!),
    );
  }

  Widget showSales(List<Promotions> lists) {
    return Card(
      child: tableWidget(lists),
    );
  }

  Widget tableWidget(List<Promotions> filteredLists) {
    final dtSource = PromotionsDataTableSource(
        filteredLists, context, selectedPromotions, viewModel, this);
    mPaginatedDataTableWidget = PaginatedDataTableWidget(
      rowsPerPage: 20,
      showCheckboxColumn: false,
      columns: _colGen(dtSource, viewModel),
      source: dtSource,
      sortColumnIndex: sortColumnIndex,
      sortAscending: sortAscending,
    );
    return mPaginatedDataTableWidget;
  }

  List<DataColumn> _colGen(
    PromotionsDataTableSource src,
    PromotionsViewModel provider,
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
          label: SelectableText('ID',
              style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataColumn(
          label: Text('Name', style: Theme.of(context).textTheme.bodyMedium),
          onSort: (colIndex, asc) {
            _sort<String>(
                (user) => user.name ?? "", colIndex, asc, src, provider);
          },
        ),
        DataColumn(
          label: Text('Promotion Applicable Type',
              style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataColumn(
          label: Text('Type', style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataColumn(
          label: Text('Promotion Type',
              style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataColumn(
          label: Text('Timeframe Type',
              style: Theme.of(context).textTheme.bodyMedium),
        ),
      ];

  void _sort<T>(
    Comparable<T> Function(Promotions user) getField,
    int colIndex,
    bool asc,
    PromotionsDataTableSource src,
    PromotionsViewModel provider,
  ) {
    setState(() {
      src.sort<T>(getField, asc);
      sortAscending = asc;
      sortColumnIndex = colIndex;
    });
  }

  @override
  onClickPromotionsTable(Promotions mPromotions) {
    selectedPromotions = mPromotions;
    widget.onSelected(mPromotions);
  }
}
