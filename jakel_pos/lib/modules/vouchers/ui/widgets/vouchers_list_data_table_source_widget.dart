import 'package:flutter/material.dart';
import 'package:jakel_base/constants.dart';
import 'package:jakel_base/restapi/vouchers/model/VouchersListResponse.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_pos/modules/Vouchers/VouchersViewModel.dart';

class VouchersDataTableSource extends DataTableSource {
  final List<Vouchers> filteredLists;
  final BuildContext context;
  final Vouchers? selectedVouchers;
  final VouchersViewModel viewModel;
  final VouchersDataTableSourceInterface mVouchersDataTableSourceInterface;

  VouchersDataTableSource(
      this.filteredLists,
      this.context,
      this.selectedVouchers,
      this.viewModel,
      this.mVouchersDataTableSourceInterface);

  @override
  DataRow? getRow(int index) {
    Vouchers mVouchers = filteredLists[index];
    Color color = getWhiteColor(context);
    if (selectedVouchers != null && mVouchers.id == selectedVouchers?.id) {
      color = Theme.of(context).colorScheme.onPrimaryContainer;
    }
    return DataRow(
      color: MaterialStateColor.resolveWith((states) {
        return color;
      }),
      onSelectChanged: (value) async {
        mVouchersDataTableSourceInterface.onClickProductsTable(mVouchers);
      },
      cells: <DataCell>[
        DataCell(Align(
          alignment: Alignment.center,
          child: Text((index + 1).toString(),
              style: Theme.of(context).textTheme.bodyMedium),
        )),
        DataCell(Align(
          alignment: Alignment.center,
          child: Text("${mVouchers.id}",
              style: Theme.of(context).textTheme.bodyMedium),
        )),
        DataCell(
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
                mVouchers.customerId == null
                    ? noData
                    : mVouchers.customerId.toString(),
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
        DataCell(
          Align(
            alignment: Alignment.centerLeft,
            child: Text(mVouchers.discountType.toString(),
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
        DataCell(
          Align(
            alignment: Alignment.centerLeft,
            child: Text(mVouchers.number.toString(),
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
        DataCell(
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
                "RM ${mVouchers.minimumSpendAmount!.toStringAsFixed(2)}",
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
        DataCell(
          Align(
            alignment: Alignment.centerLeft,
            child: Text("${mVouchers.percentage!.toStringAsFixed(2)}%",
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
        DataCell(
          Align(
            alignment: Alignment.centerLeft,
            child: Text("RM ${mVouchers.flatAmount!.toStringAsFixed(2)}",
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
        DataCell(
          Align(
            alignment: Alignment.centerLeft,
            child: Text(mVouchers.expiryDate.toString(),
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => filteredLists.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;

  void sort<T>(Comparable<T> Function(Vouchers d) getField, bool ascending) {
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

class VouchersDataTableSourceInterface {
  onClickProductsTable(Vouchers mVouchers) {}
}
