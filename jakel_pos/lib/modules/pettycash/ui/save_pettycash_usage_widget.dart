import 'package:flutter/material.dart';
import 'package:jakel_base/constants.dart';
import 'package:jakel_base/restapi/pettycash/model/PettyCashUsageResponse.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';
import 'package:jakel_pos/modules/pettycash/ui/petty_cash_report_dialog.dart';

import '../PettyCashViewModel.dart';

class SavePettyCashUsageWidget extends StatefulWidget {
  const SavePettyCashUsageWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SavePettyCashUsageWidgetState();
  }
}

class _SavePettyCashUsageWidgetState extends State<SavePettyCashUsageWidget> {
  bool callApi = false;
  final amountController = TextEditingController();
  final amountNode = FocusNode();
  final viewModel = PettyCashViewModel();
  PettyCashUsageReasons? selected;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        width: 600,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(10.0),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getHeader(),
              const SizedBox(
                height: 20,
              ),
              reasonSelection(),
              const SizedBox(
                height: 20,
              ),
              MyTextFieldWidget(
                controller: amountController,
                node: amountNode,
                hint: "Enter amount",
              ),
              const SizedBox(
                height: 20,
              ),
              buttonWidget(),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              const Expanded(
                  child: PettyCashReportDialog(
                showAsDialog: false,
              )),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget reasonSelection() {
    return SizedBox(
      height: 50,
      child: DropdownSearch<PettyCashUsageReasons>(
        compareFn: (item1, item2) {
          return false;
        },
        popupProps: const PopupProps.menu(
          showSelectedItems: true,
        ),
        asyncItems: (String filter) => viewModel.getPettyCashReasons(),
        onChanged: (value) {
          setState(() {
            selected = value;
          });
        },
        itemAsString: (item) {
          return item.reason ?? noData;
        },
        selectedItem: selected,
      ),
    );
  }

  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Add New Petty Cash Usage',
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
    if (callApi) {
      return apiWidget();
    }
    return MyOutlineButton(text: 'save', onClick: () => {_save()});
  }

  void _save() {
    if (selected == null) {
      showToast('Please select reason', context);
      return;
    }
    if (amountController.text.isEmpty) {
      showToast('Please enter amount', context);
      return;
    }

    setState(() {
      callApi = true;
      viewModel.savePettyCashUsage(
          selected!.id!, getDoubleValue(amountController.text));
    });
  }

  Widget apiWidget() {
    return StreamBuilder<bool>(
      stream: viewModel.responseSubject,
      // ignore: missing_return, missing_return
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyLoadingWidget();
        }
        if (snapshot.hasError) {
          callApi = false;
          return buttonWidget();
        }
        if (snapshot.connectionState == ConnectionState.active) {
          var response = snapshot.data;
          if (response != null && response == true) {
            showToast("Successfully added!", context);
            goBack();
            return const SizedBox();
          } else {
            showToast('failed_to_save_customer', context);
            callApi = false;
            return buttonWidget();
          }
        }
        return Container();
      },
    );
  }

  Future<void> goBack() async {
    viewModel.closeObservable();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
    });
  }
}
