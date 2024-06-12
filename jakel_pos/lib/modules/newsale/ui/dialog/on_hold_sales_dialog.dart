import 'package:flutter/material.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_base/widgets/nodatawidget/NoDataWidget.dart';
import 'package:jakel_pos/modules/newsale/NewSaleViewModel.dart';

import 'package:jakel_base/database/sale/model/CartSummary.dart';

class OnHoldSalesDialog extends StatefulWidget {
  final Function onSaleSelected;
  final Function onDeleted;

  const OnHoldSalesDialog({
    Key? key,
    required this.onSaleSelected,
    required this.onDeleted,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OnHoldSalesDialogState();
  }
}

class _OnHoldSalesDialogState extends State<OnHoldSalesDialog>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  final newSaleViewModel = NewSaleViewModel();

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
          width: 800,
          height: 600,
          child: MyDataContainerWidget(
            child: getRootWidget(),
          ),
        ));
  }

  Widget getRootWidget() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(getHeader());

    widgets.add(const Divider());

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(salesItemHeader());

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(Expanded(child: getOnHoldSales()));

    widgets.add(const SizedBox(
      height: 10,
    ));

    return Column(
      children: widgets,
    );
  }

  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "On Hold Sales",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        MyInkWellWidget(
            child: const Icon(Icons.close),
            onTap: () {
              Navigator.pop(context);
            })
      ],
    );
  }

  Widget getOnHoldSales() {
    return FutureBuilder(
        future: newSaleViewModel.getAllOnHoldSales(),
        builder:
            (BuildContext context, AsyncSnapshot<List<CartSummary>> snapshot) {
          if (snapshot.hasError) {
            MyLogUtils.logDebug("snapshot.hasError : ${snapshot.hasError}");
            return Container();
          }
          if (snapshot.hasData) {
            if (snapshot.data != null && snapshot.data!.isNotEmpty) {
              return holdSalesListWidget(snapshot.data!);
            }
            return const NoDataWidget();
          }
          return const MyLoadingWidget();
        });
  }

  Widget holdSalesListWidget(List<CartSummary> cartSummaryList) {
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(
              color: Theme.of(context).indicatorColor,
            ),
        shrinkWrap: false,
        itemCount: cartSummaryList.length,
        itemBuilder: (context, index) {
          return holdSalesRowWidget(cartSummaryList[index], index);
        });
  }

  Widget salesItemHeader() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4), topRight: Radius.circular(4)),
          color: Theme.of(context).colorScheme.tertiaryContainer,
          border:
              Border.all(width: 0.5, color: Theme.of(context).indicatorColor)),
      height: 50,
      child: Row(
        children: const [
          SizedBox(width: 20),
          SizedBox(
            width: 30,
            child: Text("#"),
          ),
          Expanded(flex: 4, child: Text("Sale Id")),
          Expanded(
              flex: 2,
              child: Center(
                child: Text("Items Count"),
              )),
          Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.center,
                child: Text("Member"),
              )),
          SizedBox(width: 100),
          SizedBox(width: 20),
          SizedBox(width: 100),
          SizedBox(width: 20),
        ],
      ),
    );
  }

  Widget holdSalesRowWidget(CartSummary cartSummary, int index) {
    return Row(
      children: [
        const SizedBox(width: 20),
        SizedBox(
          width: 30,
          child: SelectableText('${index + 1}'),
        ),
        Expanded(flex: 4, child: Text('${cartSummary.offlineSaleId}')),
        Expanded(
            flex: 2,
            child: Center(
              child: Text('${cartSummary.cartItems?.length ?? 0}'),
            )),
        Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.center,
              child: Text(cartSummary.customers?.firstName ?? '--'),
            )),
        SizedBox(
          width: 100,
          child: OutlinedButton.icon(
              onPressed: () {
                newSaleViewModel.onHoldSaleReleased(cartSummary);
                widget.onSaleSelected(cartSummary);
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.check_circle,
                size: 15,
              ),
              label: const Text(
                "Select",
              )),
        ),
        const SizedBox(width: 20),
        SizedBox(
          width: 100,
          child: OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDeleted(cartSummary);
              },
              icon: const Icon(
                Icons.delete,
                size: 15,
              ),
              label: const Text(
                "Delete",
              )),
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}
