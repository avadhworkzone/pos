import 'package:flutter/material.dart';
import 'package:jakel_base/constants.dart';
import 'package:jakel_base/restapi/products/model/ProductsResponse.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/widgets/custom/my_paginated_data_table_widget.dart';
import 'package:jakel_base/widgets/custom/my_small_box_widget.dart';
import 'package:jakel_pos/modules/promotions/PromotionsViewModel.dart';
import 'package:jakel_pos/modules/promotions/ui/widgets/promotions_products_list_data_table_source_widget.dart';

class PromotionsDetailWidget extends StatefulWidget {
  final Promotions selectedPromotion;

  const PromotionsDetailWidget({Key? key, required this.selectedPromotion})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PromotionsDetailWidgetState();
  }
}

class _PromotionsDetailWidgetState extends State<PromotionsDetailWidget>
    with SingleTickerProviderStateMixin
    implements PromotionsProductsDataTableSourceInterface {
  late AnimationController _controller;
  final viewModel = PromotionsViewModel();
  late PaginatedDataTableWidget mPaginatedDataTableWidget;

  Products? selectedProduct;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      constraints: const BoxConstraints.expand(),
      child: _getRootWidget(),
    );
  }

  _getRootWidget() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _getChildrenWidgets(),
      ),
    );
  }

  List<Widget> _getChildrenWidgets() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(SizedBox(
      width: double.infinity,
      child: MySmallBoxWidget(
          title: "Promotion Name",
          value: viewModel.getName(widget.selectedPromotion),),
    ));

    widgets.add(const SizedBox(
      height: 20,
    ));

    widgets.add(Padding(
      padding: const EdgeInsets.all(8),
      child: Text("Details",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold)),
    ));

    widgets.add(const SizedBox(
      height: 20,
    ));

    widgets.add(SizedBox(
      width: double.infinity,
      child: MySmallBoxWidget(
          title: "Promotion Applicable Type",
          value:
              viewModel.getPromotionApplicableType(widget.selectedPromotion)),
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(Row(
      children: [
        Expanded(
            child: MySmallBoxWidget(
                title: "Type",
                value: viewModel.getType(widget.selectedPromotion))),
        Expanded(
            child: MySmallBoxWidget(
                title: "Timeframe Type",
                value: viewModel.getTimeFrameLimit(widget.selectedPromotion))),
      ],
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(SizedBox(
      width: double.infinity,
      child: MySmallBoxWidget(
          title: "Promotion Type",
          value: viewModel.getPromotionType(widget.selectedPromotion)),
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(Row(
      children: [
        Expanded(
            child: MySmallBoxWidget(
                title: "Percentage",
                value: widget.selectedPromotion.percentage != 0
                    ? "${widget.selectedPromotion.percentage!.toStringAsFixed(2)}%"
                    : noData)),
        Expanded(
            child: MySmallBoxWidget(
                title: "Flat Amount",
                value: widget.selectedPromotion.flatAmount != 0
                    ? "RM${widget.selectedPromotion.flatAmount!.toStringAsFixed(2)}"
                    : noData)),
      ],
    ));

    if (widget.selectedPromotion.promotionTiers != null &&
        widget.selectedPromotion.promotionTiers!.isNotEmpty) {
      widgets.add(const SizedBox(
        height: 10,
      ));
      widgets.add(getPaymentTypes());
    }

    if (widget.selectedPromotion.products!.isNotEmpty) {
      widgets.add(const SizedBox(
        height: 10,
      ));

      widgets.add(SizedBox(
        width: double.infinity,
        child: GestureDetector(
          onTap: () async {
            showMyDialog(
                await viewModel.getProductListFromProductIds(
                    widget.selectedPromotion.products!),
                'Products List');
          },
          child: MySmallBoxWidget(
              title: "Products List",
              value: widget.selectedPromotion.products!.length.toString()),
        ),
      ));
    }

    if (widget.selectedPromotion.getProducts!.isNotEmpty) {
      widgets.add(const SizedBox(
        height: 10,
      ));

      widgets.add(SizedBox(
        width: double.infinity,
        child: GestureDetector(
          onTap: () async {
            showMyDialog(
                await viewModel.getProductListFromProductIds(
                    widget.selectedPromotion.getProducts!),
                'Get Products List');
          },
          child: MySmallBoxWidget(
              title: "Get Products List",
              value: widget.selectedPromotion.getProducts!.length.toString(),
              underline: true),
        ),
      ));
    }

    if (widget.selectedPromotion.buyProducts!.isNotEmpty) {
      widgets.add(const SizedBox(
        height: 10,
      ));

      widgets.add(SizedBox(
        width: double.infinity,
        child: GestureDetector(
          onTap: () async {
            showMyDialog(
                await viewModel.getProductListFromProductIds(
                    widget.selectedPromotion.buyProducts!),
                'Buy Products List');
          },
          child: MySmallBoxWidget(
              title: "Buy Products List",
              value: widget.selectedPromotion.buyProducts!.length.toString(),
              underline: true),
        ),
      ));
    }

    return widgets;
  }

  Future<void> showMyDialog(List<Products> mProductsList, String sTitle) async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(sTitle),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.height * 0.75,
            // color: Colors.red,
            child: showSales(mProductsList),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget showSales(List<Products> lists) {
    return tableWidget(lists);
  }

  Widget tableWidget(List<Products> filteredLists) {
    final dtSource = PromotionsProductsDataTableSource(
        filteredLists, context, selectedProduct, viewModel, this);
    mPaginatedDataTableWidget = PaginatedDataTableWidget(
      rowsPerPage: 20,
      showCheckboxColumn: false,
      columns: colGen(),
      source: dtSource,
    );
    return mPaginatedDataTableWidget;
  }

  List<DataColumn> colGen() => <DataColumn>[
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
        ),
        DataColumn(
          label: Center(
              child: Text('  Name  ',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium)),
        ),
        DataColumn(
          label: Center(
              child: Text('  Upc  ',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium)),
        ),
        DataColumn(
          label: Center(
              child: Text('  Ean  ',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium)),
        ),
        DataColumn(
          label: Center(
            child: Text('  Article Number  ',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium),
          ),
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

  Widget getPaymentTypes() {
    if (widget.selectedPromotion.promotionTiers == null ||
        widget.selectedPromotion.promotionTiers!.isEmpty) {
      return Container();
    }

    List<Widget> widgets = List.empty(growable: true);

    widgets.add(Container(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: getPaymentTypesTopTitle(
          widget.selectedPromotion.promotionTiers!.first),
    ));

    widgets.add(const Divider());

    if (widget.selectedPromotion.promotionTiers!.isNotEmpty) {
      int page = 1;
      for (PromotionTiers promotionTiers
          in widget.selectedPromotion.promotionTiers!) {
        widgets.add(Container(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: getPaymentTypesRow(promotionTiers, page),
        ));
        widgets.add(const Divider());
        page = page + 1;
      }
    }
    return Card(
      elevation: 2,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5),
          child: ExpansionTile(
            backgroundColor: getWhiteColor(context),
            collapsedBackgroundColor: getWhiteColor(context),
            initiallyExpanded: true,
            iconColor: Theme.of(context).primaryColor,
            title: Text("Promotion Details",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.subtitle2),
            children: widgets,
          ),
        ),
      ),
    );
  }

  Widget getPaymentTypesTopTitle(PromotionTiers mPromotionTiers) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        getPromotionTiersValueText(
            viewModel.showPaymentView(
                mPromotionTiers.minimumSpendAmount.toString().trim()),
            "Minimum Spend Amount"),
        SizedBox(
          width: viewModel.showPaymentView(
                  mPromotionTiers.minimumSpendAmount.toString())
              ? 5.0
              : 0.0,
        ),
        getPromotionTiersValueText(
            viewModel.showPaymentView(mPromotionTiers.percentage.toString()),
            "Percentage"),
        SizedBox(
          width:
              viewModel.showPaymentView(mPromotionTiers.percentage.toString())
                  ? 5.0
                  : 0.0,
        ),
        getPromotionTiersValueText(
            viewModel.showPaymentView(mPromotionTiers.flatAmount.toString()),
            "Flat Amount"),
        SizedBox(
          width:
              viewModel.showPaymentView(mPromotionTiers.flatAmount.toString())
                  ? 5.0
                  : 0.0,
        ),
        getPromotionTiersValueText(
            viewModel.showPaymentView(mPromotionTiers.freeQuantity.toString()),
            "Free Quantity"),
        SizedBox(
          width:
              viewModel.showPaymentView(mPromotionTiers.freeQuantity.toString())
                  ? 5.0
                  : 0.0,
        ),
        getPromotionTiersValueText(
            viewModel.showPaymentView(mPromotionTiers.buyQuantity.toString()),
            "Buy Quantity"),
        SizedBox(
          width:
              viewModel.showPaymentView(mPromotionTiers.buyQuantity.toString())
                  ? 5.0
                  : 0.0,
        ),
        getPromotionTiersValueText(
            viewModel.showPaymentView(mPromotionTiers.getQuantity.toString()),
            "Get Quantity"),
        SizedBox(
          width:
              viewModel.showPaymentView(mPromotionTiers.getQuantity.toString())
                  ? 5.0
                  : 0.0,
        ),
        getPromotionTiersValueText(
            viewModel.showPaymentView(mPromotionTiers.amount.toString()),
            "Amount"),
      ],
    );
  }

  Widget getPaymentTypesRow(PromotionTiers mPromotionTiers, int page) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        getPromotionTiersValueText(
            viewModel
                .showPaymentView(mPromotionTiers.minimumSpendAmount.toString()),
            "Minimum Spend Amount",
            sValue: mPromotionTiers.minimumSpendAmount.toString()),
        SizedBox(
          width: viewModel.showPaymentView(
                  mPromotionTiers.minimumSpendAmount.toString())
              ? 5.0
              : 0.0,
        ),
        getPromotionTiersValueText(
            viewModel.showPaymentView(mPromotionTiers.percentage.toString()),
            "Percentage",
            sValue: mPromotionTiers.percentage.toString()),
        SizedBox(
          width:
              viewModel.showPaymentView(mPromotionTiers.percentage.toString())
                  ? 5.0
                  : 0.0,
        ),
        getPromotionTiersValueText(
            viewModel.showPaymentView(mPromotionTiers.flatAmount.toString()),
            "Flat Amount",
            sValue: mPromotionTiers.flatAmount.toString()),
        SizedBox(
          width:
              viewModel.showPaymentView(mPromotionTiers.flatAmount.toString())
                  ? 5.0
                  : 0.0,
        ),
        getPromotionTiersValueText(
            viewModel.showPaymentView(mPromotionTiers.freeQuantity.toString()),
            "Free Quantity",
            sValue: mPromotionTiers.freeQuantity.toString()),
        SizedBox(
          width:
              viewModel.showPaymentView(mPromotionTiers.freeQuantity.toString())
                  ? 5.0
                  : 0.0,
        ),
        getPromotionTiersValueText(
            viewModel.showPaymentView(mPromotionTiers.buyQuantity.toString()),
            "Buy Quantity",
            sValue: mPromotionTiers.buyQuantity.toString()),
        SizedBox(
          width:
              viewModel.showPaymentView(mPromotionTiers.buyQuantity.toString())
                  ? 5.0
                  : 0.0,
        ),
        getPromotionTiersValueText(
            viewModel.showPaymentView(mPromotionTiers.getQuantity.toString()),
            "Get Quantity",
            sValue: mPromotionTiers.getQuantity.toString()),
        SizedBox(
          width:
              viewModel.showPaymentView(mPromotionTiers.getQuantity.toString())
                  ? 5.0
                  : 0.0,
        ),
        getPromotionTiersValueText(
            viewModel.showPaymentView(mPromotionTiers.amount.toString()),
            "Amount",
            sValue: mPromotionTiers.amount.toString()),
      ],
    );
  }

  Widget getPromotionTiersValueText(bool sTitle, String sShowTitle,
      {String? sValue}) {
    if (sTitle) {
      return Expanded(
        flex: 2,
        child: sValue.toString() == "null"
            ? Text(
                sShowTitle,
                style: Theme.of(context).textTheme.labelMedium,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                maxLines: 1,
              )
            : sShowTitle.toLowerCase().contains("quantity")
                ? Text(
                    sValue!,
                    style: Theme.of(context).textTheme.caption,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  )
                : sShowTitle.toLowerCase().contains("amount")
                    ? Text(
                        "RM ${double.parse(sValue!).toStringAsFixed(2)}",
                        style: Theme.of(context).textTheme.caption,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      )
                    : Text(
                        "${double.parse(sValue!).toStringAsFixed(2)}%",
                        style: Theme.of(context).textTheme.caption,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
      );
    }
    return Container();
  }

  @override
  onClickProductsTable(Products mProduct) {
    selectedProduct = mProduct;
  }
}
