import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_pos/modules/promotions/PromotionsViewModel.dart';

class PromotionsDataTableSource extends DataTableSource {
  final List<Promotions> filteredLists;
  final BuildContext context;
  final Promotions? selectedProduct;
  final PromotionsViewModel viewModel;
  final PromotionsDataTableSourceInterface mPromotionsDataTableSourceInterface;

  PromotionsDataTableSource(
      this.filteredLists,
      this.context,
      this.selectedProduct,
      this.viewModel,
      this.mPromotionsDataTableSourceInterface);

  @override
  DataRow? getRow(int index) {
    Promotions mPromotions = filteredLists[index];
    Color color = getWhiteColor(context);
    if (selectedProduct != null && mPromotions.id == selectedProduct?.id) {
      color = Theme.of(context).colorScheme.onPrimaryContainer;
    }
    return DataRow(
      color: MaterialStateColor.resolveWith((states) {
        return color;
      }),
      onSelectChanged: (value) async {
        mPromotionsDataTableSourceInterface.onClickPromotionsTable(mPromotions);
      },
      cells: <DataCell>[
        DataCell(Align(
          alignment: Alignment.center,
          child: Text((index + 1).toString(),
              style: Theme.of(context).textTheme.bodyMedium),
        )),
        DataCell(Align(
          alignment: Alignment.centerLeft,
          child: Text("${mPromotions.id}",
              style: Theme.of(context).textTheme.bodyMedium),
        )),
        DataCell(
          Align(
            alignment: Alignment.centerLeft,
            child: Text(viewModel.getName(mPromotions),
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
        DataCell(
          Align(
            alignment: Alignment.centerLeft,
            child: Text(viewModel.getPromotionApplicableType(mPromotions),
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
        DataCell(
          Text(viewModel.getType(mPromotions),
              style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataCell(
          Text(viewModel.getPromotionType(mPromotions),
              style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataCell(
          Align(
            alignment: Alignment.centerLeft,
            child: Text(viewModel.getTimeFrameLimit(mPromotions),
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

  void sort<T>(Comparable<T> Function(Promotions d) getField, bool ascending) {
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

class PromotionsDataTableSourceInterface {
  onClickPromotionsTable(Promotions mPromotions) {}
}
