import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_pos/modules/customers/CustomersViewModel.dart';
import 'package:jakel_pos/modules/customers/ui/widget/customer_vouchers_widget.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/credit_notes/credit_notes_widget.dart';

import '../../../../routing/route_names.dart';
import '../../../saleshistory/ui/widgets/bookingpayments/booking_payments_widget.dart';

class CustomerDetailWidget extends StatefulWidget {
  final Customers customers;
  final Function close;

  const CustomerDetailWidget(
      {Key? key, required this.customers, required this.close})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CustomerDetailWidgetState();
  }
}

class _CustomerDetailWidgetState extends State<CustomerDetailWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final viewModel = CustomersViewModel();

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    viewModel.closeObservable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        constraints: const BoxConstraints.expand(),
        child: _getRootWidget(),
      ),
    );
  }

  _getRootWidget() {
    return SingleChildScrollView(
      child: Column(
        children: _getChildrenWidgets(),
      ),
    );
  }

  List<Widget> _getChildrenWidgets() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(getHeader());

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(getPersonalInfoCard());

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(membershipInfoCard());

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(historyInfoCard());

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(bookingPayments());

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(creditNotes());

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(MyDataContainerWidget(child: vouchersInfoWidget()));

    widgets.add(const SizedBox(
      height: 10,
    ));

    return widgets;
  }

  Widget getHeader() {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Customer information",
              style: Theme.of(context).textTheme.bodyLarge),
          MyInkWellWidget(
              child: const Icon(Icons.close),
              onTap: () {
                widget.close();
              })
        ],
      ),
    );
  }

  Widget getPersonalInfoCard() {
    return MyDataContainerWidget(child: getPersonalInfoWidget());
  }

  Widget getPersonalInfoWidget() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Personal information",
              style: Theme.of(context).textTheme.bodyLarge),
          MyInkWellWidget(
              child: const Icon(
                Icons.edit,
                size: 15,
              ),
              onTap: () {
                Navigator.pushNamed(context, AddCustomerRoute,
                    arguments: widget.customers);
              })
        ],
      ),
    ));

    widgets.add(const Divider());

    widgets.add(keyRowPair(
      "Name",
      viewModel.fullName(widget.customers),
      "status",
      viewModel.status(widget.customers),
      "Gender",
      viewModel.gender(widget.customers),
    ));

    widgets.add(const Divider(
      height: 40,
    ));

    widgets.add(keyRowPair(
      "DOB",
      viewModel.dateOfBirth(widget.customers),
      "Email Id",
      viewModel.email(widget.customers),
      "Mobile.",
      viewModel.mobileNumber(widget.customers),
    ));

    widgets.add(const Divider(
      height: 40,
    ));

    widgets.add(keyRowPair(
      "Type",
      viewModel.type(widget.customers),
      "Race",
      viewModel.race(widget.customers),
      "",
      "",
    ));

    widgets.add(const Divider(
      height: 40,
    ));

    widgets.add(
      Text(
        "Address",
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.caption,
      ),
    );

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(
      Text(
        viewModel.address(widget.customers),
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );

    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  Widget membershipInfoCard() {
    return MyDataContainerWidget(child: membershipInfoWidget());
  }

  Widget membershipInfoWidget() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Membership", style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    ));

    widgets.add(const Divider());

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(keyRowPair(
      "Type",
      "VIP",
      "Total Points Earned",
      getOnlyReadableAmount(widget.customers.totalLoyaltyPoints),
      "Available Points",
      getOnlyReadableAmount(0.0),
    ));

    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  Widget historyInfoCard() {
    return MyDataContainerWidget(child: historyInfoWidget());
  }

  Widget historyInfoWidget() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("History", style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    ));

    widgets.add(const Divider());

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(keyRowPair(
      "Last Visit",
      viewModel.lastPurchased(widget.customers),
      "Total Spent",
      viewModel.spentTillNow(widget.customers),
      "Total Orders",
      viewModel.totalOrders(widget.customers),
    ));

    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  Widget bookingPayments() {
    return MyDataContainerWidget(child: bookingPaymentsInfoWidget());
  }

  Widget bookingPaymentsInfoWidget() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Booking Payments",
              style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    ));

    widgets.add(const Divider());

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(MyInkWellWidget(
        child: Text("View All"),
        onTap: () {
          _showBookingPaymentsDialog();
        }));

    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  Widget creditNotes() {
    return MyDataContainerWidget(child: creditNotesInfoWidget());
  }

  Widget creditNotesInfoWidget() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Credit Notes",
              style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    ));

    widgets.add(const Divider());

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(MyInkWellWidget(
        child: Text("View All"),
        onTap: () {
          _showCreditNotesDialog();
        }));

    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  Widget vouchersInfoWidget() {
    int vouchersLength = 0;
    if (widget.customers.customerVouchers != null) {
      vouchersLength = widget.customers.customerVouchers!.length;
    }
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Vouchers ($vouchersLength)",
              style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    ));

    widgets.add(const Divider());

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(MyInkWellWidget(
        child: Text("View All"),
        onTap: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return CustomerVouchersWidget(
                customers: widget.customers,
              );
            },
          );
        }));

    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  Widget keyRowPair(String key1, String value1, String key2, String value2,
      String key3, String value3) {
    return Row(
      children: [
        Expanded(
          child: keyColumnPair(key1, value1),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: keyColumnPair(key2, value2),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: keyColumnPair(key3, value3),
        ),
      ],
    );
  }

  Widget keyColumnPair(String key1, String value1) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          key1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.caption,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          value1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Future<void> _showBookingPaymentsDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.all(10.0),
              width: 800,
              height: 700,
              child: Column(
                children: [
                  getTopWidget("Booking Payments"),
                  Expanded(
                      child: BookingPaymentWidget(
                    customerId: widget.customers.id,
                    onBookingPaymentSelected: (bookingPayments) => {},
                        isTopUpBookingPayment: true,
                  ))
                ],
              ),
            ));
      },
    );
  }

  Future<void> _showCreditNotesDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.all(10.0),
              width: 800,
              height: 700,
              child: Column(
                children: [
                  getTopWidget("Credit Notes"),
                  Expanded(
                      child: CreditNoteWidget(
                    customerId: widget.customers.id,
                    onCreditNoteSelected: (creditNote) => {},
                  ))
                ],
              ),
            ));
      },
    );
  }

  Widget getTopWidget(String sTitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
         Text(
          sTitle,
          style: const TextStyle(
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
}
