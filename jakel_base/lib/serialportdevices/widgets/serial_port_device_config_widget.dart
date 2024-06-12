import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:jakel_base/serialportdevices/SerialPortViewModel.dart';
import 'package:jakel_base/serialportdevices/model/MySerialPortDevices.dart';
import 'package:jakel_base/serialportdevices/widgets/serial_port_device_row_widget.dart';

import '../../widgets/inkwell/my_ink_well_widget.dart';

class SerialPortDeviceConfigWidget extends StatefulWidget {
  const SerialPortDeviceConfigWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SerialPortDeviceConfigState();
  }
}

class _SerialPortDeviceConfigState extends State<SerialPortDeviceConfigWidget> {
  final viewModel = SerialPortViewModel();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        constraints: const BoxConstraints.expand(),
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            getHeader(),
            const Divider(),
            SizedBox(
              height: 250,
              child: Row(
                children: [
                  Expanded(
                    child: displayDeviceWidget(),
                  ),
                  Expanded(
                    child: mayBankTerminalWidget(),
                  )
                ],
              ),
            ),
            const Divider(),
            const Text(
              'Search Serial Port Devices',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            Expanded(
              child: getAllSerialPortDevices(),
            )
          ],
        ),
      ),
    );
  }

  Widget mayBankTerminalWidget() {
    return Column(
      children: [
        const Text(
          'MayBank Payment Terminal Device Detail',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(child: getMayBankTerminalDevice()),
        const SizedBox(
          height: 5,
        ),
        MyInkWellWidget(
            child: const Text("Echo Test"),
            onTap: () {
              //sendEnquiryUsingWin32();
              viewModel.echoTextMayBankTerminal();
            })
      ],
    );
  }

  Column displayDeviceWidget() {
    return Column(
      children: [
        const Text(
          'Display Device Detail',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(child: getDisplayDevice())
      ],
    );
  }

  Widget getDisplayDevice() {
    return FutureBuilder(
        future: viewModel.getMyDisplayDevice(),
        builder: (BuildContext context, AsyncSnapshot<SerialPort?> snapshot) {
          if (snapshot.hasError) {
            return Text(
              "Failed to search serial port devices",
              style: Theme.of(context).textTheme.bodyLarge,
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return _deviceRowWidget(snapshot.data!, deviceTypeDisplay);
            }
            return Text(
              "Display device is not configured",
              style: Theme.of(context).textTheme.bodyLarge,
            );
          }
          return const Text("Loading ...");
        });
  }

  Widget _deviceRowWidget(SerialPort port, String deviceType) {
    return SerialPortDeviceRowWidget(
        deviceType: deviceType,
        serialPort: port,
        saveDevice: _saveSerialPortDevices);
  }

  Widget getMayBankTerminalDevice() {
    return FutureBuilder(
        future: viewModel.getMyPaymentTerminalDevice(),
        builder: (BuildContext context, AsyncSnapshot<SerialPort?> snapshot) {
          if (snapshot.hasError) {
            return Text(
              "Failed to search serial port devices",
              style: Theme.of(context).textTheme.bodyLarge,
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return _deviceRowWidget(
                  snapshot.data!, deviceTypePaymentTerminal);
            }
            return Text(
              "May bank terminal device is not configured.",
              style: Theme.of(context).textTheme.bodyLarge,
            );
          }
          return const Text("Loading ...");
        });
  }

  Widget getAllSerialPortDevices() {
    return FutureBuilder(
        future: viewModel.getAllSerialPorts(),
        builder:
            (BuildContext context, AsyncSnapshot<List<SerialPort>> snapshot) {
          if (snapshot.hasError) {
            return Text(
              "Failed to search serial port devices",
              style: Theme.of(context).textTheme.bodyLarge,
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return getRootWidget(snapshot.data!);
            }
            return Text(
              "No devices found",
              style: Theme.of(context).textTheme.bodyLarge,
            );
          }
          return const Text("Loading ...");
        });
  }

  Widget getRootWidget(List<SerialPort> allPrinters) {
    return ListView.builder(
        itemCount: allPrinters.length,
        itemBuilder: (BuildContext context, int index) {
          return _deviceRowWidget(allPrinters[index], deviceTypeDisplay);
        });
  }

  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Serial Port Device Configuration',
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

  Future<void> _saveSerialPortDevices(
      String deviceType, SerialPort port) async {
    await viewModel.saveDevice(deviceType, port);
    setState(() {});
  }
}
