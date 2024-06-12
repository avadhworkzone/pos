import 'package:flutter/material.dart';
import 'package:jakel_base/jakel_base.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsResponse.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/errorwidget/MyErrorWidget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';
import 'package:jakel_pos/modules/customers/CustomersViewModel.dart';
import 'package:jakel_pos/modules/refundBookingPayment/RefundBookingPaymentViewModel.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/bookingpayments/booking_payments_widget.dart';

class RefundBookingWidget extends StatefulWidget {
  final Function refundBookingPayments;
  final RefundBookingPaymentViewModel mRefundViewModel;

  const RefundBookingWidget({
    Key? key,
    required this.refundBookingPayments,
    required this.mRefundViewModel,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RefundBookingState();
  }
}

class _RefundBookingState extends State<RefundBookingWidget> {
  bool callApi = false;

  final searchController = TextEditingController();
  final searchNode = FocusNode();

  final viewModel = CustomersViewModel();
  double amountTobeUsedFromCreditNote = 0;
  var isLoadedOnce = false;
  late var width;
  late var height;
  late CustomersResponse selectedCustomersResponse;
  late Customers selectedCustomers;
  bool searchCustomer = false;
  bool searchBookingPayment = false;
  BookingPayments? selectedBookingPayments;

  @override
  void initState() {
    super.initState();
  }

  callCreditNoteApi(String sValue) {
    viewModel.searchCustomer(sValue);
    setState(() {
      searchBookingPayment = false;
      searchCustomer = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return getRootWidget();
  }

  Widget getRootWidget() {
    List<Widget> widgets = List.empty(growable: true);

    // Enter Points
    widgets.add(
      searchBookingPayment
          ? GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(selectedCustomers.firstName.toString()),
                  Text(selectedCustomers.mobileNumber.toString()),
                  SizedBox(
                    width: 80,
                    height: 30,
                    child: MyOutlineButton(
                      text: 'Cancel',
                      onClick: _refundCancel,
                    ),
                  )
                ],
              ),
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(12.0)),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          margin: const EdgeInsets.all(10.0),
                          width: 800,
                          height: 700,
                          child: Column(
                            children: [
                              getTopWidget(),
                              Expanded(
                                  child: BookingPaymentWidget(
                                    customerId: selectedCustomers.id,
                                    onBookingPaymentSelected:
                                        (bookingPayments) {
                                      Navigator.pop(context);
                                      setState(() {
                                        selectedBookingPayments =
                                            bookingPayments;
                                        searchBookingPayment = true;
                                      });
                                    },
                                  ))
                            ],
                          ),
                        ));
                  },
                );
              },
            )
          : MyTextFieldWidget(
              controller: searchController,
              node: searchNode,
              keyboardType: TextInputType.name,
              onSubmitted: (value) async {
                if (value.isNotEmpty) {
                  callCreditNoteApi(value);
                }
              },
              hint: "Search customer & press enter",
            ),
    );

    widgets.add(const SizedBox(
      height: 20,
    ));

    widgets.add(Expanded(
        child: searchBookingPayment
            ? bookingPaymentDetails()
            : validateAndGetCustomerList()));

    widgets.add(const SizedBox(
      height: 20,
    ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget validateAndGetCustomerList() {
    if (searchController.text.isEmpty) {
      return const Text("Please enter customer name ...");
    } else {
      return buttonAndCustomerList();
    }
  }

  Widget buttonAndCustomerList() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(searchCustomer ? creditNoteWidget() : const SizedBox());

    return Column(children: widgets);
  }

  Widget creditNoteWidget() {
    return StreamBuilder<CustomersResponse>(
      stream: viewModel.responseSubject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyLoadingWidget();
        }
        if (snapshot.hasError) {
          return MyErrorWidget(message: "Error", tryAgain: () {});
        }
        if (snapshot.connectionState == ConnectionState.active) {
          selectedCustomersResponse = snapshot.data as CustomersResponse;
          if (selectedCustomersResponse.members != null &&
              selectedCustomersResponse.members!.isNotEmpty) {
            return Flexible(
                child: SizedBox(
              height: height * 0.5,
              // color: Colors.green,
              child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                        color: Theme.of(context).dividerColor,
                      ),
                  shrinkWrap: true,
                  itemCount: selectedCustomersResponse.members!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          selectedCustomers =
                              selectedCustomersResponse.members![index];
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.0)),
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    margin: const EdgeInsets.all(10.0),
                                    width: 800,
                                    height: 700,
                                    child: Column(
                                      children: [
                                        getTopWidget(),
                                        Expanded(
                                            child: BookingPaymentWidget(
                                          customerId: selectedCustomersResponse
                                              .members![index].id,
                                          onBookingPaymentSelected:
                                              (bookingPayments) {
                                            Navigator.pop(context);
                                            setState(() {
                                              selectedBookingPayments =
                                                  bookingPayments;
                                              searchBookingPayment = true;
                                            });
                                          },
                                        ))
                                      ],
                                    ),
                                  ));
                            },
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          color: Colors.transparent,
                          height: 45,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(selectedCustomersResponse
                                  .members![index].firstName
                                  .toString()),
                              Text(selectedCustomersResponse
                                  .members![index].mobileNumber
                                  .toString())
                            ],
                          ),
                        ));
                  }),
            ));
          } else if (selectedCustomersResponse.members == null ||
              selectedCustomersResponse.members!.isEmpty) {
            return const Text("This customer not exist ...");
          }
        }
        return Container();
      },
    );
  }

  Widget getTopWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Booking Payments",
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

  Widget bookingPaymentDetails() {
    // selectedBookingPayments
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Status :"),
                Text(selectedBookingPayments!.status.toString()),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Booking Payment Amount :"),
                Text(getReadableAmount(
                    getCurrency(), selectedBookingPayments!.totalAmount)),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Available Booking Payment Amount :"),
                Text(getReadableAmount(
                    getCurrency(), selectedBookingPayments!.availableAmount)),
              ],
            ),
          ],
        ),
        widget.mRefundViewModel
                .isActiveBookingPayments(selectedBookingPayments!)
            ? SizedBox(
                width: 100,
                height: 40,
                child: MyOutlineButton(
                  text: 'Refund',
                  onClick: _refund,
                ),
              )
            : const SizedBox()
      ],
    );
  }

  void _refundCancel() {
    setState(() {
      searchCustomer = false;
      searchBookingPayment = false;
      searchController.text = "";
    });
  }

  void _refund() {
    widget.refundBookingPayments(
      selectedBookingPayments,
    );
  }
}
