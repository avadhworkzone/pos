import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jakel_base/printer/widgets/printer_configuration_widget.dart';

import 'package:jakel_base/restapi/me/model/CurrentUserResponse.dart';
import 'package:jakel_base/serialportdevices/widgets/serial_port_device_config_widget.dart';
import 'package:jakel_pos/modules/common/UserViewModel.dart';
import '../../saleshistory/ui/widgets/history/manager_authorization_widget.dart';
import '../../utils/logout_utils.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginAppBar extends StatefulWidget {
  const LoginAppBar({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginAppBarState();
  }
}

class _LoginAppBarState extends State<LoginAppBar> {
  var userViewModel = UserViewModel();
  CurrentUserResponse? currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: kElevationToShadow[1],
        color: Theme.of(context).primaryColor,
      ),
      height: double.infinity,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              flex: 3,
              child: Center(
                child: Text(
                  tr('title'),
                  style: const TextStyle(color: Colors.white),
                ),
              )),
          _profilePopUp()
        ],
      ),
    );
  }

  _logout(bool clearConfiguration) async {
    await logout(clearConfiguration, context);
    if (!mounted) return;
    await routeToSplash(context);
  }

  Widget _profilePopUp() {
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 1,
          child: Text(
            'Logout & Clear configuration',
          ),
        ),
        const PopupMenuItem(
          value: 2,
          child: Text(
            'Exit',
          ),
        ),
        const PopupMenuItem(
          value: 5,
          child: Text(
            'Printer Settings',
          ),
        ),
        const PopupMenuItem(
          value: 6,
          child: Text(
            'Config Serial Port Devices',
          ),
        ),
      ],
      icon: const Icon(
        Icons.keyboard_arrow_down_outlined,
        size: 20.0,
        color: Colors.white,
      ),
      offset: const Offset(0, 40),
      tooltip: "Menu",
      onSelected: (value) {
        setState(() async {
          if (value == 1) {
            // Logout & Clear Configuration
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return ManagerAuthorizationWidget(
                  onSuccess: () {
                    _logout(true);
                  },
                );
              },
            );
          }
          if (value == 2) {
            // Exit the application
            exit(0);
          }
          if (value == 5) {
            _searchPrinterDialog();
          }
          if (value == 6) {
            _searchSerialPortDevicesDialog();
          }
        });
      },
    );
  }

  Future<void> _searchPrinterDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const PrinterConfigurationWidget();
      },
    );
  }

  Future<void> _searchSerialPortDevicesDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const SerialPortDeviceConfigWidget();
      },
    );
  }
}
