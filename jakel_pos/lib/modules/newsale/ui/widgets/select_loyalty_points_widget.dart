import 'package:flutter/material.dart';
import 'package:jakel_base/jakel_base.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/restapi/customers/model/MemberShipPointsData.dart';

import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/button/MyPrimaryButton.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';

import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';
import 'package:jakel_pos/modules/customers/CustomersViewModel.dart';

class SelectLoyaltyPointsWidget extends StatefulWidget {
  final Customers customers;
  final double totalPayableAmount;
  final int? usesLoyaltyPaymentPoints;
  final Function savePoints;
  final Function removePoints;

  const SelectLoyaltyPointsWidget({
    Key? key,
    this.usesLoyaltyPaymentPoints,
    required this.customers,
    required this.totalPayableAmount,
    required this.savePoints,
    required this.removePoints,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SelectLoyaltyPointsState();
  }
}

class _SelectLoyaltyPointsState extends State<SelectLoyaltyPointsWidget> {
  bool callApi = false;
  final pointsController = TextEditingController();
  final pointsNode = FocusNode();

  final amountController = TextEditingController();
  final amountNode = FocusNode();
  final viewModel = CustomersViewModel();
  MemberShipPointsData? memberShipPointsData;
  int pointsToBeUsed = 0;
  double amountTobeUsedFromPoints = 0;
  var isLoadedOnce = false;
  int usesLoyaltyPaymentPoints = 0;
  double usesLoyaltyPaymentAmount = 0.0;
  int availablePoints = 0;
  double availableAmount = 0;

  @override
  void initState() {
    usesLoyaltyPaymentPoints = widget.usesLoyaltyPaymentPoints ?? 0;
    usesLoyaltyPaymentPoints =
        usesLoyaltyPaymentPoints == -1 ? 0 : usesLoyaltyPaymentPoints;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        height: 600,
        width: 550,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getHeader(),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            Expanded(child: getMemberPoints())
          ],
        ),
      ),
    );
  }

  Widget getMemberPoints() {
    if (isLoadedOnce) {
      return getRootWidget();
    }
    return FutureBuilder(
        future: viewModel.getCustomerPointsAsAmount(
            widget.customers, widget.totalPayableAmount),
        builder: (BuildContext context,
            AsyncSnapshot<MemberShipPointsData> snapshot) {
          if (snapshot.hasError) {
            return const Text("Failed to fetch data. Please try again later!");
          }
          if (snapshot.hasData) {
            isLoadedOnce = true;
            memberShipPointsData = snapshot.data;
            availablePoints = memberShipPointsData?.points ?? 0;
            pointsToBeUsed = memberShipPointsData?.points ?? 0;
            amountTobeUsedFromPoints = memberShipPointsData?.amount ?? 0.0;
            availableAmount =
                customRound(memberShipPointsData?.amount ?? 0.0, 2);
            if (usesLoyaltyPaymentPoints != 0) {
              if (usesLoyaltyPaymentPoints != 0) {
                usesLoyaltyPaymentAmount = usesLoyaltyPaymentPoints /
                    (memberShipPointsData?.loyaltyPointsPerRinggit ?? 0.0);
              }
              pointsController.text = '$usesLoyaltyPaymentPoints';
              amountController.text = '$usesLoyaltyPaymentAmount';
            } else {
              pointsController.text = '$pointsToBeUsed';
              amountController.text = '$amountTobeUsedFromPoints';
            }
            return getRootWidget();
          }
          return const Text("Fetching ...");
        });
  }

  Widget getRootWidget() {
    pointsToBeUsed = getInValue(pointsController.text);

    List<Widget> widgets = List.empty(growable: true);

    widgets.add(Text(
        "Total Due Amount  : ${getReadableAmount(getCurrency(), widget.totalPayableAmount)}"));

    widgets.add(const SizedBox(
      height: 20,
    ));

    widgets.add(const Divider());

    widgets.add(const SizedBox(
      height: 20,
    ));

    widgets.add(Text("Available Points : $availablePoints"));

    widgets.add(const SizedBox(
      height: 20,
    ));

    widgets.add(Text("Available Points As RM : $availableAmount"));

    widgets.add(const SizedBox(
      height: 20,
    ));

    widgets.add(const Divider());

    widgets.add(const SizedBox(
      height: 20,
    ));

    // Enter Points
    widgets.add(
      MyTextFieldWidget(
        enabled: usesLoyaltyPaymentPoints == 0 ? true : false,
        controller: pointsController,
        node: pointsNode,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          try {
            int points = getInValue(value);
            if (points > (memberShipPointsData?.points ?? 0)) {
              showToast("Sorry,you don't have enough points to add.", context);
              pointsController.text = "0";
              pointsToBeUsed = 0;
              amountTobeUsedFromPoints = 0.0;
            } else {
              pointsToBeUsed = points;
              if ((memberShipPointsData?.loyaltyPointsPerRinggit ?? 0.0) <= 0) {
                amountTobeUsedFromPoints = 0.0;
              } else {
                amountTobeUsedFromPoints = points /
                    (memberShipPointsData?.loyaltyPointsPerRinggit ?? 0.0);
              }
            }

            setState(() {
              amountController.text =
                  customRound(amountTobeUsedFromPoints, 2).toString();
            });
          } catch (e) {
            showToast("Please enter valid points to be used.", context);
          }
        },
        hint: "Enter Points To Be Used",
      ),
    );
    widgets.add(const SizedBox(
      height: 20,
    ));

    // Enter Rm to be used.
    widgets.add(
      MyTextFieldWidget(
        enabled: usesLoyaltyPaymentPoints == 0 ? true : false,
        controller: amountController,
        node: amountNode,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          try {
            double totalValue = getDoubleValue(value);
            int points = getInValue(totalValue *
                (memberShipPointsData?.loyaltyPointsPerRinggit ?? 0.0));

            MyLogUtils.logDebug(
                "amountController totalValue : $totalValue & points : $points");

            if (points > (memberShipPointsData?.points ?? 0)) {
              showToast("Sorry,you don't have enough points to add.", context);
              pointsController.text = "0";
              amountController.text = "0";
              pointsToBeUsed = 0;
              amountTobeUsedFromPoints = 0.0;
            } else {
              pointsToBeUsed = points;
              if ((memberShipPointsData?.loyaltyPointsPerRinggit ?? 0.0) <= 0) {
                amountTobeUsedFromPoints = 0.0;
              } else {
                amountTobeUsedFromPoints = totalValue;
              }
            }
            pointsController.text = '$pointsToBeUsed';
            setState(() {});
          } catch (e) {
            showToast("Please enter valid points to be used.", context);
          }
        },
        hint: "Enter RM To Be Used",
      ),
    );
    widgets.add(const SizedBox(
      height: 20,
    ));

    widgets.add(const Divider());

    widgets.add(const SizedBox(
      height: 20,
    ));
    widgets.add(Text("Points To be Used  : $pointsToBeUsed"));

    widgets.add(const SizedBox(
      height: 20,
    ));

    widgets.add(Text(
        "Points converted to : ${getReadableAmount(getCurrency(), customRound(usesLoyaltyPaymentPoints == 0 ? amountTobeUsedFromPoints : usesLoyaltyPaymentAmount, 2))}"));

    widgets.add(const SizedBox(
      height: 20,
    ));

    widgets.add(const Divider());

    widgets.add(const SizedBox(
      height: 20,
    ));

    widgets.add(buttonWidget());

    widgets.add(const SizedBox(
      height: 20,
    ));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Select Loyalty Points',
          style: TextStyle(
            fontSize: 18,
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

  Widget buttonWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        usesLoyaltyPaymentPoints == 0
            ? MyOutlineButton(text: 'Save', onClick: _save)
            : SizedBox(),
        SizedBox(
          width: usesLoyaltyPaymentPoints == 0 ? 120 : 0,
        ),
        MyPrimaryButton(
            text: "Remove",
            onClick: () {
              widget.removePoints();
              Navigator.of(context).pop();
            })
      ],
    );
  }

  void _save() {
    MyLogUtils.logDebug(
        "_save pointsToBeUsed : $pointsToBeUsed & amountTobeUsedFromPoints : ${customRound(amountTobeUsedFromPoints, 2)}");
    widget.savePoints(pointsToBeUsed, customRound(amountTobeUsedFromPoints, 2));
    Navigator.of(context).pop();
  }
}
