import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jakel_base/printer/types/test_printing.dart';
import 'package:jakel_base/printer/widgets/printer_configuration_widget.dart';
import 'package:jakel_base/restapi/me/model/CurrentUserResponse.dart';
import 'package:jakel_base/serialportdevices/widgets/serial_port_device_config_widget.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/widgets/custom/my_vertical_divider.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_pos/modules/cashmovement/ui/cash_in_usage_widget.dart';
import 'package:jakel_pos/modules/cashmovement/ui/cash_out_usage_widget.dart';
import 'package:jakel_pos/modules/common/UserViewModel.dart';
import 'package:jakel_pos/modules/home/ui/home_inherited_widget.dart';
import 'package:jakel_pos/modules/offline/synctoserver/ui/offline_syncing_widget.dart';
import 'package:jakel_pos/modules/pettycash/ui/save_pettycash_usage_widget.dart';
import 'package:jakel_pos/modules/takebreak/ui/take_break_widget.dart';
import 'package:jakel_pos/routing/route_names.dart';

import '../../../utils/logout_utils.dart';

class LocalCountersAppBar extends StatefulWidget {
  final bool isAfterShiftClose;
  final Function refresh;

  const LocalCountersAppBar({
    Key? key,
    required this.isAfterShiftClose,
    required this.refresh,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LocalCountersAppBarState();
  }
}

class _LocalCountersAppBarState extends State<LocalCountersAppBar> {
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
        children: [
          BackButton(
              color: getWhiteColor(context),
              onPressed: () {
                Navigator.pop(context);
              }),
          Expanded(
              child: Text(
            "Counter Information",
            style: TextStyle(
                color: getWhiteColor(context),
                fontSize: 15,
                fontWeight: FontWeight.w500),
          )),
          InkWell(
            child: const Icon(
              Icons.refresh,
              size: 30,
              color: Colors.white,
            ),
            onTap: () {
              widget.refresh();
            },
          ),
          const OfflineSyncingWidget(
            downloadData: false,
          )
        ],
      ),
    );
  }
}
