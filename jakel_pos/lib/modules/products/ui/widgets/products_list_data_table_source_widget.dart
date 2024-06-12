import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/products/model/ProductsResponse.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_pos/modules/products/ProductsViewModel.dart';

class ProductsDataTableSource extends DataTableSource {
  final List<Products> filteredLists;
  final BuildContext context;
  final Products? selectedProduct;
  final ProductsViewModel viewModel;
  final ProductsDataTableSourceInterface mProductsDataTableSourceInterface;

  ProductsDataTableSource(
      this.filteredLists,
      this.context,
      this.selectedProduct,
      this.viewModel,
      this.mProductsDataTableSourceInterface);

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
        mProductsDataTableSourceInterface.onClickProductsTable(product);
      },
      cells: <DataCell>[
        DataCell(Align(
          alignment: Alignment.center,
          child: Text((index+1).toString(),
              style: Theme.of(context).textTheme.bodyMedium),
        )),
        DataCell(Align(
          alignment: Alignment.center,
          child: Text("${product.id}",
              style: Theme.of(context).textTheme.bodyMedium),
        )),
        DataCell(
          Align(
            alignment: Alignment.centerLeft,
            child: Text(product.name ?? '',
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
        DataCell(Align(
          alignment: Alignment.center,
          child: Text(product.upc??"",
              style: Theme.of(context).textTheme.bodyMedium),
        )),
        DataCell(Align(
          alignment: Alignment.center,
          child: Text(product.ean??"",
              style: Theme.of(context).textTheme.bodyMedium),
        )),
        DataCell(Align(
          alignment: Alignment.center,
          child: Text(product.articleNumber??"",
              style: Theme.of(context).textTheme.bodyMedium),
        )),
        DataCell(
          Align(
            alignment: Alignment.centerLeft,
            child: Text(product.code??"",
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
        DataCell(
          Text(viewModel.price(product),
              style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataCell(
          Text(viewModel.unitOfMeasure(product),
              style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataCell(
          Align(
            alignment: Alignment.centerLeft,
            child: Text(viewModel.season(product),
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

class ProductsDataTableSourceInterface {
  onClickProductsTable(Products mProduct){
  }
}

