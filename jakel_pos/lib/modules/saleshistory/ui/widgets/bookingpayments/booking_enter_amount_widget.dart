import 'package:flutter/material.dart';
import 'package:jakel_base/database/sale/model/PaymentTypeData.dart';
import 'package:jakel_base/serialportdevices/model/MayBankPaymentDetails.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/custom/MyLeftRightWidget.dart';
import 'package:jakel_base/widgets/custom/MyNumbersWidget.dart';
import 'package:jakel_base/widgets/keyboard/KeyboardWidget.dart';
import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';
import 'package:jakel_pos/modules/newsale/CartViewModel.dart';
import 'package:jakel_pos/modules/newsale/MbbViewModel.dart';

class BookingEnterAmountWidget extends StatefulWidget {
  final Function onPaymentSelected;
  final PaymentTypeData paymentTypeData;

  const BookingEnterAmountWidget({
    Key? key,
    required this.onPaymentSelected,
    required this.paymentTypeData,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BookingEnterAmountWidgetState();
  }
}

class _BookingEnterAmountWidgetState extends State<BookingEnterAmountWidget> {
  final double numbersPadding = 20.0;
  final viewModel = CartViewModel();
  final mbbViewModel = MbbViewModel();
  double paidAmount = 0.0;
  double totalAmount = 0.0;
  String enteredAmountAsString = "";
  double enteredAmount = 0.0;
  double balanceChangeDue = 0.0;

  final cardOrChequeNumberController = TextEditingController();
  final cardOrChequeNumberNode = FocusNode();

  bool isCardPayment = false;
  bool isTriggerMayBankCard = false;
  bool isTriggerMayBankCardQrCode = false;

  @override
  void initState() {
    super.initState();
  }

  setValue() {
    isCardPayment = widget.paymentTypeData.paymentType?.isCardPayment ?? false;
    isTriggerMayBankCard =
        widget.paymentTypeData.paymentType?.triggerMayBankCard ?? false;
    isTriggerMayBankCardQrCode =
        widget.paymentTypeData.paymentType?.triggerMayBankQrCode ?? false;

    if (widget.paymentTypeData.amount > 0) {
      enteredAmount = widget.paymentTypeData.amount;
      enteredAmountAsString = '$enteredAmount';
    }

    if (widget.paymentTypeData.cardNo!.isNotEmpty && isCardPayment) {
      cardOrChequeNumberController.text = widget.paymentTypeData.cardNo ?? "";
    }
  }

  getViewHeight() {
    return isCardPayment
        ? ((isTriggerMayBankCard || isTriggerMayBankCardQrCode)
            ? 530.00
            : 450.00)
        : ((isTriggerMayBankCard || isTriggerMayBankCardQrCode)
            ? 430.00
            : 370.00);
  }

  @override
  Widget build(BuildContext context) {
    setValue();
    double getHeight = getViewHeight();
    return Container(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      width: 600,
      height: getHeight,
      child: isCardPayment
          ? IntrinsicHeight(
              child: getNumbersWidget(),
            )
          : KeyboardWidget(
              requestFocus: false,
              onEsc: () {
                _closeTheScreen();
              },
              child: IntrinsicHeight(
                child: getNumbersWidget(),
              ),
              onNumber: (value) {
                appendAmountFromCalc("$value");
              },
              onDecimal: () {
                appendAmountFromCalc(".");
              },
              onPeriod: () {
                appendAmountFromCalc(".");
              },
              onDelete: () {
                MyLogUtils.logDebug("On Delete Selected");
                appendAmountFromCalc("CLEAR");
              },
              onEnter: () {
                addAmountFromAmountCalc("DONE", null);
              }),
    );
  }

  Widget getNumbersWidget() {
    return Column(
      children: [
        isCardPayment ? isCash() : paymentTerminalWidget(),
        Expanded(
            child: Row(
          children: [
            Expanded(
                child: MyNumbersWidget(
                    onCLick: () {
                      appendAmountFromCalc("1");
                    },
                    text: "1")),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: MyNumbersWidget(
                  onCLick: () {
                    appendAmountFromCalc("2");
                  },
                  text: "2"),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: MyNumbersWidget(
                  onCLick: () {
                    appendAmountFromCalc("3");
                  },
                  text: "3"),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: MyNumbersWidget(
                  onCLick: () {
                    appendAmountFromCalc("4");
                  },
                  text: "4"),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: MyNumbersWidget(
                  onCLick: () {
                    appendAmountFromCalc("5");
                  },
                  text: "5"),
            ),
          ],
        )),
        Expanded(
            child: Row(
          children: [
            Expanded(
              child: MyNumbersWidget(
                  onCLick: () {
                    appendAmountFromCalc("6");
                  },
                  text: "6"),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: MyNumbersWidget(
                  onCLick: () {
                    appendAmountFromCalc("7");
                  },
                  text: "7"),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: MyNumbersWidget(
                  onCLick: () {
                    appendAmountFromCalc("8");
                  },
                  text: "8"),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: MyNumbersWidget(
                  onCLick: () {
                    appendAmountFromCalc("9");
                  },
                  text: "9"),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: MyNumbersWidget(
                  onCLick: () {
                    appendAmountFromCalc("0");
                  },
                  text: "0"),
            ),
          ],
        )),
        Expanded(
            child: Row(
          children: [
            Expanded(
                child: MyNumbersWidget(
                    onCLick: () {
                      appendAmountFromCalc(".");
                    },
                    text: ".")),
            const SizedBox(
              width: 15,
            ),
            Expanded(
                child: MyNumbersWidget(
                    onCLick: () {
                      appendAmountFromCalc("CLEAR");
                    },
                    text: "CLEAR")),
            const SizedBox(
              width: 15,
            ),
            Expanded(child: doneButtonWidget()),
          ],
        )),
        const SizedBox(
          height: 100,
        ),
        const Divider(
          height: 10,
          thickness: 1,
        ),
        MyLeftRightWidget(
            lText: "Entered Amount",
            lStyle: TextStyle(
                fontSize: 20,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
            rStyle: TextStyle(
                fontSize: 20,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
            rText: getReadableAmount("RM", enteredAmount)),
        const Divider(
          thickness: 1,
          height: 10,
        ),
      ],
    );
  }

  Widget isCash() {
    return Column(
      children: [
        getCardNumberWidget(),
        const SizedBox(
          height: 10,
        ),
        isCardPayment ? const Divider() : const SizedBox(),
        isCardPayment
            ? Text(
                "Allowing Card Number Entry will prevent hard keyboard entry for amount.",
                style: Theme.of(context).textTheme.caption,
              )
            : const SizedBox(),
        const Divider(),
        const SizedBox(
          height: 10,
        ),
        paymentTerminalWidget(),
      ],
    );
  }

  Widget doneButtonWidget() {
    return MyNumbersWidget(
        onCLick: () {
          addAmountFromAmountCalc("DONE", null);
        },
        text: "DONE");
  }

  void appendAmountFromCalc(String amount) {
    if (isCardPayment) {
      if (cardOrChequeNumberController.text.isNotEmpty) {
        if (cardOrChequeNumberController.text.length > 3) {
          getAmountFromCalculator(amount);
        } else {
          showToast('Please Enter At Least 4 Digits', context);
        }
      } else {
        showToast('Please Entry The Card Number Entry.', context);
      }
    } else {
      getAmountFromCalculator(amount);
    }
  }

  getAmountFromCalculator(String amount) {
    MyLogUtils.logDebug(
        "Before appendAmountFromCalc : $amount & enteredAmountAsString"
        " : $enteredAmountAsString & enteredAmount : $enteredAmount");

    setState(() {
      if (amount == "CLEAR") {
        onClear();
        return;
      }

      if (enteredAmountAsString.contains(".") && amount == ".") {
        return;
      }

      enteredAmountAsString = enteredAmountAsString + amount;
      enteredAmount = getDoubleValue(enteredAmountAsString);
    });
  }

  void onClear() {
    cardOrChequeNumberController.text = "";
    enteredAmountAsString = "";
    enteredAmount = 0.0;
    widget.paymentTypeData.cardNo = "";
    var paymentTypeData = widget.paymentTypeData;
    paymentTypeData.amount = enteredAmount;
    balanceChangeDue = 0.0;
  }

  void addAmountFromAmountCalc(String amount, MayBankPaymentDetails? details) {

    if (isCardPayment && cardOrChequeNumberController.text.isEmpty) {
      showToast('Please Entry The Card Number Entry.', context);
      return;
    }
    if (isCardPayment && cardOrChequeNumberController.text.length < 4) {
      showToast('Please Enter At Least 4 Digits', context);
      return;
    }
    if (amount == "DONE") {
      onDoneClicked(details);
    }
  }

  void onDoneClicked(MayBankPaymentDetails? details) {
    if(enteredAmount>0) {
      widget.onPaymentSelected(enteredAmount);
    }else {
      showToast('Please Entry Amount.', context);
    }
  }

  // Since keyboard widget is used for keyboard shortcut, need have a flag to handle this.
  Widget getCardNumberWidget() {
    if (!isCardPayment) {
      return Container();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            child: MyTextFieldWidget(
          controller: cardOrChequeNumberController,
          node: cardOrChequeNumberNode,
          onChanged: (value) {
            // setState(() {
            //   widget.paymentTypeData.cardNo = value;
            // });
          },
          hint: "Enter No",
        )),
        const SizedBox(
          width: 10,
        ),
        SizedBox(
          width: 200,
          child: Column(
            children: [
              Text(
                "Allow Card Number Entry.",
                style: Theme.of(context).textTheme.caption,
              ),
              Checkbox(
                  value: isCardPayment,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (value) {}),
            ],
          ),
        )
      ],
    );
  }

  Widget paymentTerminalWidget() {
    if (isTriggerMayBankCard || isTriggerMayBankCardQrCode) {
      return Column(
        children: [
          SizedBox(
            // height: 80,
            width: double.infinity,
            child: triggerMayBankButton(
                isTriggerMayBankCard, isTriggerMayBankCardQrCode),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
        ],
      );
    }
    return Container();
  }

  bool callMbbApi = false;
  bool triggerBothQrAndCard = false;

  Widget triggerMayBankButton(
      bool triggerMayBankCard, bool triggerMayBankQrCode) {
    if (callMbbApi) {
      if (triggerBothQrAndCard) {
        return triggerPaymentTerminalWidget(true, true);
      }
      return triggerPaymentTerminalWidget(
          triggerMayBankCard, triggerMayBankQrCode);
    }

    double amount = enteredAmount;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        isTriggerMayBankCard
            ? MyOutlineButton(
                text: "Trigger MBB for RM $amount",
                onClick: () {
                  setState(() {
                    callMbbApi = true;
                    // FOr Mocking and testing
                    // var details = MayBankPaymentDetails(
                    //     cardType: "98",
                    //     cardNumber: "676776****",
                    //     cardNumberName: "Test",
                    //     referenceNumber: "INV....");
                    // onMayBankPaymentSuccess(details);
                  });
                })
            : const SizedBox(),
        isTriggerMayBankCardQrCode
            ? MyOutlineButton(
                text: "Trigger QR & Card for RM $amount",
                onClick: () {
                  setState(() {
                    callMbbApi = true;
                    triggerBothQrAndCard = true;
                  });
                })
            : const SizedBox(),
      ],
    );
  }

  Widget triggerPaymentTerminalWidget(
      bool triggerMayBankCard, bool triggerMayBankQrCode) {
    double amount = enteredAmount;

    MyLogUtils.logDebug("triggerPaymentTerminalWidget amount : $amount");

    mbbViewModel.triggerPaymentTerminalAsync(
        amount, triggerMayBankCard, triggerMayBankQrCode);

    return StreamBuilder<MayBankPaymentDetails?>(
      stream: mbbViewModel.mbbResponseSubject,
      // ignore: missing_return, missing_return
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: [
              Text("Please check your payment terminal to complete payment.",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w800)),
              CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              )
            ],
          );
        }
        if (snapshot.hasError) {
          return const Text("Payment failed.");
        }
        if (snapshot.connectionState == ConnectionState.active) {
          callMbbApi = false;
          var empResponse = snapshot.data;
          MyLogUtils.logDebug("api snapshot.data : ${snapshot.data}");

          if (empResponse == null) {
            return const Text("Payment failed.");
          }

          if (empResponse.errorMessage != null) {
            callMbbApi = false;
            return Row(
              children: [
                Expanded(
                    child: Text(
                  empResponse.errorMessage!,
                  style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 9,
                      fontWeight: FontWeight.w800),
                )),
                Expanded(
                    child: triggerMayBankButton(
                        triggerMayBankCard, triggerMayBankQrCode))
              ],
            );
          } else {
            onMayBankPaymentSuccess(empResponse);
            return const Text("Payment successful.");
          }
        }
        return Container();
      },
    );
  }

  Future<void> onMayBankPaymentSuccess(MayBankPaymentDetails details) async {
    await mbbViewModel.closeThePort();
    //enteredAmount = widget.cartSummary.getDueAmount();
    enteredAmountAsString = '$enteredAmount';
    addAmountFromAmountCalc("DONE", details);
  }

  @override
  void dispose() {
    super.dispose();
    mbbViewModel.closeThePort();
  }

  void _closeTheScreen() {
    mbbViewModel.closeThePort();
    Navigator.pop(context);
  }
}
