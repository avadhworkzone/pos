import 'package:flutter/material.dart';
import 'package:jakel_base/database/sale/model/ProductsData.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_pos/modules/products/ProductsViewModel.dart';
import 'package:intl/intl.dart';

class ShowProductBatchDialog extends StatefulWidget {
  final ProductsData productsData;
  final Function onBatchSelected;

  const ShowProductBatchDialog(
      {Key? key, required this.productsData, required this.onBatchSelected})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ShowProductState();
  }
}

class _ShowProductState extends State<ShowProductBatchDialog>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  final storeManagerViewModel = ProductsViewModel();
  final bachNumberController = TextEditingController();
  final bachExpiryDateController = TextEditingController();

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
          width: 600,
          height: 600,
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

    widget.productsData.product?.batchNumbers?.forEach((element) {
      widgets.add(InkWell(
        onTap: () {
          widget.onBatchSelected(element.batchNumber ?? "", "");
          Navigator.pop(context);
        },
        child: Text(
          element.batchNumber ?? "",
          style: Theme.of(context).textTheme.caption,
        ),
      ));
      widgets.add(const Divider());
    });

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(getManualBatchHeader());

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(const Divider());

    widgets.add(Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 5,
              child: TextField(
                key: widget.key,
                controller: bachNumberController,
                onSubmitted: (value) {},
                onChanged: (value) {},
                style: Theme.of(context).textTheme.bodySmall,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                  filled: true,
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 0.0, color: Colors.transparent),
                  ),
                  fillColor: getWhiteColor(context),
                  hintText: 'Please enter the batch number',
                  hintStyle: Theme.of(context).textTheme.caption,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
                flex: 4,
                child: TextField(
                  onTap: () {
                    getDatePicker();
                  },
                  readOnly: true,
                  key: widget.key,
                  controller: bachExpiryDateController,
                  style: Theme.of(context).textTheme.bodySmall,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                    filled: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    fillColor: getWhiteColor(context),
                    hintText: 'Please select the expiry date',
                    hintStyle: Theme.of(context).textTheme.caption,
                    // suffixIcon: Icon(Icons.calendar_month),
                  ),
                )),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          width: 150,
          height: 40,
          child: MyOutlineButton(
              text: "Proceed",
              onClick: () {
                if (bachNumberController.text.isEmpty) {
                  showToast("Please enter the batch number", context);
                } else if (bachExpiryDateController.text.isEmpty) {
                  showToast("Please select the expiry date", context);
                } else if (bachNumberController.text.isNotEmpty &&
                    bachExpiryDateController.text.isNotEmpty) {
                  widget.onBatchSelected(
                      bachNumberController.text, bachExpiryDateController.text);
                  Navigator.pop(context);
                }
              }),
        )
      ],
    ));

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Select Batch Number",
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

  Widget getManualBatchHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          "Manual Batch Number",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  getDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      //get today's date
      firstDate: DateTime.now(),
      //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(DateTime.now().year + 1, DateTime.now().month + 1,
          DateTime.now().day),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(
          pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
      setState(() {
        bachExpiryDateController.text =
            formattedDate; //set foratted date to TextField value.
      });
    } else {
      showToast("Date is not selected", context);
    }
  }
}
