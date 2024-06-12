import 'package:flutter/material.dart';
import 'package:jakel_base/constants.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/VouchersListResponse.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_base/widgets/nodatawidget/NoDataWidget.dart';
import 'package:jakel_pos/modules/customers/CustomersViewModel.dart';

class CustomerVouchersWidget extends StatefulWidget {
  final Customers customers;
  final Function? onSelected;

  const CustomerVouchersWidget(
      {Key? key, required this.customers, this.onSelected})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CustomerVouchersWidgetState();
  }
}

class _CustomerVouchersWidgetState extends State<CustomerVouchersWidget> {
  final viewModel = CustomersViewModel();

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
          width: 600,
          height: 700,
          child: MyDataContainerWidget(
            child: getBodyWidget(),
          ),
        ));
  }

  Widget getBodyWidget() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(getHeader());

    widgets.add(const SizedBox(
      height: 10,
    ));
    widgets.add(const Divider());

    widgets.add(const SizedBox(
      height: 10,
    ));

    if (widget.customers.customerVouchers == null ||
        widget.customers.customerVouchers!.isEmpty) {
      widgets.add(const SizedBox(
        height: 200,
        child: NoDataWidget(),
      ));
    } else {
      widget.customers.customerVouchers?.forEach((element) {
        widgets.add(customerVoucherRowWidget(element));
        widgets.add(const Divider());
      });
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            child: Text(
          "${widget.customers.firstName}'s vouchers",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        )),
        MyInkWellWidget(
            child: const Icon(Icons.close),
            onTap: () {
              Navigator.pop(context);
            })
      ],
    );
  }

  Widget customerVoucherRowWidget(CustomerVouchers voucher) {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(Text("${voucher.voucherType}"));
    widgets.add(const SizedBox(height: 10));
    widgets.add(Row(
      children: [
        Expanded(
          flex: 3,
          child: Text("${voucher.number}"),
        ),
        Expanded(child: Text("Type : ${voucher.discountType}"))
      ],
    ));
    widgets.add(const SizedBox(height: 10));
    widgets.add(Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            "Used At ",
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        Expanded(
            child: Text(
          voucher.usedAt ?? noData,
          style: Theme.of(context).textTheme.caption,
        ))
      ],
    ));

    widgets.add(const SizedBox(height: 10));
    widgets.add(Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            viewModel.voucherDescription(voucher),
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        Expanded(
            child: Text(
          "Expiry : ${voucher.expiryDate ?? noData}",
          style: Theme.of(context).textTheme.caption,
        ))
      ],
    ));

    widgets.add(const SizedBox(height: 10));

    return MyInkWellWidget(
        child: IntrinsicHeight(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: widgets),
        ),
        onTap: () {
          if (widget.onSelected != null) {
            Navigator.pop(context);
            widget.onSelected!(Vouchers.fromJson(voucher.toJson()));
          }
        });
  }
}
