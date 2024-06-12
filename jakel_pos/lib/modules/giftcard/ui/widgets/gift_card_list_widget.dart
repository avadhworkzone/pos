import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/giftcards/model/GiftCardsResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/widgets/errorwidget/MyErrorWidget.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_base/widgets/nodatawidget/NoDataWidget.dart';
import 'package:jakel_pos/modules/giftcard/GiftCardViewModel.dart';
import 'package:jakel_pos/modules/giftcard/ui/widgets/gift_card_list_data_table_source_widget.dart';
import 'package:jakel_base/widgets/custom/my_paginated_data_table_widget.dart';

class GiftCardListWidget extends StatefulWidget {
  final Function onSelected;

  const GiftCardListWidget({Key? key, required this.onSelected})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GiftCardListWidgetState();
  }
}

class _GiftCardListWidgetState extends State<GiftCardListWidget>
    implements GiftCardDataTableSourceInterface {
  final viewModel = GiftCardViewModel();
  final searchController = TextEditingController();
  final searchNode = FocusNode();
  String searchText = "";
  List<GiftCards>? listGiftCards;
  DateTime? fromDate, toDate;
  String? dateRangeText;
  String? filter;
  GiftCardsResponse? mGiftCardsResponse;
  GiftCards? selectedGiftCards;
  int sortColumnIndex = 0;
  bool sortAscending = true;
  late PaginatedDataTableWidget mPaginatedDataTableWidget;

  @override
  void initState() {
    super.initState();
    _getGiftCardList();
  }

  void _getGiftCardList() async {
    await viewModel.getGiftCardsOffline(sSearch: searchText);
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
    return StreamBuilder<GiftCardsResponse>(
      stream: viewModel.responseSubject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          MyLogUtils.logDebug("apiWidget waiting");
          return const MyLoadingWidget();
        }
        if (snapshot.hasError) {
          MyLogUtils.logDebug("apiWidget hasError");
          return MyErrorWidget(
              message: "Error.Please try again!", tryAgain: _getGiftCardList);
        }
        if (snapshot.connectionState == ConnectionState.active) {
          var responseData = snapshot.data;
          if (responseData != null && responseData.giftCards != null) {
            mGiftCardsResponse = responseData;
            listGiftCards = responseData.giftCards;
            return showSalesList();
          } else {
            return MyErrorWidget(
                message: "Error.Please try again!", tryAgain: _getGiftCardList);
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
                      _getGiftCardList();
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
                            _getGiftCardList();
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
                            _getGiftCardList();
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
    if (listGiftCards == null || listGiftCards!.isEmpty) {
      return const NoDataWidget();
    }
    return Container(
      constraints: const BoxConstraints.expand(),
      color: Colors.white,
      child: showSales(listGiftCards!),
    );
  }

  Widget showSales(List<GiftCards> lists) {
    return Card(
      child: tableWidget(lists),
    );
  }

  Widget tableWidget(List<GiftCards> filteredLists) {
    final _dtSource = GiftCardDataTableSource(
        filteredLists, context, selectedGiftCards, viewModel, this);
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
    GiftCardDataTableSource _src,
    GiftCardViewModel _provider,
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
              '  Name  ',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          onSort: (colIndex, asc) {
            _sort<String>((user) => user.type!.name ?? "", colIndex, asc, _src,
                _provider);
          },
        ),
        DataColumn(
          label: Center(
            child: SelectableText(
              '  Number  ',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          onSort: (colIndex, asc) {
            _sort<String>(
                (user) => user.number ?? "0", colIndex, asc, _src, _provider);
          },
        ),
        DataColumn(
          label: Center(
            child: SelectableText(
              '  Expiry Date  ',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataColumn(
          label: Center(
            child: SelectableText(
              '  Total Amount  ',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataColumn(
          label: Center(
            child: SelectableText(
              '  Available Amount  ',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataColumn(
          label: Center(
            child: SelectableText(
              '  Status  ',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ];

  void _sort<T>(
    Comparable<T> Function(GiftCards user) getField,
    int colIndex,
    bool asc,
    GiftCardDataTableSource src,
    GiftCardViewModel provider,
  ) {
    setState(() {
      src.sort<T>(getField, asc);
      sortAscending = asc;
      sortColumnIndex = colIndex;
    });
  }

  @override
  onClickGiftCardTable(GiftCards mGiftCards) {
    selectedGiftCards = mGiftCards;
    widget.onSelected(mGiftCards);
  }
}
