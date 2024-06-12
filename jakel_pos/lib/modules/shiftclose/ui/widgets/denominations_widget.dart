import 'package:flutter/material.dart';
import 'package:jakel_base/jakel_base.dart';
import 'package:jakel_base/restapi/counters/model/CloseCounterRequest.dart';
import 'package:jakel_base/restapi/counters/model/ShiftDetailsResponse.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/my_date_utils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';
import 'package:jakel_base/widgets/custom/MyIconTextWidget.dart';

import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';
import 'package:jakel_pos/modules/shiftclose/ShiftCloseViewModel.dart';
import 'package:jakel_pos/modules/shiftclose/ui/widgets/shift_close_inherited_widget.dart';
import 'package:jakel_pos/routing/route_names.dart';

import '../../../saleshistory/ui/widgets/history/manager_authorization_widget.dart';
import 'denomination_row_widget.dart';

class DenominationsWidget extends StatefulWidget {
  final CounterClosingDetails counter;
  final Function updateEnteredCash;

  const DenominationsWidget({
    Key? key,
    required this.counter,
    required this.updateEnteredCash,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DenominationsWidgetState();
  }
}

class _DenominationsWidgetState extends State<DenominationsWidget>
    with SingleTickerProviderStateMixin {
  final viewModel = ShiftCloseViewModel();
  AnimationController? _controller;
  List<Denominations> denominations = List.empty(growable: true);
  final closingBalanceCounter = TextEditingController();
  final reasonsController = TextEditingController();
  bool callApi = false;

  bool isShiftDeclarationDone = false;

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
    MyLogUtils.logDebug("Build is called now.");

    isShiftDeclarationDone = ShiftCloseInheritedWidget.of(context)
        .shiftDeclaration
        .isDeclarationDone!;
    closingBalanceCounter.text =
        getOnlyReadableAmount(viewModel.getEnteredCash(denominations));
    return Container(
      constraints: const BoxConstraints.expand(),
      child: Column(
        children: getWidgets(),
      ),
    );
  }

  Widget getTopWidget() {
    return IntrinsicHeight(
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        const SizedBox(
          width: 10,
        ),
        MyIconTextWidget(
          iconData: Icons.open_in_browser,
          text: "Open Cash Drawer",
          onTap: () async {
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return ManagerAuthorizationWidget(
                  onSuccess: () {
                    viewModel.openCashDrawer();
                    showToast("Authorized to open cash drawer.", context);
                  },
                );
              },
            );
          },
          isRightAligned: false,
        ),
        const SizedBox(
          width: 10,
        ),
      ]),
    );
  }

  List<Widget> getWidgets() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(const SizedBox(
      height: 10,
    ));
    widgets.add(getTopWidget());

    widgets.add(getRowHeader());

    widgets.add(
      Expanded(
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: MyDataContainerWidget(
            child: getDenominationsWidget(),
          ),
        ),
      ),
    );

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(Container(
      padding:
          const EdgeInsets.only(left: 20, right: 20.0, top: 5.0, bottom: 10.0),
      child: keyValueWidget(
          "Total Entered Cash",
          getReadableAmount(
              getCurrency(), viewModel.getEnteredCash(denominations)),
          Theme.of(context).primaryColor),
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));

    if (isShiftDeclarationDone) {
      widgets.add(const Divider());

      widgets.add(Padding(
        padding: const EdgeInsets.all(10.0),
        child: MyTextFieldWidget(
          controller: reasonsController,
          node: FocusNode(),
          hint: "Reason",
          onSubmitted: (value) {
            setState(() {});
          },
        ),
      ));

      widgets.add(const SizedBox(
        height: 10,
      ));

      widgets.add(runShiftCloseButton());

      widgets.add(const SizedBox(
        height: 10,
      ));

      if (ShiftCloseInheritedWidget.of(context).isPaymentMisMatch()) {
        widgets.add(const SizedBox(
          height: 10,
        ));
      }
    }

    return widgets;
  }

  Widget runShiftCloseButton() {
    MyLogUtils.logDebug("runShiftCloseButton callApi : $callApi");

    if (ShiftCloseInheritedWidget.of(context).isPaymentMisMatch() &&
        ShiftCloseInheritedWidget.of(context).shiftDeclaration.storeManagers ==
            null) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "Payments declaration is not matching with actual. "
          "Please check your declaration or get authorized from your store manager with valid reason.",
          style: Theme.of(context).textTheme.caption,
        ),
      );
    }

    if (callApi) {
      return apiWidget();
    }
    return MyOutlineButton(
        text: "Run Shift Close",
        onClick: () {
          validateAndSave();
        });
  }

  Widget keyValueWidget(String key, String value, Color valueColor) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            key,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            value,
            style: TextStyle(
                fontSize: 15, color: valueColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget getRowHeader() {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          Expanded(
              flex: 2,
              child: Text(
                "Denomination(RM)",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              )),
          const SizedBox(
            width: 30,
          ),
          Expanded(
              flex: 3,
              child: Text(
                "Quantity",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              )),
          const SizedBox(
            width: 10,
          ),
          const SizedBox(
            width: 100,
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  void validateAndSave() {
    double amount = 0.0;
    for (var element in denominations) {
      try {
        amount = amount + element.denomination! * element.quantity!;
      } catch (e) {}
    }

    // if (amount >= viewModel.getExpectedCash(widget.counter)) {
    //   closeCounter();
    // } else {
    //   showToast("Total Amount is not matching with denomination", context);
    // }

    if (closingBalanceCounter.text.isEmpty) {
      showToast("Please enter closing balance!", context);
    }
    double closingBalance = getDoubleValue(closingBalanceCounter.text);

    // if (ShiftCloseInheritedWidget
    //                 .of(context)
    //             .shiftDeclaration
    //             .paymentMismatch !=
    //         null &&
    //     ShiftCloseInheritedWidget.of(context)
    //             .shiftDeclaration
    //             .paymentMismatch ==
    //         true &&
    //     reasonsController.text.isEmpty) {
    //   showToast("Please select closing balance mismatch reason!", context);
    // }

    closeCounter();
  }

  void closeCounter() {
    if (reasonsController.text.isEmpty) {
      showToast(
          "Please enter reason to close the counter. If tally write message as  Success",
          context);
      return;
    }

    setState(() {
      callApi = true;
      MyLogUtils.logDebug("Close counter is called");
    });
  }

  Widget apiWidget() {
    MyLogUtils.logDebug("Close Counter Api Widget  is called");

    final request = CloseCounterRequest(
        denominations: denominations,
        closedByPosAt: dateTimeYmdHis24Hour(),
        closingBalance: viewModel.getEnteredCash(denominations),
        mismatchAmountReason:
            (viewModel.getPendingCash(widget.counter, denominations) !=
                    viewModel.getExpectedCash(widget.counter))
                ? reasonsController.text
                : null);

    viewModel.closeCounter(request);

    return StreamBuilder<bool>(
      stream: viewModel.boolResponseSubject,
      // ignore: missing_return, missing_return
      builder: (context, snapshot) {
        MyLogUtils.logDebug(
            "Close Counter Api snapshot.hasError :${snapshot.hasError}");
        MyLogUtils.logDebug(
            "Close Counter Api snapshot.hasData :${snapshot.hasData}");
        MyLogUtils.logDebug(
            "Close Counter Api snapshot.connectionState :${snapshot.connectionState}");

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyLoadingWidget();
        }
        if (snapshot.hasError) {
          callApi = false;
          return runShiftCloseButton();
        }
        if (snapshot.connectionState == ConnectionState.active) {
          var empResponse = snapshot.data;

          MyLogUtils.logDebug("Close Counter Api Widget : $empResponse");

          if (empResponse != null && empResponse) {
            callApi = false;
            return checkAndGoToOpenCounterScreen();
          } else {
            callApi = false;
            return runShiftCloseButton();
          }
        }
        return Container();
      },
    );
  }

  Widget getDenominationsWidget() {
    if (denominations.isNotEmpty) {
      return listWidget();
    }
    return FutureBuilder(
        future: viewModel.getDenominations(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Denominations>> snapshot) {
          if (snapshot.hasError) {
            return Text(
              "Failed to load denominations.Please try again later!",
              style: Theme.of(context).textTheme.bodyLarge,
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              denominations = snapshot.data!;
              return listWidget();
            }
            return Text(
              "Failed to load denominations.Please try again later!",
              style: Theme.of(context).textTheme.bodyLarge,
            );
          }
          return const Text("Loading ...");
        });
  }

  Widget listWidget() {
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(
              color: Theme.of(context).dividerColor,
            ),
        shrinkWrap: true,
        itemCount: denominations.length,
        itemBuilder: (context, index) {
          return DenominationRowWidget(
            denomination: denominations[index],
            pos: index,
            hintText: 'Price',
            removeOnPosition: removeDenominationAt,
            addNewItem: addNewDenomination,
            refresh: () {
              setState(() {
                widget.updateEnteredCash(
                    denominations, viewModel.getEnteredCash(denominations));
              });
            },
          );
        });
  }

  void removeDenominationAt(int pos) {
    setState(() {
      denominations.removeAt(pos);
    });
  }

  void addNewDenomination() {
    setState(() {
      Denominations overridePrice = Denominations();
      denominations.add(overridePrice);
    });
  }

  Widget checkAndGoToOpenCounterScreen() {
    return FutureBuilder(
        future: viewModel.checkCounterDataIsNotSynced(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasError) {
            return Text(
              "Failed to load denominations.Please try again later!",
              style: Theme.of(context).textTheme.bodyLarge,
            );
          }
          if (snapshot.hasData) {
            MyLogUtils.logDebug(
                "checkAndGoToOpenCounterScreen snapshot.data : ${snapshot.data}");

            if (snapshot.data == true) {
              goToOfflineCounterData();
            } else {
              goToOpenCounterScreen();
            }
            showToast("Counter closed SuccessFully!", context);

            return Text(
              "Counter Closed",
              style: Theme.of(context).textTheme.bodyLarge,
            );
          }
          return const Text("Loading ...");
        });
  }

  Future<void> goToOpenCounterScreen() async {
    MyLogUtils.logDebug("Close Counter goToOpenCounterScreen ");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.popUntil(context, ModalRoute.withName(OpenCounterRoute));
      Navigator.pushNamed(
        context,
        OpenCounterRoute,
      );
      viewModel.closeObservable();
    });
  }

  Future<void> goToOfflineCounterData() async {
    MyLogUtils.logDebug("goToOfflineCounterData");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.popUntil(context, ModalRoute.withName(SplashRoute));
      Navigator.pushNamed(context, LocalCountersInfoRoute, arguments: true);
      viewModel.closeObservable();
    });
  }
}
