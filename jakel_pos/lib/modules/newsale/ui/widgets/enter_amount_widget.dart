import 'package:flutter/material.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/database/sale/model/PaymentTypeData.dart';
import 'package:jakel_base/serialportdevices/model/MayBankPaymentDetails.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';
import 'package:jakel_base/widgets/custom/MyLeftRightWidget.dart';
import 'package:jakel_base/widgets/custom/MyNumbersWidget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_base/widgets/keyboard/KeyboardWidget.dart';
import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';
import 'package:jakel_pos/modules/newsale/CartViewModel.dart';
import 'package:jakel_pos/modules/newsale/MbbViewModel.dart';

class EnterAmountWidget extends StatefulWidget {
  final Function onPaymentSelected;
  final PaymentTypeData paymentTypeData;
  final CartSummary cartSummary;

  const EnterAmountWidget({
    Key? key,
    required this.onPaymentSelected,
    required this.paymentTypeData,
    required this.cartSummary,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EnterAmountWidgetState();
  }
}

class _EnterAmountWidgetState extends State<EnterAmountWidget> {
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
  bool focusScope = true;
  bool isTriggerMayBankCard = false;
  bool isTriggerMayBankCardQrCode = false;

  KeyboardFocusController keyboardFocusController = KeyboardFocusController();

  @override
  void initState() {
    super.initState();

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
            ? 740.00
            : 640.00)
        : ((isTriggerMayBankCard || isTriggerMayBankCardQrCode)
            ? 640.00
            : 550.00);
  }

  @override
  Widget build(BuildContext context) {
    if (isCardPayment && focusScope) {
      focusScope = false;
      FocusScope.of(context).requestFocus(cardOrChequeNumberNode);
    }
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
          width: 600,
          height: getViewHeight(),
          child: MyDataContainerWidget(
              child: Column(children: [
            getHeader(),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            isCardPayment ? isCash() : paymentTerminalWidget(),
            Expanded(
                child: KeyboardWidget(
                    requestFocus: false,
                    keyboardFocusController: keyboardFocusController,
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
                    })),
          ])),
        ));
  }

  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.paymentTypeData.paymentType!.name!,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        MyInkWellWidget(
            child: const Icon(Icons.close),
            onTap: () {
              _closeTheScreen();
            })
      ],
    );
  }

  Widget getNumbersWidget() {
    return Column(
      children: [
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
                      //First clear the payment & then mark it exact
                      addAmountFromAmountCalc("EXACT", null);
                    },
                    text: "EXACT")),
            const SizedBox(
              width: 15,
            ),
            // Giving some ui & logic issues in keyboard.
            // Expanded(
            //     child: MyNumbersWidget(
            //         onCLick: () {
            //           appendAmountFromCalc("DELETE");
            //         },
            //         text: "DELETE")),
            // const SizedBox(
            //   width: 15,
            // ),

            Expanded(
                child: MyNumbersWidget(
                    onCLick: () {
                      appendAmountFromCalc("CLEAR");
                    },
                    text: "CLEAR"))
          ],
        )),
        const SizedBox(
          height: 20,
        ),
        Expanded(child: doneButtonWidget()),
        const SizedBox(
          height: 20,
        ),
        const Divider(
          height: 10,
          thickness: 2,
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
          thickness: 2,
          height: 10,
        ),
        balanceChangeDue > 0
            ? MyLeftRightWidget(
                lText: "Change Due",
                lStyle: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold),
                rStyle: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold),
                rText: getReadableAmount("RM", balanceChangeDue))
            : Container(),
        balanceChangeDue > 0
            ? const Divider(
                thickness: 2,
                height: 10,
              )
            : Container(),
        MyLeftRightWidget(
            lText: "Total",
            lStyle: const TextStyle(
              fontSize: 20,
            ),
            rStyle: const TextStyle(
              fontSize: 20,
            ),
            rText:
                getReadableAmount("RM", widget.cartSummary.cartPrice?.total)),
        const Divider(
          height: 10,
        ),
        MyLeftRightWidget(
            lText: "Paid",
            lStyle: const TextStyle(
              fontSize: 20,
            ),
            rStyle: const TextStyle(
              fontSize: 20,
            ),
            rText: getReadableAmount("RM", widget.cartSummary.getPaidAmount())),
        const Divider(
          height: 10,
        ),
        MyLeftRightWidget(
            lText: "Due",
            lStyle: const TextStyle(
              fontSize: 20,
            ),
            rStyle: const TextStyle(
              fontSize: 20,
            ),
            rText: getReadableAmount("RM", widget.cartSummary.getDueAmount()))
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
    if (isExactAmountMatching()) {
      return MyNumbersWidget(
          text: "COMPLETE SALE",
          onCLick: () {
            addAmountFromAmountCalc("DONE", null);
          });
    }
    return MyNumbersWidget(
        onCLick: () {
          addAmountFromAmountCalc("DONE", null);
        },
        text: "DONE");
  }

  bool isExactAmountMatching() {
    MyLogUtils.logDebug(
        "isExactAmountMatching due amount ${widget.cartSummary.getDueAmount()} & enteredAmount : $enteredAmount");
    double total = enteredAmount + widget.cartSummary.getDueAmount();
    return widget.cartSummary.getDueAmount() == enteredAmount;
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

      if (amount == "DELETE" &&
          (enteredAmountAsString.isEmpty ||
              enteredAmountAsString == "0.0" ||
              enteredAmountAsString == "0")) {
        enteredAmountAsString = "";
        enteredAmount = 0.0;
        return;
      }

      if (amount == "DELETE") {
        MyLogUtils.logDebug(
            "DELETE enteredAmountAsString b4 : $enteredAmountAsString");

        // Removes trailing 0 in decimal places.
        /// 12.50 -> 12.5, 12.0 -> 12
        RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
        enteredAmountAsString = enteredAmountAsString.replaceAll(regex, '');

        enteredAmountAsString = enteredAmountAsString.substring(
            0, enteredAmountAsString.length - 1);

        MyLogUtils.logDebug(
            "DELETE enteredAmountAsString After : $enteredAmountAsString");

        if (enteredAmountAsString.isEmpty) {
          enteredAmountAsString = "";
          enteredAmount = 0;
        } else {
          enteredAmount = getDoubleValue(enteredAmountAsString);
        }

        MyLogUtils.logDebug("DELETE enteredAmount $enteredAmount");

        double alreadyPaidAmount =
            widget.cartSummary.getPaidAmount() - widget.paymentTypeData.amount;

        MyLogUtils.logDebug("DELETE alreadyPaidAmount $alreadyPaidAmount");

        balanceChangeDue = (enteredAmount + alreadyPaidAmount) -
            (widget.cartSummary.cartPrice?.total ?? 0);

        MyLogUtils.logDebug("DELETE balanceChangeDue $balanceChangeDue");

        return;
      }

      if (!widget.cartSummary.isBookingSale &&
          widget.cartSummary.getDueAmount() <= 0) {
        showToast("Amount cannot exceed total amount.", context);
        return;
      }

      double alreadyPaidAmount =
          widget.cartSummary.getPaidAmount() - widget.paymentTypeData.amount;
      double totalPaidWillBe = alreadyPaidAmount + enteredAmount;

      if (!widget.cartSummary.isBookingSale &&
          totalPaidWillBe >= (widget.cartSummary.cartPrice?.total ?? 0)) {
        // Commented this as of now, to fix a bug.
        // For ex, if total is 190.50, Customer will give 200.50 and so balance can be 10 RM.

        // showToast("Amount cannot exceed total amount.", context);
        // return;
      }

      if (enteredAmountAsString.contains(".") && amount == ".") {
        return;
      }

      enteredAmountAsString = enteredAmountAsString + amount;
      enteredAmount = getDoubleValue(enteredAmountAsString);

      if (widget.cartSummary.isBookingSale) {
        balanceChangeDue = 0;
      } else {
        balanceChangeDue = (enteredAmount + alreadyPaidAmount) -
            (widget.cartSummary.cartPrice?.total ?? 0);
      }
    });
  }

  void onClear() {
    if (isCardPayment) {
      if (cardOrChequeNumberController.text.isNotEmpty) {
        if (cardOrChequeNumberController.text.length > 3) {
          cardOrChequeNumberController.text = "";
          enteredAmountAsString = "";
          enteredAmount = 0.0;
          widget.paymentTypeData.cardNo = "";
          var paymentTypeData = widget.paymentTypeData;
          paymentTypeData.amount = enteredAmount;
          balanceChangeDue = 0.0;
          widget.onPaymentSelected(
              paymentTypeData, balanceChangeDue, null, false);
          focusScope = true;
        } else {
          showToast('Please Enter At Least 4 Digits', context);
        }
      } else {
        showToast('Please Entry The Card Number Entry.', context);
      }
    } else {
      cardOrChequeNumberController.text = "";
      enteredAmountAsString = "";
      enteredAmount = 0.0;
      widget.paymentTypeData.cardNo = "";
      var paymentTypeData = widget.paymentTypeData;
      paymentTypeData.amount = enteredAmount;
      balanceChangeDue = 0.0;
      widget.onPaymentSelected(paymentTypeData, balanceChangeDue, null, false);
    }
  }

  void addAmountFromAmountCalc(String amount, MayBankPaymentDetails? details) {
    if (amount == "DONE") {
      onDoneClicked(details);
    } else if (isCardPayment) {
      if (cardOrChequeNumberController.text.isNotEmpty) {
        if (cardOrChequeNumberController.text.length > 3) {
          if (amount == "EXACT") {
            MyLogUtils.logDebug("on Exact enteredAmount : $enteredAmount");
            MyLogUtils.logDebug(
                "on Exact getDueAmount : ${widget.cartSummary.getDueAmount()}");
            enteredAmount = 0.0;
            balanceChangeDue = 0.0;
            if (isExactAmountMatching()) {
              return;
            }
            setState(() {
              enteredAmount = enteredAmount + widget.cartSummary.getDueAmount();
              enteredAmountAsString = '$enteredAmount';

              MyLogUtils.logDebug("on Exact enteredAmount : $enteredAmount");

              MyLogUtils.logDebug(
                  "on Exact getPaidAmount : ${widget.cartSummary.getPaidAmount()}");

              double alreadyPaidAmount = widget.cartSummary.getPaidAmount() -
                  widget.paymentTypeData.amount;
              MyLogUtils.logDebug(
                  "on Exact alreadyPaidAmount : $alreadyPaidAmount");

              double totalPaidWillBe = alreadyPaidAmount + enteredAmount;
              MyLogUtils.logDebug(
                  "oon Exact totalPaidWillBe : $totalPaidWillBe");
              balanceChangeDue =
                  totalPaidWillBe - (widget.cartSummary.cartPrice?.total ?? 0);
            });
          }
        } else {
          showToast('Please Enter At Least 4 Digits', context);
        }
      } else {
        showToast('Please Entry The Card Number Entry.', context);
      }
    } else {
      if (amount == "EXACT") {
        MyLogUtils.logDebug("on Exact enteredAmount : $enteredAmount");
        MyLogUtils.logDebug(
            "on Exact getDueAmount : ${widget.cartSummary.getDueAmount()}");
        onClear();
        if (isExactAmountMatching()) {
          return;
        }

        setState(() {
          enteredAmount = enteredAmount + widget.cartSummary.getDueAmount();
          enteredAmountAsString = '$enteredAmount';

          MyLogUtils.logDebug("on Exact enteredAmount : $enteredAmount");

          MyLogUtils.logDebug(
              "on Exact getPaidAmount : ${widget.cartSummary.getPaidAmount()}");

          double alreadyPaidAmount = widget.cartSummary.getPaidAmount() -
              widget.paymentTypeData.amount;
          MyLogUtils.logDebug(
              "on Exact alreadyPaidAmount : $alreadyPaidAmount");

          double totalPaidWillBe = alreadyPaidAmount + enteredAmount;
          MyLogUtils.logDebug("oon Exact totalPaidWillBe : $totalPaidWillBe");
          balanceChangeDue =
              totalPaidWillBe - (widget.cartSummary.cartPrice?.total ?? 0);
        });
      }
    }
  }

  void onDoneClicked(MayBankPaymentDetails? details) {
    //This should be checked first, else it wont work.
    bool shouldCompleteSale = isExactAmountMatching();
    MyLogUtils.logDebug("on DONE enteredAmount : $enteredAmount");
    MyLogUtils.logDebug(
        "on DONE getDueAmount : ${widget.cartSummary.getDueAmount()}");
    // Check if existing amount is greater than 0, it means its update of amount.
    //Check if the paid amount will be more than entered amount.
    double alreadyPaidAmount =
        widget.cartSummary.getPaidAmount() - widget.paymentTypeData.amount;
    MyLogUtils.logDebug("on DONE alreadyPaidAmount : $alreadyPaidAmount");
    double totalPaidWillBe = alreadyPaidAmount + enteredAmount;
    MyLogUtils.logDebug("on DONE totalPaidWillBe : $totalPaidWillBe");

    var paymentTypeData = widget.paymentTypeData;

    if (totalPaidWillBe > (widget.cartSummary.cartPrice?.total ?? 0)) {
      paymentTypeData.amount = widget.cartSummary.isBookingSale
          ? totalPaidWillBe
          : widget.cartSummary.getDueAmount();
    } else {
      paymentTypeData.amount = enteredAmount;
    }

    MyLogUtils.logDebug(
        "paymentTypeData : ${paymentTypeData.toJson()} && balanceChangeDue : $balanceChangeDue");

    _closeTheScreen();
    widget.onPaymentSelected(
        paymentTypeData, balanceChangeDue, details, shouldCompleteSale);
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
            setState(() {
              widget.paymentTypeData.cardNo = value;
              if (cardOrChequeNumberController.text.length < 4) {
                enteredAmountAsString = "";
                enteredAmount = 0.0;
                balanceChangeDue = 0.0;
              }
            });
          },
          onSubmitted: (value) {
            setState(() {
              keyboardFocusController.requestFocus.call();
            });
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
                  onChanged: (value) {
                    // if (value != null && isCardPayment) {
                    //   setState(() {
                    //     allowKeyBoardEntryForCardNumber = value;
                    //   });
                    // }
                  }),
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
