import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/customers/model/CreateCustomerRequest.dart';
import 'package:jakel_base/restapi/customers/model/CustomerTypesResponse.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/my_mobile_number_validation.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_base/widgets/text/HeaderTextWidget.dart';
import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';
import 'package:jakel_pos/modules/customers/CustomersViewModel.dart';

class AddQuickCustomer extends StatefulWidget {
  final Function onCustomerAdded;

  const AddQuickCustomer({Key? key, required this.onCustomerAdded})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddQuickCustomerState();
  }
}

class _AddQuickCustomerState extends State<AddQuickCustomer> {
  final viewModel = CustomersViewModel();
  CustomerTypes? selectedCustomerType;
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final cardNumberController = TextEditingController();

  final nameNode = FocusNode();
  final mobileNode = FocusNode();
  final cardNumberNode = FocusNode();

  var callApi = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          width: 400,
          child: IntrinsicHeight(
            child: getRootWidget(),
          ),
        ));
  }

  Widget getRootWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HeaderTextWidget(
                text: "Add Customer",
                color: getPrimaryColor(context),
              ),
              MyInkWellWidget(
                  child: Icon(
                    Icons.close,
                    color: Theme.of(context).primaryColor,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  })
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          typeWidget(),
          const SizedBox(
            height: 20,
          ),
          MyTextFieldWidget(
            controller: nameController,
            node: nameNode,
            hint: "Enter Name",
          ),
          const SizedBox(
            height: 20,
          ),
          MyTextFieldWidget(
            controller: mobileController,
            node: mobileNode,
            hint: "Enter mobile number",
          ),
          const SizedBox(
            height: 20,
          ),
          MyTextFieldWidget(
            controller: cardNumberController,
            node: cardNumberNode,
            hint: "Enter Card Number",
          ),
          const SizedBox(
            height: 20,
          ),
          buttonWidget()
        ],
      ),
    );
  }

  Widget typeWidget() {
    return SizedBox(
      height: 50,
      child: DropdownSearch<CustomerTypes>(
        compareFn: (item1, item2) {
          return false;
        },
        popupProps: const PopupProps.menu(
          showSelectedItems: true,
        ),
        asyncItems: (String filter) => viewModel.getCustomerTypes(),
        onChanged: (value) {
          setState(() {
            selectedCustomerType = value;
          });
        },
        itemAsString: (item) {
          return item.name!;
        },
        selectedItem: selectedCustomerType,
      ),
    );
  }

  Widget buttonWidget() {
    if (callApi) {
      return apiWidget();
    }
    return MyOutlineButton(text: 'save', onClick: () => {_save()});
  }

  void _save() {
    if (selectedCustomerType == null) {
      showToast('select_customer_type', context);
      return;
    }
    if (nameController.text.isEmpty) {
      showToast('enter_name', context);
      return;
    }

    if (mobileController.text.isEmpty) {
      showToast('enter_mobile_no', context);
      return;
    }

    if (cardNumberController.text.isEmpty) {
      showToast('Enter card number', context);
      return;
    }

    if (!isValidMobileNumber(mobileController.text)) {
      showToast('Invalid mobile number', context);
      return;
    }
    _storeCustomerInLocal();

    //Store in DB to create new customer.
    //_storeCustomerInCloud();
  }

  void _storeCustomerInLocal() {
    Customers customer = Customers(
        firstName: nameController.text,
        mobileNumber: mobileController.text,
        cardNumber: cardNumberController.text,
        typeDetails: TypeDetails(
            id: selectedCustomerType?.id, name: selectedCustomerType?.name));

    widget.onCustomerAdded(customer);
    Navigator.pop(context);
  }

  void _storeCustomerInCloud() {
    setState(() {
      callApi = true;
      final request = CreateCustomerRequest(
          firstName: nameController.text,
          mobileNumber: mobileController.text,
          cardNumber: cardNumberController.text,
          typeId: selectedCustomerType!.id);

      viewModel.createCustomer(request);
    });
  }

  Widget apiWidget() {
    return StreamBuilder<CustomersResponse>(
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
          if (response != null && response.customer != null) {
            goBack(response.customer!);
            return const SizedBox();
          } else if (response != null && response.message != null) {
            showToast(response.message ?? "", context);
            callApi = false;
            return buttonWidget();
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

  Future<void> goBack(Customers customers) async {
    viewModel.closeObservable();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onCustomerAdded(customers);
      Navigator.pop(context);
    });
  }
}
