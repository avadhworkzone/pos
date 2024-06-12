import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/VoucherConfigurationResponse.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_pos/modules/vouchers/VouchersViewModel.dart';

class GenerateBirthdayVoucherDialog extends StatefulWidget {
  final Customers customers;
  final VoucherConfiguration birthConfiguration;
  final Function generateVoucher;

  const GenerateBirthdayVoucherDialog(
      {Key? key,
      required this.customers,
      required this.birthConfiguration,
      required this.generateVoucher})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GenerateBirthdayVoucherDialogState();
  }
}

class _GenerateBirthdayVoucherDialogState
    extends State<GenerateBirthdayVoucherDialog> {
  final viewModel = VouchersViewModel();

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
          child: MyDataContainerWidget(
            child: getRootWidget(),
          ),
        ));
  }

  Widget getRootWidget() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(getHeader());

    widgets.add(const SizedBox(
      height: 10,
    ));
    widgets.add(const Divider());

    widgets.add(const SizedBox(
      height: 10,
    ));
    widgets.add(
      Text(
          'Happy Birthday vouchers are enabled for the members to get their rewards as discount voucher during member birthday month.',
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.caption),
    );

    widgets.add(const SizedBox(
      height: 10,
    ));
    widgets.add(
      Text('Happy Birthday',
          textAlign: TextAlign.start,
          style:
              TextStyle(color: Theme.of(context).primaryColor, fontSize: 30)),
    );

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(
      Text('${widget.customers.firstName}',
          textAlign: TextAlign.start,
          style:
              TextStyle(color: Theme.of(context).primaryColor, fontSize: 30)),
    );

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(
      Text(viewModel.birthdayVoucherConfiguration(widget.birthConfiguration),
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.bodyMedium),
    );

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(MyOutlineButton(
        text: "Generate Birthday Voucher",
        onClick: () {
          widget.generateVoucher();
          Navigator.of(context).pop();
        }));

    return IntrinsicHeight(
      child: Column(
        children: widgets,
      ),
    );
  }

  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Birthday Voucher",
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
}
