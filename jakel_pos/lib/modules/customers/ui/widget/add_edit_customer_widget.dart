import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:jakel_base/restapi/customers/model/CreateCustomerRequest.dart';
import 'package:jakel_base/restapi/customers/model/CustomerRaceResponse.dart';
import 'package:jakel_base/restapi/customers/model/CustomerTitlesResponse.dart';
import 'package:jakel_base/restapi/customers/model/CustomerTypesResponse.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/restapi/customers/model/GenderResponse.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/my_date_utils.dart';
import 'package:jakel_base/utils/my_mobile_number_validation.dart';
import 'package:jakel_base/widgets/appbgwidget/MyBackgroundWidget.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';
import 'package:jakel_base/widgets/custom/my_title_back_arrow_widget.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_pos/modules/customers/CustomersViewModel.dart';

class AddEditCustomerWidget extends StatefulWidget {
  final Customers? customers;

  const AddEditCustomerWidget({Key? key, this.customers}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddEditCustomerWidgetState();
  }
}

class _AddEditCustomerWidgetState extends State<AddEditCustomerWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  final viewModel = CustomersViewModel();
  final fNameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final line1Controller = TextEditingController();
  final line2Controller = TextEditingController();
  final cityController = TextEditingController();
  final areaController = TextEditingController();

  final companyNameController = TextEditingController();
  final companyRegistrationController = TextEditingController();
  final companyTaxController = TextEditingController();
  final companyPhoneController = TextEditingController();

  final notesController = TextEditingController();

  final fNameFocusNode = FocusNode();
  final cardNumberFocusNode = FocusNode();
  final mobileFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final line1FocusNode = FocusNode();
  final line2FocusNode = FocusNode();
  final cityFocusNode = FocusNode();
  final areaNode = FocusNode();

  final companyNameFocusNode = FocusNode();
  final companyRegistrationFocusNode = FocusNode();
  final companyTaxFocusNode = FocusNode();
  final companyPhoneFocusNode = FocusNode();

  final notesNode = FocusNode();

  Customers? customers;

  bool isSaveClicked = false;
  TypeDetails? type;
  TitleDetails? title;
  RaceDetails? race;
  GenderDetails? gender;
  String? dob;

  double boxHeight = 50.0;
  bool? enablePromotionalMails = false;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();

    isSaveClicked = false;

    if (widget.customers != null) {
      if (widget.customers?.typeDetails != null) {
        type = TypeDetails.fromJson(widget.customers!.typeDetails!.toJson());
      }

      if (widget.customers?.raceDetails != null) {
        race = RaceDetails.fromJson(widget.customers!.raceDetails!.toJson());
      }

      if (widget.customers?.genderDetails != null) {
        gender =
            GenderDetails.fromJson(widget.customers!.genderDetails!.toJson());
      }

      if (widget.customers?.titleDetails != null) {
        title = TitleDetails.fromJson(widget.customers!.titleDetails!.toJson());
      }

      if (widget.customers?.firstName != null) {
        fNameController.text = widget.customers!.firstName!;
      }

      // if (widget.customers?.lastName != null) {
      //   cardNumberController.text = widget.customers!.lastName!;
      // }

      if (widget.customers?.email != null) {
        emailController.text = widget.customers!.email!;
      }

      if (widget.customers?.mobileNumber != null) {
        mobileController.text = widget.customers!.mobileNumber!;
      }

      if (widget.customers?.addressLine1 != null) {
        line1Controller.text = widget.customers!.addressLine1!;
      }

      if (widget.customers?.addressLine2 != null) {
        line2Controller.text = widget.customers!.addressLine2!;
      }

      if (widget.customers?.city != null) {
        cityController.text = widget.customers!.city!;
      }

      if (widget.customers?.areaCode != null) {
        areaController.text = widget.customers!.areaCode!;
      }

      if (widget.customers?.companyName != null) {
        companyNameController.text = widget.customers!.companyName!;
      }

      if (widget.customers?.companyTax != null) {
        companyTaxController.text = widget.customers!.companyTax!;
      }

      if (widget.customers?.companyPhone != null) {
        companyPhoneController.text = widget.customers!.companyPhone!;
      }

      if (widget.customers?.companyRegistrationNumber != null) {
        companyRegistrationController.text =
            widget.customers!.companyRegistrationNumber!;
      }

      if (widget.customers?.notes != null) {
        notesController.text = widget.customers!.notes!;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.closeObservable();
    _controller?.dispose();
    fNameFocusNode.dispose();
    cardNumberFocusNode.dispose();
    mobileFocusNode.dispose();
    emailFocusNode.dispose();
    line1FocusNode.dispose();
    line2FocusNode.dispose();
    cityFocusNode.dispose();
    areaNode.dispose();
    companyNameFocusNode.dispose();
    companyRegistrationFocusNode.dispose();
    companyTaxFocusNode.dispose();
    companyPhoneFocusNode.dispose();
    notesNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MyBackgroundWidget(
            child: Padding(
      padding: EdgeInsets.all(10.0),
      child: rootWidget(),
    )));
  }

  Widget rootWidget() {
    return Container(
      color: getWhiteColor(context),
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          getHeader(),
          const SizedBox(
            height: 15,
          ),
          Expanded(flex: 10, child: getFormWidget())
        ],
      ),
    );
  }

  Widget getHeader() {
    return Container(
      decoration: BoxDecoration(
          color: getWhiteColor(context),
          border: Border.all(color: Theme.of(context).primaryColor, width: 1.0),
          borderRadius: const BorderRadius.all(Radius.circular(4.0))),
      height: 50,
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: getTitleWidget(),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: storeCustomerWidget(),
            ),
          )
        ],
      ),
    );
  }

  Widget getTitleWidget() {
    return const IntrinsicWidth(
      child: MyTitleBackArrowWidget(
        title: "Add Customer",
      ),
    );
  }

  Widget storeCustomerWidget() {
    if (!isSaveClicked) {
      return getSaveButtonWidget();
    }
    return StreamBuilder<CustomersResponse>(
      stream: viewModel.responseSubject,
      // ignore: missing_return, missing_return
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyLoadingWidget();
        }
        if (snapshot.hasError) {
          showToast("Error!Please try again later", context);
          return getSaveButtonWidget();
        }
        if (snapshot.connectionState == ConnectionState.active) {
          var networkResponse = snapshot.data;
          if (networkResponse?.customer != null) {
            showToast("Added Customer Successfully!", context);
            onSuccess();
            return Container();
          } else if (networkResponse != null &&
              networkResponse.message != null) {
            showToast(networkResponse.message ?? "", context);
            return getSaveButtonWidget();
          } else {
            showToast("Error!Please try again later", context);
            return getSaveButtonWidget();
          }
        }
        return Container();
      },
    );
  }

  Widget getSaveButtonWidget() {
    return SizedBox(
        width: 200,
        child: MyOutlineButton(
            text: 'Save',
            onClick: () {
              validateCustomerInfo();
            }));
  }

  void validateCustomerInfo() {
    if (mobileController.text.isEmpty) {
      showToast("Please enter mobile number", context);
      return;
    }

    if (!isValidMobileNumber(mobileController.text)) {
      showToast('Invalid mobile number', context);
      return;
    }

    if (fNameController.text.isEmpty) {
      showToast("Please enter full name", context);
      return;
    }

    if (cardNumberController.text.isEmpty) {
      showToast("Please enter card number", context);
      return;
    }

    if (type == null) {
      showToast("Please select customer type", context);
      return;
    }

    setState(() {
      isSaveClicked = true;

      final request = CreateCustomerRequest(
        firstName: fNameController.text,
        cardNumber: cardNumberController.text,
        mobileNumber: mobileController.text,
        titleId: title?.id,
        genderId: gender?.id,
        typeId: type?.id,
        raceId: race?.id,
        email: emailController.text.isEmpty ? null : emailController.text,
        dateOfBirth: dob,
        addressLine1:
            line1Controller.text.isEmpty ? null : line1Controller.text,
        addressLine2:
            line2Controller.text.isEmpty ? null : line2Controller.text,
        city: cityController.text.isEmpty ? null : cityController.text,
        areaCode: areaController.text.isEmpty ? null : areaController.text,
        companyName: companyNameController.text.isEmpty
            ? null
            : companyNameController.text,
        companyRegistrationNumber: companyRegistrationController.text.isEmpty
            ? null
            : companyRegistrationController.text,
        companyPhone: companyPhoneController.text.isEmpty
            ? null
            : companyPhoneController.text,
        companyTaxNumber: companyTaxController.text.isEmpty
            ? null
            : companyTaxController.text,
        notes: notesController.text.isEmpty ? null : notesController.text,
      );

      if (widget.customers != null) {
        viewModel.updateCustomer(widget.customers!.id!, request);
      } else {
        viewModel.createCustomer(request);
      }
    });
  }

  Widget getFormWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          getPersonalInfoWidget(),
          const SizedBox(
            height: 20,
          ),
          getCustomerNotes(),
          const SizedBox(
            height: 20,
          ),
          getPromotionalInfo(),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget getCustomerNotes() {
    return MyDataContainerWidget(
        child: IntrinsicHeight(
      child: Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          Row(
            children: [
              const Icon(
                Icons.notes_outlined,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                "Customer Notes",
                style: Theme.of(context).textTheme.bodyLarge,
              )
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          getTextFieldWidget(
              notesController, notesNode, "Add note about customer"),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    ));
  }

  Widget getPromotionalInfo() {
    return MyDataContainerWidget(
        child: IntrinsicHeight(
      child: Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          Row(
            children: [
              const Icon(
                Icons.notification_important_outlined,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                "More options",
                style: Theme.of(context).textTheme.bodyLarge,
              )
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Promotional emails",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Checkbox(
                  value: enablePromotionalMails,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (value) {
                    setState(() {
                      enablePromotionalMails = value;
                    });
                  })
            ],
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    ));
  }

  Widget getPersonalInfoWidget() {
    return MyDataContainerWidget(
        child: IntrinsicHeight(
      child: Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          Row(
            children: [
              const Icon(
                Icons.person_outline,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                "Personal Information",
                style: Theme.of(context).textTheme.bodyLarge,
              )
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          titleTypeRaceWidget(),
          const SizedBox(
            height: 15,
          ),
          firstLastNameWidget(),
          const SizedBox(
            height: 15,
          ),
          genderDobWidget(),
          const SizedBox(
            height: 15,
          ),
          emailCountryMobile(),
          const SizedBox(
            height: 15,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child:
                Text("Address", style: Theme.of(context).textTheme.bodyLarge),
          ),
          const SizedBox(
            height: 15,
          ),
          addressLine1Line2(),
          const SizedBox(
            height: 15,
          ),
          cityAreaCode(),
          const SizedBox(
            height: 15,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Company Info",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          companyNamePhone(),
          const SizedBox(
            height: 15,
          ),
          companyRegistrationTax(),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    ));
  }

  Widget addressLine1Line2() {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child:
                getTextFieldWidget(line1Controller, line1FocusNode, "Line 1")),
        const SizedBox(
          width: 15,
        ),
        Expanded(
            flex: 1,
            child:
                getTextFieldWidget(line2Controller, line2FocusNode, "Line 2")),
      ],
    );
  }

  Widget cityAreaCode() {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: getTextFieldWidget(cityController, cityFocusNode, "City")),
      ],
    );
  }

  Widget emailCountryMobile() {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: getTextFieldWidget(
                emailController, emailFocusNode, "Email Id")),
        const SizedBox(
          width: 15,
        ),
        Expanded(
            flex: 1,
            child: getTextFieldWidget(
                mobileController, mobileFocusNode, "Mobile * ")),
      ],
    );
  }

  Widget genderDobWidget() {
    return Row(
      children: [
        Expanded(flex: 1, child: genderWidget()),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          flex: 1,
          child: dobWidget(),
        ),
      ],
    );
  }

  Widget genderWidget() {
    return SizedBox(
      height: 50,
      child: DropdownSearch<Genders>(
        compareFn: (item1, item2) {
          return false;
        },
        popupProps: const PopupProps.menu(
          showSelectedItems: true,
        ),
        asyncItems: (String filter) => viewModel.getAllGenders(),
        onChanged: (value) {
          setState(() {
            gender =
                value != null ? GenderDetails.fromJson(value.toJson()) : null;
          });
        },
        itemAsString: (item) {
          return item.name!;
        },
        selectedItem:
            gender != null ? Genders.fromJson(gender!.toJson()) : null,
      ),
    );
  }

  Widget dobWidget() {
    return InkWell(
      onTap: () {
        DatePicker.showDatePicker(
          context,
          minTime: DateTime.now().subtract(const Duration(days: 36500)),
          maxTime: DateTime.now(),
          onConfirm: (date) {
            setState(() {
              dob = readableDateSmall(date.millisecondsSinceEpoch);
            });
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        padding: const EdgeInsets.all(14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(dob == null ? "Select Date Of Birth" : dob!,
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(
              width: 20,
            ),
            Icon(
              Icons.calendar_today_outlined,
              color: Theme.of(context).colorScheme.secondary,
            )
          ],
        ),
      ),
    );
  }

  Widget firstLastNameWidget() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: getTextFieldWidget(
              fNameController, fNameFocusNode, "Full Name * "),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          flex: 1,
          child: getTextFieldWidget(
              cardNumberController, cardNumberFocusNode, "Card number"),
        ),
      ],
    );
  }

  Widget titleTypeRaceWidget() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: titleWidget(),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          flex: 2,
          child: typeWidget(),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          flex: 2,
          child: raceWidget(),
        )
      ],
    );
  }

  Widget titleWidget() {
    return SizedBox(
      height: 50,
      child: DropdownSearch<CustomerTitles>(
        compareFn: (item1, item2) {
          return false;
        },
        popupProps: const PopupProps.menu(
          showSelectedItems: true,
        ),
        asyncItems: (String filter) => viewModel.getCustomerTitles(),
        onChanged: (value) {
          setState(() {
            title =
                value != null ? TitleDetails.fromJson(value.toJson()) : null;
          });
        },
        itemAsString: (item) {
          return item.name!;
        },
        selectedItem:
            title != null ? CustomerTitles.fromJson(title!.toJson()) : null,
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
            type = value != null ? TypeDetails.fromJson(value.toJson()) : null;
          });
        },
        itemAsString: (item) {
          return item.name!;
        },
        selectedItem:
            type != null ? CustomerTypes.fromJson(type!.toJson()) : null,
      ),
    );
  }

  Widget raceWidget() {
    return SizedBox(
      height: 50,
      child: DropdownSearch<CustomerRaces>(
        compareFn: (item1, item2) {
          return false;
        },
        popupProps: const PopupProps.menu(
          showSelectedItems: true,
        ),
        asyncItems: (String filter) => viewModel.getCustomerRaces(),
        onChanged: (value) {
          setState(() {
            race = value != null ? RaceDetails.fromJson(value.toJson()) : null;
          });
        },
        itemAsString: (item) {
          return item.name!;
        },
        selectedItem:
            race != null ? CustomerRaces.fromJson(race!.toJson()) : null,
      ),
    );
  }

  Widget companyRegistrationTax() {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: getTextFieldWidget(companyRegistrationController,
                companyRegistrationFocusNode, "Company Registration No")),
        const SizedBox(
          width: 15,
        ),
        Expanded(
            flex: 1,
            child: getTextFieldWidget(
                companyTaxController, companyTaxFocusNode, "Company Tax")),
      ],
    );
  }

  Widget companyNamePhone() {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: getTextFieldWidget(
                companyNameController, companyNameFocusNode, "Company Name")),
        const SizedBox(
          width: 15,
        ),
        Expanded(
            flex: 1,
            child: getTextFieldWidget(companyPhoneController,
                companyPhoneFocusNode, "Company Phone")),
      ],
    );
  }

  Widget getTextFieldWidget(
      TextEditingController controller, FocusNode node, String hint) {
    return TextField(
      controller: controller,
      focusNode: node,
      style: Theme.of(context).textTheme.bodySmall,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
        filled: true,
        fillColor: getWhiteColor(context),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).primaryColor.withOpacity(0.6), width: 1),
        ),
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Future<void> onSuccess() async {
    viewModel.closeObservable();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
    });
  }
}
