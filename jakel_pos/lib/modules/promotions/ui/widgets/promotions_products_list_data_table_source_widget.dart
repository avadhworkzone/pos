import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/products/model/ProductsResponse.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_pos/modules/promotions/PromotionsViewModel.dart';

class PromotionsProductsDataTableSource extends DataTableSource {
  final List<Products> filteredLists;
  final BuildContext context;
  final Products? selectedProduct;
  final PromotionsViewModel viewModel;
  final PromotionsProductsDataTableSourceInterface
      mPromotionsProductsDataTableSourceInterface;

  PromotionsProductsDataTableSource(
      this.filteredLists,
      this.context,
      this.selectedProduct,
      this.viewModel,
      this.mPromotionsProductsDataTableSourceInterface);

  @override
  DataRow? getRow(int index) {
    Products product = filteredLists[index];
    Color color = getWhiteColor(context);
    if (selectedProduct != null && product.id == selectedProduct?.id) {
      color = Theme.of(context).colorScheme.onPrimaryContainer;
    }
    return DataRow(
      color: MaterialStateColor.resolveWith((states) {
        return color;
      }),
      onSelectChanged: (value) async {
        mPromotionsProductsDataTableSourceInterface
            .onClickProductsTable(product);
      },
      cells: <DataCell>[
        DataCell(Align(
          alignment: Alignment.center,
          child: SelectableText((index + 1).toString(),
              style: Theme.of(context).textTheme.bodyMedium),
        )),
        DataCell(Align(
          alignment: Alignment.center,
          child: SelectableText("${product.id}",
              style: Theme.of(context).textTheme.bodyMedium),
        )),
        DataCell(
          Align(
            alignment: Alignment.centerLeft,
            child: SelectableText(product.name ?? '',
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
        DataCell(Align(
          alignment: Alignment.center,
          child: SelectableText(product.upc ?? "",
              style: Theme.of(context).textTheme.bodyMedium),
        )),
        DataCell(Align(
          alignment: Alignment.center,
          child: SelectableText(product.ean ?? "",
              style: Theme.of(context).textTheme.bodyMedium),
        )),
        DataCell(Align(
          alignment: Alignment.center,
          child: SelectableText(product.articleNumber ?? "",
              style: Theme.of(context).textTheme.bodyMedium),
        )),
        DataCell(
          Align(
            alignment: Alignment.centerLeft,
            child: SelectableText(product.code ?? "",
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
        DataCell(
          SelectableText(viewModel.price(product),
              style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataCell(
          SelectableText(viewModel.unitOfMeasure(product),
              style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataCell(
          Align(
            alignment: Alignment.centerLeft,
            child: SelectableText(viewModel.season(product),
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => filteredLists.length;

  @override
  int get selectedRowCount => 0;

  void sort<T>(Comparable<T> Function(Products d) getField, bool ascending) {
    filteredLists.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });

    notifyListeners();
  }
}

class PromotionsProductsDataTableSourceInterface {
  onClickProductsTable(Products mProduct) {}
}
