import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';

import '../../widgets/custom/MyDataContainerWidget.dart';
import '../SerialPortViewModel.dart';
import '../model/MySerialPortDevices.dart';

class SerialPortDeviceRowWidget extends StatefulWidget {
  final SerialPort serialPort;
  final String deviceType;
  final Function saveDevice;

  const SerialPortDeviceRowWidget(
      {Key? key,
      required this.serialPort,
      required this.saveDevice,
      required this.deviceType})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SerialPortDeviceRowWidgetState();
  }
}

class _SerialPortDeviceRowWidgetState extends State<SerialPortDeviceRowWidget> {
  String writeResult = "";
  final viewModel = SerialPortViewModel();

  @override
  Widget build(BuildContext context) {
    return _deviceRowWidget(widget.serialPort);
  }

  Widget _deviceRowWidget(SerialPort port) {
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
          Text('Name  : ${port.name} , Address : ${port.address}'),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                  child: const Text(
                    "Save As MayBank Terminal",
                    style: TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                        color: Colors.blueGrey),
                  ),
                  onTap: () {
                    widget.saveDevice(deviceTypePaymentTerminal, port);
                  }),
              const SizedBox(
                width: 5,
              ),
              InkWell(
                  child: const Text(
                    "Save As Display Device",
                    style: TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                        color: Colors.blueGrey),
                  ),
                  onTap: () {
                    widget.saveDevice(deviceTypeDisplay, port);
                  }),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  child: SizedBox(
                height: 25,
                child: MyTextFieldWidget(
                    controller: TextEditingController(),
                    node: FocusNode(),
                    onSubmitted: (value) async {
                      int result = -1;
                      if (widget.deviceType == deviceTypePaymentTerminal) {
                        // result = await viewModel.writeToPaymentTerminal(value);
                      } else {
                        var resultBool =
                            await viewModel.sendMessageToDisplayDevice(value);
                        if (resultBool) {
                          result = 1;
                        }
                      }

                      setState(() {
                        writeResult = '$result';
                      });
                    },
                    hint: 'Test commands commands'),
              )),
              const SizedBox(
                width: 5,
              ),
              Expanded(child: Text('Write Result: $writeResult')),
              const SizedBox(
                width: 5,
              ),
              Expanded(child: Text('Signals : ${widget.serialPort.signals}'))
            ],
          ),
        ],
      )),
    );
  }
}
