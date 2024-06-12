import 'package:flutter/material.dart';
import 'package:jakel_base/constants.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_pos/modules/giftcard/GiftCardViewModel.dart';
import 'package:jakel_base/restapi/giftcards/model/GiftCardsResponse.dart';

class GiftCardDataTableSource extends DataTableSource {
  final List<GiftCards> filteredLists;
  final BuildContext context;
  final GiftCards? selectedGiftCards;
  final GiftCardViewModel viewModel;
  final GiftCardDataTableSourceInterface mGiftCardDataTableSourceInterface;

  GiftCardDataTableSource(
      this.filteredLists,
      this.context,
      this.selectedGiftCards,
      this.viewModel,
      this.mGiftCardDataTableSourceInterface);

  @override
  DataRow? getRow(int index) {
    GiftCards mGiftCards = filteredLists[index];
    Color color = getWhiteColor(context);
    if (selectedGiftCards != null && mGiftCards.id == selectedGiftCards?.id) {
      color = Theme.of(context).colorScheme.onPrimaryContainer;
    }
    return DataRow(
      color: MaterialStateColor.resolveWith((states) {
        return color;
      }),
      onSelectChanged: (value) async {
        mGiftCardDataTableSourceInterface.onClickGiftCardTable(mGiftCards);
      },
      cells: <DataCell>[
        DataCell(Align(
          alignment: Alignment.center,
          child: Text((index + 1).toString(),
              style: Theme.of(context).textTheme.bodyMedium),
        )),
        DataCell(Align(
          alignment: Alignment.center,
          child: Text("${mGiftCards.id}",
              style: Theme.of(context).textTheme.bodyMedium),
        )),
        DataCell(Align(
          alignment: Alignment.center,
          child: Text(mGiftCards.type!.name!.toString(),
              style: Theme.of(context).textTheme.bodyMedium),
        )),
        DataCell(Align(
          alignment: Alignment.center,
          child: Text(mGiftCards.number.toString(),
              style: Theme.of(context).textTheme.bodyMedium),
        )),
        DataCell(Align(
          alignment: Alignment.center,
          child: Text(
              mGiftCards.expiryDate == null
                  ? noData
                  : mGiftCards.expiryDate.toString(),
              style: Theme.of(context).textTheme.bodyMedium),
        )),
        DataCell(Align(
          alignment: Alignment.center,
          child: Text("RM ${mGiftCards.totalAmount!.toStringAsFixed(2)}",
              style: Theme.of(context).textTheme.bodyMedium),
        )),
        DataCell(Align(
          alignment: Alignment.center,
          child: Text("RM ${mGiftCards.availableAmount!.toStringAsFixed(2)}",
              style: Theme.of(context).textTheme.bodyMedium),
        )),
        DataCell(Align(
          alignment: Alignment.center,
          child: Text(mGiftCards.status!.key.toString(),
              style: Theme.of(context).textTheme.bodyMedium),
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => filteredLists.length;

  @override
  int get selectedRowCount => 0;

  void sort<T>(Comparable<T> Function(GiftCards d) getField, bool ascending) {
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

class GiftCardDataTableSourceInterface {
  onClickGiftCardTable(GiftCards mGiftCards) {}
}
