import 'package:flutter/material.dart';
import 'package:jakel_base/database/printer/model/MyPrinter.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';
import 'package:printing/printing.dart';

import '../../widgets/inkwell/my_ink_well_widget.dart';
import '../PrinterViewModel.dart';
import '../types/test_printing.dart';

class PrinterConfigurationWidget extends StatefulWidget {
  const PrinterConfigurationWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PrinterConfigurationWidgetState();
  }
}

class _PrinterConfigurationWidgetState
    extends State<PrinterConfigurationWidget> {
  final viewModel = PrinterViewModel();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        height: 600,
        width: 600,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            getHeader(),
            const Divider(),
            const Text(
              'Primary Printer',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            getPrimaryPrinter(),
            const Divider(),
            const Text(
              'Search Printers List',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            Expanded(
              child: getPrinters(),
            )
          ],
        ),
      ),
    );
  }

  Widget getPrimaryPrinter() {
    return FutureBuilder(
        future: viewModel.getPrimaryPrinter(),
        builder: (BuildContext context, AsyncSnapshot<MyPrinter?> snapshot) {
          if (snapshot.hasError) {
            return Text(
              "Failed to search printers",
              style: Theme.of(context).textTheme.bodyLarge,
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return _printerRow(
                  viewModel.getPrinterFromMyPrinter(snapshot.data!));
            }
            return Text(
              "No Primary printer found",
              style: Theme.of(context).textTheme.bodyLarge,
            );
          }
          return const Text("Loading ...");
        });
  }

  Widget getPrinters() {
    return FutureBuilder(
        future: viewModel.findPrinters(),
        builder: (BuildContext context, AsyncSnapshot<List<Printer>> snapshot) {
          if (snapshot.hasError) {
            return Text(
              "Failed to search printers",
              style: Theme.of(context).textTheme.bodyLarge,
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return getRootWidget(snapshot.data!);
            }
            return Text(
              "No printers found",
              style: Theme.of(context).textTheme.bodyLarge,
            );
          }
          return const Text("Loading ...");
        });
  }

  Widget getRootWidget(List<Printer> allPrinters) {
    return ListView.builder(
        itemCount: allPrinters.length,
        itemBuilder: (BuildContext context, int index) {
          return _printerRow(allPrinters[index]);
        });
  }

  Widget _printerRow(Printer printer) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      child: MyDataContainerWidget(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          Text('Url  : ${printer.url}'),
          const SizedBox(
            height: 5,
          ),
          Text('Name : ${printer.name}'),
          const SizedBox(
            height: 5,
          ),
          Text('Model : ${printer.model}'),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              InkWell(
                  child: const Icon(
                    Icons.open_in_browser,
                    size: 20,
                  ),
                  onTap: () {
                    openCashDrawer(printer);
                  }),
              const SizedBox(
                width: 40,
              ),
              InkWell(
                  child: const Icon(
                    Icons.print,
                    size: 20,
                  ),
                  onTap: () {
                    printPdfDirect(printer);
                  }),
              const SizedBox(
                width: 40,
              ),
              InkWell(
                  child: const Icon(
                    Icons.save,
                    size: 20,
                  ),
                  onTap: () {
                    _savePrinter(printer);
                  }),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      )),
    );
  }

  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Printer Configuration',
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

  Future<void> _savePrinter(Printer printer) async {
    await viewModel.savePrimaryPrinter(printer);
    setState(() {});
  }
}
