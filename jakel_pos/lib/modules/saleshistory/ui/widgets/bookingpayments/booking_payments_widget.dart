import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsResponse.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsTopUpResponse.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingTopUpRequest.dart';
import 'package:jakel_base/restapi/companyconfiguration/model/CompanyConfigurationResponse.dart';
import 'package:jakel_base/restapi/paymenttypes/model/PaymentTypesResponse.dart';
import 'package:jakel_base/restapi/promoters/model/PromotersResponse.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/my_date_utils.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/custom/MyPaginationWidget.dart';
import 'package:jakel_base/widgets/errorwidget/MyErrorWidget.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_base/widgets/nodatawidget/NoDataWidget.dart';
import 'package:jakel_pos/modules/saleshistory/BookingPaymentViewModel.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/bookingpayments/booking_payment_dialog.dart';
import 'package:jakel_pos/modules/utils/scroll_bar_utils.dart';
import 'package:dropdown_search/dropdown_search.dart';

class BookingPaymentWidget extends StatefulWidget {
  final Function onBookingPaymentSelected;
  final Function? onBookingPaymentRemove;
  final CompanyConfigurationResponse? mCompanyConfigurationResponse;
  final int? customerId;
  final double? dueAmount;
  final bool? sBookingPaymentId;
  final bool? isTopUpBookingPayment;

  const BookingPaymentWidget({
    Key? key,
    required this.onBookingPaymentSelected,
    this.dueAmount,
    this.mCompanyConfigurationResponse,
    this.customerId,
    this.sBookingPaymentId,
    this.onBookingPaymentRemove,
    this.isTopUpBookingPayment,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BookingPaymentWidgetState();
  }
}

class _BookingPaymentWidgetState extends State<BookingPaymentWidget> {
  final viewModel = BookingPaymentViewModel();
  final searchController = TextEditingController();
  final searchNode = FocusNode();
  String? searchText;
  int pageNo = 1;
  int perPage = 20;
  List<BookingPayments>? bookingPayments;
  DateTime? fromDate, toDate;
  String? dateRangeText;
  String? filter;
  BookingPaymentsResponse? bookingPaymentResponse;
  BookingPayments? selected;
  int promoterId = 0;
  BookingPaymentUseType? mUserApplicableType;
  bool partially = false;

  @override
  void initState() {
    mUserApplicableType =
        widget.mCompanyConfigurationResponse?.bookingPaymentUseType;
    if (mUserApplicableType != null) {
      partially =
      ((mUserApplicableType?.key ?? "").toUpperCase() == "PARTIALLY");
    }
    super.initState();
    _getSales();
  }

  void _getSales() {
    viewModel.getBookingPayments(pageNo, perPage, widget.customerId ?? 0, 0,
        promoterId, (searchText ?? ""));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          searchWidget(),
          const SizedBox(
            height: 5,
          ),
          (widget.sBookingPaymentId ?? false) ? clearWidget() : SizedBox(),
          Expanded(
            child: apiWidget(),
          )
        ],
      ),
    );
  }

  Widget clearWidget() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
      alignment: Alignment.topRight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Theme.of(context).colorScheme.tertiary),
        onPressed: () {
          if (widget.onBookingPaymentRemove != null) {
            widget.onBookingPaymentRemove!();
          }
        },
        child: const Text("Clear", style: TextStyle(fontSize: 10)),
      ),
    );
  }

  Widget apiWidget() {
    return StreamBuilder<BookingPaymentsResponse>(
      stream: viewModel.responseSubject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          MyLogUtils.logDebug("apiWidget waiting");
          return const MyLoadingWidget();
        }
        if (snapshot.hasError) {
          MyLogUtils.logDebug("apiWidget hasError");
          return MyErrorWidget(
              message: "Error.Please try again!", tryAgain: _getSales);
        }
        if (snapshot.connectionState == ConnectionState.active) {
          var responseData = snapshot.data;
          if (responseData != null && responseData.bookingPayments != null) {
            bookingPaymentResponse = responseData;
            bookingPayments = responseData.bookingPayments;
            return showSalesList();
          } else {
            return MyErrorWidget(
                message: "Error.Please try again!", tryAgain: _getSales);
          }
        }
        return Container();
      },
    );
  }

  Widget searchWidget() {
    return Card(
      child: Container(
          margin: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                  flex: 8,
                  child: SizedBox(
                    height: 50,
                    child: selectPromoter(),
                  )),
              const SizedBox(width: 12),
              Expanded(
                  flex: 11,
                  child: SizedBox(
                    height: 50,
                    child: searchBookingWidget(),
                  )),
            ],
          )),
    );
  }

  Widget selectPromoter() {
    return SizedBox(
      height: 50,
      child: DropdownSearch<Promoters>(
        compareFn: (item1, item2) {
          return false;
        },
        dropdownDecoratorProps: const DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
              labelText: "Select Promoters",
              hintText: "Select Promoters",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(3)))),
        ),
        clearButtonProps: const ClearButtonProps(isVisible: true),
        popupProps: const PopupProps.menu(
          showSelectedItems: true,
        ),
        asyncItems: (String filter) => viewModel.getPromoters(),
        onChanged: (value) {
          setState(() {
            promoterId = value?.id ?? 0;
            _getSales();
          });
        },
        itemAsString: (item) {
          return item.firstName!;
        },
      ),
    );
  }

  Widget searchBookingWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: TextField(
              controller: searchController,
              focusNode: searchNode,
              onChanged: (text) {
                setState(() {
                  searchText = text;
                });
              },
              onSubmitted: (text) {
                searchText = text;
                _getSales();
              },
              style: const TextStyle(fontSize: 14, color: Colors.black45),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.only(left: 10.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 0.5),
                  ),
                  prefixIcon: InkWell(
                    onTap: () {
                      searchText = searchController.text;
                      _getSales();
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(0.5),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5)),
                          color:
                          Theme.of(context).colorScheme.tertiaryContainer,
                          border: Border.all(
                              width: 0.1,
                              color: Theme.of(context).dividerColor)),
                      child: Icon(
                        Icons.search_outlined,
                        color: Theme.of(context).indicatorColor,
                      ),
                    ),
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      searchController.text = "";
                      searchText = "";
                      _getSales();
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      padding: const EdgeInsets.all(0.5),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          color:
                          Theme.of(context).colorScheme.tertiaryContainer,
                          border: Border.all(
                              width: 0.1,
                              color: Theme.of(context).dividerColor)),
                      child: Icon(
                        Icons.clear,
                        color: Theme.of(context).indicatorColor,
                      ),
                    ),
                  ),
                  hintText: "Search by Customer Name",
                  hintStyle:
                  const TextStyle(fontSize: 13, color: Colors.black45)),
            ),
          ),
        ),
      ],
    );
  }

  Widget showSalesList() {
    if (bookingPayments == null || bookingPayments!.isEmpty) {
      return const NoDataWidget();
    }
    return Container(
      constraints: const BoxConstraints.expand(),
      child: customerListWidget(),
    );
  }

  Widget customerListWidget() {
    return Column(
      children: [
        Expanded(
          child: Container(
            constraints: const BoxConstraints.expand(),
            child: showSales(bookingPayments!),
          ),
        ),
        getPageController()
      ],
    );
  }

  Widget getPageController() {
    if (bookingPaymentResponse == null ||
        bookingPaymentResponse?.currentPage == null) {
      return Container();
    }

    return Card(
      child: MyPaginationWidget(
        onPageSelected: (page) {
          setState(() {
            pageNo = page;
            _getSales();
          });
        },
        perPage: bookingPaymentResponse!.perPage!,
        currentPage: bookingPaymentResponse!.currentPage!,
        lastPage: bookingPaymentResponse!.lastPage!,
        totalCount: bookingPaymentResponse!.totalRecords!,
        totalPages: bookingPaymentResponse!.lastPage!,
      ),
    );
  }

  Widget showSales(List<BookingPayments> salesList) {
    return Card(child: CustomScrollController(child: tableWidget(salesList)));
  }

  Widget tableWidget(List<BookingPayments> filteredLists) {
    return DataTable(
      horizontalMargin: 10,
      dividerThickness: 0.0,
      showCheckboxColumn: false,
      headingRowColor: MaterialStateColor.resolveWith(
              (states) => Theme.of(context).colorScheme.tertiaryContainer),
      headingTextStyle: Theme.of(context).textTheme.subtitle1,
      columns: <DataColumn>[
        DataColumn(
          label: Text('#', style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataColumn(
          label: Text('ID', style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataColumn(
          label: Text('Member', style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataColumn(
          label: Text('Cashier', style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataColumn(
          label:
          Text('Date Time', style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataColumn(
          numeric: true,
          label: Text('Total Amount',
              style: Theme.of(context).textTheme.bodyMedium),
        ),
        DataColumn(
          numeric: true,
          label: Text('Available Amount',
              style: Theme.of(context).textTheme.bodyMedium),
        ),
        // DataColumn(
        //   numeric: true,
        //   label: Text('Total Items',
        //       style: Theme.of(context).textTheme.bodyMedium),
        // ),

        DataColumn(
          numeric: true,
          label: (widget.isTopUpBookingPayment ?? false)
              ? Container(
            margin: const EdgeInsets.only(right: 30),
            child: Text('Top-Up',
                style: Theme.of(context).textTheme.bodyMedium),
          )
              : SizedBox(),
        ),
      ],
      rows: getDtaRows(filteredLists),
    );
  }

  List<DataRow> getDtaRows(List<BookingPayments> filteredLists) {
    List<DataRow> dataRows = List.empty(growable: true);
    int index = 0;
    for (BookingPayments sale in filteredLists) {
      index += 1;
      Color color =
      (index % 2 == 0) ? getWhiteColor(context) : getWhiteColor(context);

      if (selected != null && sale.id == selected?.id) {
        color = Theme.of(context).colorScheme.onPrimaryContainer;
      }

      dataRows.add(
        DataRow(
          color: MaterialStateColor.resolveWith((states) {
            return viewModel.getIsActive(sale)
                ? color
                : (selected == sale
                ? Colors.grey.shade100
                : Colors.grey.shade50);
          }),
          onSelectChanged: (value) async {
            selected = sale;

            setState(() {
              if (widget.mCompanyConfigurationResponse != null) {
                if ((selected?.status ?? "") == "ACTIVE") {
                  if (partially) {
                    widget.onBookingPaymentSelected(sale);
                  } else {
                    if ((selected?.availableAmount ?? 0.0) <=
                        (widget.dueAmount ?? 0.0)) {
                      widget.onBookingPaymentSelected(sale);
                    } else {
                      showToast("Total due amount is below than booking available amount", context);
                    }
                  }
                } else {
                  showToast("This selected Booking Payment not active.", context);
                }
              } else {
                widget.onBookingPaymentSelected(sale);
              }
            });
          },
          cells: <DataCell>[
            DataCell(Align(
              alignment: Alignment.centerLeft,
              child: Text("$index.",
                  style: Theme.of(context).textTheme.bodyMedium),
            )),
            DataCell(Align(
              alignment: Alignment.center,
              child: Text("${sale.id}",
                  style: Theme.of(context).textTheme.bodyMedium),
            )),
            DataCell(
              Align(
                alignment: Alignment.centerLeft,
                child: Text(viewModel.getCustomerName(sale),
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
            DataCell(
              Align(
                alignment: Alignment.centerLeft,
                child: Text(viewModel.getCashier(sale),
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
            DataCell(
              Align(
                alignment: Alignment.centerLeft,
                child: Text(viewModel.getDateTime(sale),
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
            DataCell(
              Text(viewModel.getTotalAmount(sale),
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
            DataCell(Container(
              margin: const EdgeInsets.only(right: 15),
              child: Text(viewModel.getAvailableAmount(sale),
                  style: Theme.of(context).textTheme.bodyMedium),
            )),
            // DataCell(
            //   Text(viewModel.getTotalItems(sale),
            //       style: Theme.of(context).textTheme.bodyMedium),
            // ),
            DataCell(
              (viewModel.getIsActive(sale) &&
                  (widget.isTopUpBookingPayment ?? false))
                  ? Container(
                margin: const EdgeInsets.only(right: 15),
                child: MyOutlineButton(
                    text: "Top-up",
                    onClick: () {
                      showDialog(
                          context: context,
                          builder: (context) => BookingPaymentDialog(
                            selectedBookingPayment: sale,
                            onBookingPaymentUpdated:
                                (PaymentTypes selected,
                                double topUpAmount) async {
                              BookingTopUpRequest
                              mBookingTopUpRequest =
                              BookingTopUpRequest(
                                  selectedBookingPaymentId:
                                  sale.id,
                                  paymentTypeId: selected.id,
                                  amount: topUpAmount,
                                  happenedAt:
                                  dateTimeYmdHis24Hour());
                              MyLogUtils.logDebug(
                                  "onBookingPaymentUpdated exception ${jsonEncode(mBookingTopUpRequest)} ");
                              BookingPaymentsTopUpResponse
                              bookingPaymentsTopUpResponse =
                              await viewModel
                                  .bookingPaymentsRefund(
                                  mBookingTopUpRequest);
                              if (bookingPaymentsTopUpResponse
                                  .bookingPaymentTopUp !=
                                  null) {
                                _getSales();
                              }
                            },
                          ));
                    }),
              )
                  : SizedBox(),
            ),
          ],
        ),
      );
    }
    return dataRows;
  }
}
