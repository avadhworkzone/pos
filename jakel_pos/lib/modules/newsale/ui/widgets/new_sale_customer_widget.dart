import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jakel_base/constants.dart';
import 'package:jakel_base/restapi/customers/model/CustomerResponse.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/restapi/generatememberloyaltypointvoucher/model/GenerateMemberLoyaltyPointVoucherResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/VoucherConfigurationResponse.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/num_utils.dart';

import 'package:jakel_base/widgets/custom/my_vertical_divider.dart';
import 'package:jakel_base/widgets/errorwidget/MyErrorWidget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_base/widgets/nodatawidget/NoDataWidget.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_pos/modules/customers/ui/widget/customer_redeem_point_vouchers_widget.dart';
import 'package:jakel_pos/modules/customers/ui/widget/generate_birthday_voucher.dart';

import '../../../customers/CustomersViewModel.dart';
import '../../../customers/ui/widget/customer_vouchers_widget.dart';
import '../../../vouchers/VouchersViewModel.dart';

class NewSaleCustomerWidget extends StatefulWidget {
  final List<VoucherConfiguration> allVoucherConfigurations;
  final CartSummary cartSummary;
  final Function onSelected;
  final Function removeCustomer;
  final Function markAsLayawaySale;
  final Function markAsBookingSale;
  final Function onVoucherSelected;
  final Function addNewCustomer;

  const NewSaleCustomerWidget(
      {Key? key,
      required this.onSelected,
      required this.cartSummary,
      required this.removeCustomer,
      required this.markAsLayawaySale,
      required this.markAsBookingSale,
      required this.onVoucherSelected,
      required this.addNewCustomer,
      required this.allVoucherConfigurations})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NewSaleCustomerWidgetState();
  }
}

class _NewSaleCustomerWidgetState extends State<NewSaleCustomerWidget> {
  final viewModel = CustomersViewModel();
  final voucherViewModel = VouchersViewModel();

  final searchController = TextEditingController();
  final FocusNode searchNode = FocusNode();
  String? searchText;
  List<Customers>? customersList;
  Customers? selectedCustomer;
  bool isClear = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
          margin: const EdgeInsets.all(4),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 90,
                  height: double.infinity,
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  child: Center(
                    child: Text(
                      "Member",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                Expanded(child: getRootWidget())
              ],
            ),
          )),
    );
  }

  Widget getRootWidget() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(getMainWidget());

    if (!widget.cartSummary.isExchangeOrReturns()) {
      widgets.add(SizedBox(
        height: 20,
        child: getLayawayBooking(),
      ));
    } else {
      widgets.add(const SizedBox(
        height: 20,
      ));
    }

    widgets.add(const SizedBox(
      height: 10,
    ));

    return Column(
      children: widgets,
    );
  }

  Widget getMainWidget() {
    if (widget.cartSummary.customers == null) {
      return searchWidgetWithList();
    } else {
      return customerDetailsWidget(context);
    }
  }

  Widget customerDetailsWidget(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: Theme.of(context).dividerColor)),
        margin: const EdgeInsets.only(top: 15, bottom: 15, left: 5),
        child: IntrinsicHeight(
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 2,
                  ),
                  Expanded(
                      flex: 3,
                      child: customerNameMobileWidget(
                          viewModel.name(widget.cartSummary.customers!),
                          widget.cartSummary.customers?.mobileNumber ?? noData,
                          widget.cartSummary.customers?.dateOfBirth ?? noData)),
                  const SizedBox(
                    width: 2,
                  ),
                  const MyVerticalDivider(
                    height: 45,
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Expanded(
                      flex: 2,
                      child: customerPointsVouchers(
                          '${getInValue(widget.cartSummary.customers!.totalLoyaltyPoints)}',
                          widget.cartSummary.customers?.customerVouchers
                                  ?.length ??
                              0)),
                  widget.cartSummary.isBookingItemReset? const SizedBox():
                  deleteIconWidget(context)
                ],
              ),
            ],
          ),
        ));
  }

  Widget getLayawayBooking() {
    if (widget.cartSummary.customers == null) {
      return Container();
    }
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(Expanded(
      child: generateBirthdayVoucherWidget(),
    ));

    if (!widget.cartSummary.isBookingSale) {
      widgets.add(
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Layaway',
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Checkbox(
                  value: widget.cartSummary.isLayAwaySale,
                  onChanged: (value) {
                    setState(() {
                      if (value != null) {
                        widget.markAsLayawaySale(value);
                      }
                    });
                  })
            ],
          ),
        ),
      );
    } else {
      widgets.add(Expanded(child: Container()));
    }

    if (!widget.cartSummary.isLayAwaySale) {
      widgets.add(Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Booking',
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Checkbox(
                value: widget.cartSummary.isBookingSale,
                onChanged: (value) {
                  if(!widget.cartSummary.isBookingItemReset) {
                    setState(() {
                      if (value != null) {
                        widget.cartSummary.resetPaymentType();
                        widget.markAsBookingSale(value);
                      }
                    });
                  }
                })
          ],
        ),
      ));
    } else {
      widgets.add(Expanded(child: Container()));
    }

    return Row(
      children: widgets,
    );
  }

  Widget generateBirthdayVoucherWidget() {
    if (widget.cartSummary.customers != null) {
      return GenerateBirthdayVoucher(
        allVoucherConfigurations: widget.allVoucherConfigurations,
        customer: widget.cartSummary.customers!,
        onCustomerUpdated: widget.onSelected,
      );
    }
    return Container();
  }

  Widget deleteIconWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.removeCustomer();
      },
      child: Container(
        width: 50,
        height: 60,
        padding: const EdgeInsets.all(0.5),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
            border:
                Border.all(width: 0.1, color: Theme.of(context).dividerColor)),
        child: Icon(
          Icons.close,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }

  Widget searchWidget() {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 14),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Theme.of(context).dividerColor)),
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              focusNode: searchNode,
              onSubmitted: (value) {
                setState(() {
                  if (value.isNotEmpty) {
                    searchText = value;
                    isClear = false;
                    viewModel.searchCustomer(searchText!);
                  }
                });
              },
              style: Theme.of(context).textTheme.bodySmall,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                filled: true,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 0.0, color: Colors.transparent),
                ),
                fillColor: getWhiteColor(context),
                hintText: 'Search customer & press enter',
                hintStyle: Theme.of(context).textTheme.caption,
              ),
            ),
          ),
          Container(
            width: 1,
            color: Theme.of(context).dividerColor,
          ),
          MyInkWellWidget(
              child: Container(
                width: 50,
                height: 50,
                padding: const EdgeInsets.all(0.5),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5)),
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    border: Border.all(
                        width: 0.1, color: Theme.of(context).dividerColor)),
                child: Icon(
                  Icons.person_add_alt,
                  color: Theme.of(context).indicatorColor,
                ),
              ),
              onTap: () {
                widget.addNewCustomer();
              })
        ],
      ),
    );
  }

  Widget searchWidgetWithList() {
    List<Widget> widgets = List.empty(growable: true);
    widgets.add(isClear ? Container() : getSearchedItemsHeaderWidget());
    widgets.add(isClear ? Container() : getSearchedItemsWidget());
    widgets.add(searchWidget());

    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  Widget getSearchedItemsHeaderWidget() {
    //When no items are searched
    if (searchText == null || searchText!.isEmpty) {
      return const SizedBox();
    } else {
      return Container(
        margin: const EdgeInsets.only(left: 15, right: 18, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Member List",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            MyInkWellWidget(
                child: const Icon(Icons.close),
                onTap: () {
                  setState(() {
                    isClear = true;
                  });
                })
          ],
        ),
      );
    }
  }

  Widget getSearchedItemsWidget() {
    //When no items are searched
    if (searchText == null || searchText!.isEmpty) {
      return const SizedBox();
    }

    return AnimatedContainer(
        height: 200,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: Theme.of(context).dividerColor)),
        margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
        padding: const EdgeInsets.only(top: 10.0, bottom: 10),
        duration: const Duration(seconds: 1),
        child: searchingWidget());
  }

  Widget searchedItemsListWidget() {
    if (customersList == null || customersList!.isEmpty) {
      return const NoDataWidget();
    }

    return ListView.builder(
        shrinkWrap: true,
        itemCount: customersList!.length,
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () {
                _onCustomerSelected(customersList![index]);
              },
              child: Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    border: Border.all(color: Theme.of(context).dividerColor)),
                child: customerNameMobileWidget(
                    viewModel.name(customersList![index]),
                    customersList![index].mobileNumber ?? noData,
                    customersList![index].dateOfBirth ?? noData),
              ));
        });
  }

  Widget searchingWidget() {
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
          var empResponse = snapshot.data;
          if (empResponse != null && empResponse.members != null) {
            customersList = empResponse.members;
            return searchedItemsListWidget();
          } else {
            return const NoDataWidget();
          }
        }
        return Container();
      },
    );
  }

  Widget customerNameMobileWidget(String name, String mobile, String dob) {
    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Name  ',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const MyVerticalDivider(
                height: 15,
              ),
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              )
            ],
          ),
          const Divider(),
          Row(
            children: [
              Text(
                'Mobile',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const MyVerticalDivider(
                height: 15,
              ),
              Expanded(
                  child: Text(
                mobile,
                style: Theme.of(context).textTheme.bodyLarge,
              ))
            ],
          ),
        ],
      ),
    );
  }

  Widget customerPointsVouchers(String points, int vouchers) {
    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyInkWellWidget(
              onTap: () {
                if (int.parse(points) > 0) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return CustomerRedeemPointToVouchersWidget(
                          customers: widget.cartSummary.customers!,
                          onSelected: (GenerateMemberLoyaltyPointVoucherResponse
                              mGenerateMemberLoyaltyPointVoucherResponse) async {
                            if (mGenerateMemberLoyaltyPointVoucherResponse
                                    .voucher !=
                                null) {
                              CustomerDetailsResponse mCustomersResponse =
                                  await viewModel.customerDetails(
                                      widget.cartSummary.customers?.id ?? 0);
                              setState(() {
                                _onCustomerSelected( mCustomersResponse.member!);
                              });
                            }
                          });
                    },
                  );
                } else {
                  showToast('Point should be greater than 0', context);
                }
              },
              child: Row(
                children: [
                  Text(
                    'Points     ',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const MyVerticalDivider(
                    height: 15,
                  ),
                  Expanded(
                    child: Text(
                      points,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                ],
              )),
          const Divider(),
          MyInkWellWidget(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return CustomerVouchersWidget(
                      customers: widget.cartSummary.customers!,
                      onSelected: widget.onVoucherSelected,
                    );
                  },
                );
              },
              child: Row(
                children: [
                  Text(
                    'Vouchers',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const MyVerticalDivider(
                    height: 15,
                  ),
                  Expanded(
                      child: Text(
                    '$vouchers',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ))
                ],
              )),
        ],
      ),
    );
  }

  void _onCustomerSelected(Customers customers) {
    FocusScope.of(context).requestFocus(searchNode);
    searchController.text = "";
    searchText = null;
    widget.onSelected(customers);
  }
}
