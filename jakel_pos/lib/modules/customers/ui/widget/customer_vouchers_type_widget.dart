import 'package:flutter/material.dart';
import 'package:jakel_base/constants.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/restapi/generatememberloyaltypointvoucher/model/GenerateMemberLoyaltyPointVoucherRequest.dart';
import 'package:jakel_base/restapi/generatememberloyaltypointvoucher/model/GenerateMemberLoyaltyPointVoucherResponse.dart';
import 'package:jakel_base/restapi/loyaltypointvoucherconfiguration/model/LoyaltyPointVoucherConfigurationResponse.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_base/widgets/nodatawidget/NoDataWidget.dart';
import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';
import 'package:jakel_pos/modules/customers/CustomersRedeemPointToVouchersViewModel.dart';

class CustomerVouchersTypeWidget extends StatefulWidget {
  final Vouchers vouchers;
  final double useMinimumSpendAmount;
  final Function? onSelected;

  const CustomerVouchersTypeWidget(
      {Key? key,
      required this.vouchers,
      required this.useMinimumSpendAmount,
      this.onSelected})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CustomerVouchersTypeWidgetState();
  }
}

class _CustomerVouchersTypeWidgetState
    extends State<CustomerVouchersTypeWidget> {
  final customersRedeemPointToVouchersViewModel =
      CustomersRedeemPointToVouchersViewModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
          width: 400,
          height: 500,
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
    int pog = -1;
    widget.vouchers.promotionTiers?.forEach((element) {
      pog++;
      widgets.add( showView(pog));
      widgets.add(const SizedBox(
        height: 10,
      ));
      widgets.add(const Divider());
    });

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
        const Flexible(
            child: Text(
          "Vouchers Type List",
          style: TextStyle(
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

  Widget showView(int pog) {

    return GestureDetector(
      onTap: (){
        widget.onSelected!(pog);
        Navigator.pop(context);
      },
      child: Container(
        color: Colors.transparent,
        child: Text(customersRedeemPointToVouchersViewModel.voucherType(
            widget.vouchers.promotionTiers![pog], widget.useMinimumSpendAmount ?? 0.00)),
      ),
    );
  }
}
