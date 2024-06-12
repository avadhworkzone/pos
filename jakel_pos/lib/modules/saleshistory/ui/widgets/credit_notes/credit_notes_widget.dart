import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jakel_base/restapi/creditnotedetailsbyid/model/CreditNotesListApiResponse.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/my_date_utils.dart';
import 'package:jakel_base/widgets/custom/MyPaginationWidget.dart';
import 'package:jakel_base/widgets/errorwidget/MyErrorWidget.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_base/widgets/nodatawidget/NoDataWidget.dart';
import 'package:jakel_pos/modules/creditnote/CreditNoteViewModel.dart';

class CreditNoteWidget extends StatefulWidget {
  final Function onCreditNoteSelected;
  final int? customerId;

  const CreditNoteWidget(
      {Key? key, required this.onCreditNoteSelected, this.customerId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreditNoteWidgetState();
  }
}

class _CreditNoteWidgetState extends State<CreditNoteWidget> {
  final viewModel = CreditNoteViewModel();
  final searchController = TextEditingController();
  final searchNode = FocusNode();
  int pageNo = 1;
  int perPage = 20;
  List<CreditNotes>? creditNotes;
  DateTime? fromDate, toDate;
  String? dateRangeText;
  String? filter;
  CreditNotes? selected;

  @override
  void initState() {
    super.initState();
    _getSales();
  }

  void _getSales() {
    viewModel.getCreditNotesListByCustomerId(
        pageNo, perPage, widget.customerId ?? 0, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: apiWidget(),
          )
        ],
      ),
    );
  }

  Widget apiWidget() {
    return StreamBuilder<CreditNotesListApiResponse>(
      stream: viewModel.responseSubjectCreditNotesList,
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
          if (responseData != null && responseData.creditNotes != null) {
            creditNotes = responseData.creditNotes;
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

  void onDateSelected(DateTime? fromDate, DateTime? toDate, String? title) {
    setState(() {
      MyLogUtils.logDebug("fromDate : $fromDate, toDate : $toDate");

      this.fromDate = fromDate;
      this.toDate = toDate;

      if (fromDate != null) {
        dateRangeText = dateYmd(fromDate.millisecondsSinceEpoch);
      }
      if (toDate != null) {
        dateRangeText =
            "$dateRangeText  to ${dateYmd(toDate.millisecondsSinceEpoch)}";
      }

      if (title != null) {
        dateRangeText = title;
      }
      _getSales();
    });
  }

  Widget showSalesList() {
    if (creditNotes == null || creditNotes!.isEmpty) {
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
            child: showSales(creditNotes!),
          ),
        ),
      ],
    );
  }

  Widget showSales(List<CreditNotes> salesList) {
    return Card(
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: tableWidget(salesList),
          )),
    );
  }

  Widget tableWidget(List<CreditNotes> filteredLists) {
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
          label: Text('Expiry Date',
              style: Theme.of(context).textTheme.bodyMedium),
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
      ],
      rows: getDtaRows(filteredLists),
    );
  }

  List<DataRow> getDtaRows(List<CreditNotes> filteredLists) {
    List<DataRow> dataRows = List.empty(growable: true);
    int index = 0;
    for (CreditNotes sale in filteredLists) {
      index += 1;
      Color color =
          (index % 2 == 0) ? getWhiteColor(context) : getWhiteColor(context);

      if (selected != null && sale.id == selected?.id) {
        color = Theme.of(context).colorScheme.onPrimaryContainer;
      }

      dataRows.add(
        DataRow(
          color: MaterialStateColor.resolveWith((states) {
            return color;
          }),
          onSelectChanged: (value) async {
            setState(() {
              selected = sale;
              widget.onCreditNoteSelected(sale);
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
                child: Text(viewModel.getExpiryDateTime(sale),
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
            DataCell(
              Text(viewModel.getTotalAmount(sale),
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
            DataCell(
              Text(viewModel.getAvailableAmount(sale),
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
          ],
        ),
      );
    }
    return dataRows;
  }
}
