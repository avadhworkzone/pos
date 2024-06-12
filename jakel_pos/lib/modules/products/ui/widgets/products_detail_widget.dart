import 'package:flutter/material.dart';
import 'package:jakel_base/constants.dart';
import 'package:jakel_base/jakel_base.dart';
import 'package:jakel_base/restapi/products/model/ProductsResponse.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';
import 'package:jakel_base/widgets/custom/my_small_box_widget.dart';
import 'package:jakel_pos/modules/products/ProductsViewModel.dart';

class ProductsDetailWidget extends StatefulWidget {
  final Products selectedProduct;

  const ProductsDetailWidget({Key? key, required this.selectedProduct})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProductsDetailWidgetState();
  }
}

class _ProductsDetailWidgetState extends State<ProductsDetailWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final viewModel = ProductsViewModel();

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    viewModel.closeObservable();
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
          title: "Name", value: widget.selectedProduct.name ?? noData),
    ));
    widgets.add(const SizedBox(
      height: 20,
    ));

    widgets.add(SizedBox(
      width: double.infinity,
      child: MySmallBoxWidget(
          title: "Price",
          value:
              getReadableAmount(getCurrency(), widget.selectedProduct.price)),
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

    widgets.add(Row(
      children: [
        Expanded(
            child: MySmallBoxWidget(
                title: "Unit Of Measure",
                value: widget.selectedProduct.unitOfMeasure?.name ?? noData)),
        Expanded(
            child: MySmallBoxWidget(
                title: "Season",
                value: widget.selectedProduct.season?.name ?? noData)),
      ],
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(Row(
      children: [
        Expanded(
            child: MySmallBoxWidget(
                title: "Department",
                value: widget.selectedProduct.department?.name ?? noData)),
        Expanded(
            child: MySmallBoxWidget(
                title: "Sub Department",
                value: widget.selectedProduct.subDepartment ?? noData)),
      ],
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(Row(
      children: [
        Expanded(
            child: MySmallBoxWidget(
                title: "Color",
                value: widget.selectedProduct.color?.name ?? noData)),
        Expanded(
            child: MySmallBoxWidget(
                title: "Size",
                value: widget.selectedProduct.size?.name ?? noData)),
      ],
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(Row(
      children: [
        Expanded(
            child: MySmallBoxWidget(
                title: "Brand",
                value: widget.selectedProduct.brand?.name ?? noData)),
        Expanded(
            child: MySmallBoxWidget(
                title: "Style",
                value: widget.selectedProduct.style?.name ?? noData)),
      ],
    ));

    widgets.add(const SizedBox(
      height: 20,
    ));

    widgets.add(Padding(
      padding: const EdgeInsets.all(8),
      child: Text("Inventory Details",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold)),
    ));

    widgets.add(const SizedBox(
      height: 20,
    ));

    widgets.add(inventoryDetails());

    if (widget.selectedProduct.batchNumbers != null &&
        widget.selectedProduct.batchNumbers!.isNotEmpty) {
      widgets.add(const SizedBox(
        height: 20,
      ));
      widgets.add(Padding(
        padding: const EdgeInsets.all(8),
        child: Text("Batch Details",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold)),
      ));

      widgets.add(const SizedBox(
        height: 20,
      ));

      widgets.add(batchDetails());
    }

    if (widget.selectedProduct.categories != null &&
        widget.selectedProduct.categories!.isNotEmpty) {
      widgets.add(const SizedBox(
        height: 20,
      ));
      widgets.add(Padding(
        padding: const EdgeInsets.all(8),
        child: Text("Categories",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold)),
      ));

      widgets.add(const SizedBox(
        height: 20,
      ));

      widgets.add(getCategory());
    }

    if (widget.selectedProduct.tags != null &&
        widget.selectedProduct.tags!.isNotEmpty) {
      widgets.add(const SizedBox(
        height: 20,
      ));
      widgets.add(Padding(
        padding: const EdgeInsets.all(8),
        child: Text("Tags",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold)),
      ));

      widgets.add(const SizedBox(
        height: 20,
      ));

      widgets.add(getTags());
    }

    widgets.add(const SizedBox(
      height: 20,
    ));

    return widgets;
  }

  Widget inventoryDetails() {
    List<Widget> widgets = List.empty(growable: true);

    widgets
        .add(_getKeyValue("UPC", widget.selectedProduct.upc ?? noData, 1, 2));

    widgets.add(const Divider());

    widgets
        .add(_getKeyValue("EAN", widget.selectedProduct.ean ?? noData, 1, 2));

    widgets.add(const Divider());

    widgets.add(_getKeyValue(
        "Custom SKU", widget.selectedProduct.customSku ?? noData, 1, 2));

    widgets.add(const Divider());

    widgets.add(_getKeyValue(
        "SKU", widget.selectedProduct.manufacturerSku ?? noData, 1, 2));

    widgets.add(const Divider());

    widgets.add(_getKeyValue("Article Number",
        widget.selectedProduct.articleNumber ?? noData, 1, 2));

    widgets.add(const Divider());

    widgets.add(_getKeyValue(
        "Stock", getOnlyReadableAmount(widget.selectedProduct.stock), 1, 2));

    return MyDataContainerWidget(
      child: IntrinsicHeight(
          child: Column(
        children: widgets,
      )),
    );
  }

  Widget batchDetails() {
    List<Widget> widgets = List.empty(growable: true);

    widget.selectedProduct.batchNumbers?.forEach((element) {
      widgets.add(_getKeyValue(element.batchNumber ?? noData,
          getOnlyReadableAmount(element.stock), 2, 1));

      widgets.add(const Divider());
    });
    return MyDataContainerWidget(
      child: IntrinsicHeight(
          child: Column(
        children: widgets,
      )),
    );
  }

  Widget getCategory() {
    List<Widget> widgets = List.empty(growable: true);

    widget.selectedProduct.categories?.forEach((element) {
      widgets.add(Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            border: Border.all(
                color: Theme.of(context).primaryColor.withOpacity(0.5)),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        padding: const EdgeInsets.all(5),
        child: Text(
          element.name ?? noData,
          style: Theme.of(context).textTheme.caption,
        ),
      ));
    });

    return IntrinsicHeight(
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Wrap(
          spacing: 3.0,
          runSpacing: 3.0,
          children: widgets,
        ),
      )),
    );
  }

  Widget getTags() {
    List<Widget> widgets = List.empty(growable: true);

    widget.selectedProduct.tags?.forEach((element) {
      widgets.add(Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            border: Border.all(
                color: Theme.of(context).primaryColor.withOpacity(0.5)),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        padding: const EdgeInsets.all(5),
        child: Text(
          element.name ?? noData,
          style: Theme.of(context).textTheme.caption,
        ),
      ));
    });

    return IntrinsicHeight(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Wrap(
            spacing: 3.0,
            runSpacing: 3.0,
            children: widgets,
          ),
        ),
      ),
    );
  }

  Widget _getKeyValue(
    String key,
    String value,
    int keyWeight,
    int valueWeight,
  ) {
    return Row(children: [
      Expanded(
        flex: keyWeight,
        child: Text(
          key,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      Expanded(
          flex: valueWeight,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.bodyLarge,
          ))
    ]);
  }
}
