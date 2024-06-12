import 'package:flutter/material.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';

import '../../utils/MyLogUtils.dart';

class IncDecWidget extends StatefulWidget {
  final double count;
  final Function onCountUpdated;
  final bool showOnlyQty;
  final bool allowDecimal;

  const IncDecWidget(
      {Key? key,
      required this.count,
      required this.onCountUpdated,
      required this.showOnlyQty,
      required this.allowDecimal})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _IncDecWidgetState();
  }
}

class _IncDecWidgetState extends State<IncDecWidget> {
  final qtyController = TextEditingController();
  final qtyNode = FocusNode();
  bool isFirstTime = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MyLogUtils.logDebug(
        " count value from widget: ${widget.count} && isFirstTime :$isFirstTime");

    if (isFirstTime) {
      isFirstTime = false;
      if (widget.allowDecimal) {
        qtyController.text = '${widget.count}';
      } else {
        qtyController.text = getStringWithNoDecimal(widget.count);
      }
    }

    // In case of bundle buy, when qty is increased, the item is split
    // it single items but somehow the inc item is retained in this widget. Only UI issue
    // To fx this, check the count in controller & the incoming.If its different, use incoming
    if (qtyController.text.isNotEmpty &&
        double.parse(qtyController.text) != widget.count) {
      if (widget.allowDecimal) {
        qtyController.text = '${widget.count}';
      } else {
        qtyController.text = getStringWithNoDecimal(widget.count);
      }
    }

    MyLogUtils.logDebug(
        " count value from qtyController: ${qtyController.text}");
    //Place the cursor after actual text.
    qtyController.selection = TextSelection.fromPosition(
        TextPosition(offset: qtyController.text.length));

    return IntrinsicWidth(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.showOnlyQty
              ? const SizedBox(
                  width: 25,
                )
              : MyInkWellWidget(
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                      ),
                      child: const Icon(
                        Icons.remove,
                        size: 25,
                      )),
                  onTap: () {
                    if (widget.count > 0) {
                      setState(() {
                        double newCount = widget.count - 1;
                        widget.onCountUpdated(newCount);
                        if (widget.allowDecimal) {
                          qtyController.text = '$newCount';
                        } else {
                          qtyController.text = getStringWithNoDecimal(newCount);
                        }
                      });
                    }
                  },
                ),
          const SizedBox(
            width: 10,
          ),
          widget.showOnlyQty
              ? Container(
                  width: 50,
                  height: 30,
                  padding: const EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border:
                          Border.all(color: Theme.of(context).dividerColor)),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      qtyController.text,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                )
              : SizedBox(
                  width: 50,
                  height: 30,
                  child: MyTextFieldWidget(
                    controller: qtyController,
                    node: qtyNode,
                    textAlign: TextAlign.center,
                    enabled: !widget.showOnlyQty,
                    hint: 'Qty',
                    onChanged: (value) {
                      if (value.isEmpty) {
                        return;
                      }
                      if (isNumeric(value) && double.parse(value) > 0) {
                        if (widget.allowDecimal) {
                          qtyController.text = value;
                        } else {
                          qtyController.text = getStringWithNoDecimal(value);
                        }

                        widget.onCountUpdated(getDoubleValue(value));
                      } else {
                        if (widget.allowDecimal) {
                          //
                        } else {
                          showToast("Only numeric is allowed", context);
                          qtyController.text = "";
                        }
                      }
                    },
                  ),
                ),
          const SizedBox(
            width: 10,
          ),
          widget.showOnlyQty
              ? const SizedBox(
                  width: 25,
                )
              : MyInkWellWidget(
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 25,
                      )),
                  onTap: () {
                    setState(() {
                      double newCount = widget.count + 1;
                      widget.onCountUpdated(newCount);

                      if (widget.allowDecimal) {
                        qtyController.text = '$newCount';
                      } else {
                        qtyController.text = getStringWithNoDecimal(newCount);
                      }
                    });
                  },
                ),
        ],
      ),
    );
  }
}
