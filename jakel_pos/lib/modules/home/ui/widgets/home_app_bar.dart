import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jakel_base/printer/types/print_refund_booking_payment.dart';
import 'package:jakel_base/printer/types/print_refund_credit_notes.dart';
import 'package:jakel_base/printer/types/test_printing.dart';
import 'package:jakel_base/printer/widgets/printer_configuration_widget.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsRefundResponse.dart';
import 'package:jakel_base/restapi/creditnotedetailsbyid/model/CreditNotesRefundResponce.dart';
import 'package:jakel_base/restapi/managers/model/StoreManagersResponse.dart';
import 'package:jakel_base/restapi/me/model/CurrentUserResponse.dart';
import 'package:jakel_base/serialportdevices/service/extended_display_service.dart';
import 'package:jakel_base/serialportdevices/widgets/serial_port_device_config_widget.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/my_unique_id.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:jakel_base/widgets/clock/my_clock_widget.dart';
import 'package:jakel_base/widgets/custom/my_vertical_divider.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_pos/modules/cashmovement/ui/cash_in_usage_widget.dart';
import 'package:jakel_pos/modules/home/ui/refund_manager_widget.dart';
import 'package:jakel_pos/modules/keyboardshortcuts/refund_keyboard_shortcuts.dart';
import 'package:jakel_pos/modules/refundCreditNote/ui/widgets/dialog/refund_credit_note_dialog.dart';
import 'package:jakel_pos/modules/keyboardshortcuts/cash_out_keyboard_shortcut.dart';
import 'package:jakel_pos/modules/cashmovement/ui/cash_out_usage_widget.dart';
import 'package:jakel_pos/modules/common/UserViewModel.dart';
import 'package:jakel_pos/modules/home/ui/home_inherited_widget.dart';
import 'package:jakel_pos/modules/keyboardshortcuts/open_cash_drawer_keyboard_shortcut.dart';
import 'package:jakel_pos/modules/offline/synctoserver/ui/offline_syncing_widget.dart';
import 'package:jakel_pos/modules/pettycash/ui/save_pettycash_usage_widget.dart';
import 'package:jakel_pos/modules/refundBookingPayment/ui/widgets/dialog/refund_booking_payment_dialog.dart';
import 'package:jakel_pos/modules/takebreak/ui/take_break_widget.dart';
import '../../../app_locator.dart';
import '../../../saleshistory/ui/widgets/history/manager_authorization_widget.dart';
import 'package:jakel_pos/routing/route_names.dart';

import '../../../utils/logout_utils.dart';
import '../../../keyboardshortcuts/cash_in_keyboard_shortcuts.dart';

class HomeAppBar extends StatefulWidget {
  final Function downloadData;

  const HomeAppBar({
    Key? key,
    required this.downloadData,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeAppBarState();
  }
}

class _HomeAppBarState extends State<HomeAppBar> {
  var userViewModel = UserViewModel();

  CurrentUserResponse? currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: kElevationToShadow[1],
        color: Colors.grey[100],
      ),
      height: double.infinity,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child:   SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child:getLeftWidget()) ,
          ),
          Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 7,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const OfflineSyncingWidget(
                            downloadData: true,
                          ),
                          SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  CashInKeyboardShortcuts(
                                      child: MyInkWellWidget(
                                        child: Text(
                                          "Cash In",
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                        onTap: () {
                                          _cashInUsage();
                                        },
                                      ),
                                      onAction: () {
                                        _cashInUsage();
                                      }),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  MyInkWellWidget(
                                      child: CashOutKeyboardShortcut(
                                          onAction: _cashOutUsage,
                                          child: Text(
                                            "Cash Out",
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          )),
                                      onTap: () {
                                        _cashOutUsage();
                                      }),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  RefundKeyboardShortcuts(
                                      child: MyInkWellWidget(
                                        child: Text(
                                          "Refund",
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                        onTap: () {
                                          _refundCashUsageDialog();
                                        },
                                      ),
                                      onAction: () {
                                        _refundCashUsageDialog();
                                      }),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  MyInkWellWidget(
                                      child: Icon(
                                        Icons.cloud_download_outlined,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onTap: () {
                                        widget.downloadData();
                                      }),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  MyInkWellWidget(
                                      child: Icon(
                                        Icons.account_tree_outlined,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, LocalCountersInfoRoute,
                                            arguments: false);
                                      }),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  OpenCashDrawerKeyboardShortcut(
                                      child: Container(),
                                      onAction: () {
                                        BaseViewModel().openCashDrawer();
                                      })
                                ],
                              ))
                        ],
                      )),
                  const MyVerticalDivider(
                    height: 60,
                  ),
                  Expanded(
                      flex: 2,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: getCounterStoreNameWidget(),
                      )),
                  _profilePopUp()
                ],
              ))
        ],
      ),
    );
  }

  Widget getCashierName() {
    return FutureBuilder(
        future: userViewModel.getCurrentUser(),
        builder: (BuildContext context,
            AsyncSnapshot<CurrentUserResponse?> snapshot) {
          if (snapshot.hasData) {
            currentUser = snapshot.data;
            return Text(
              '${userViewModel.getDisplayName(currentUser)}(${userViewModel.getStaffId(currentUser)})',
              style: Theme.of(context).textTheme.caption,
              overflow: TextOverflow.ellipsis,
            );
          }
          return const Text("Loading Widget");
        });
  }

  Widget getCompanyName() {
    return FutureBuilder(
        future: userViewModel.getCurrentUser(),
        builder: (BuildContext context,
            AsyncSnapshot<CurrentUserResponse?> snapshot) {
          if (snapshot.hasData) {
            currentUser = snapshot.data;
            return Flexible(
                child: Text(
              currentUser?.company?.name ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge,
            ));
          }
          return const Text("");
        });
  }

  Widget _profilePopUp() {
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 0,
          child: Text("Take a break"),
        ),
        const PopupMenuItem(
          value: 1,
          child: Text('Logout'),
        ),
        const PopupMenuItem(
          value: 2,
          child: Text(
            'Logout & Clear configuration',
          ),
        ),
        const PopupMenuItem(
          value: 3,
          child: Text(
            'Exit',
          ),
        ),
        const PopupMenuItem(
          value: 4,
          child: Text(
            'Test Manual Print',
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
        const PopupMenuItem(
          value: 7,
          child: Text(
            'Create Floating Display 800 x 600',
          ),
        ),
      ],
      icon: Icon(
        Icons.keyboard_arrow_down_outlined,
        size: 20.0,
        color: Theme.of(context).primaryColor,
      ),
      offset: const Offset(0, 40),
      tooltip: "Menu",
      onSelected: (value) {
        setState(() async {
          if (value == 0) {
            _takeBreakDialog();
          }
          if (value == 1) {
            // Logout
            _logout(false);
          }
          if (value == 2) {
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
          if (value == 3) {
            exit(0);
          }
          if (value == 4) {
            printPdf();
          }
          if (value == 5) {
            _searchPrinterDialog();
          }
          if (value == 6) {
            _searchSerialPortDevicesDialog();
          }
          if (value == 7) {
            _createNewFloatingDisplayWindow();
          }
        });
      },
    );
  }

  Widget getLeftWidget() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(const SizedBox(
      width: 10,
    ));

    //Menu item
    widgets.add(Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getCompanyName(),
        const MyClockWidget(),
        getUniqueDeviceIdWidget()
      ],
    ));

    widgets.add(const SizedBox(
      width: 10,
    ));

    return Row(children: widgets);
  }

  Widget getCounterStoreNameWidget() {
    return FutureBuilder(
        future: userViewModel.getCurrentUser(),
        builder: (BuildContext context,
            AsyncSnapshot<CurrentUserResponse?> snapshot) {
          if (snapshot.hasError) {
            return Text(
              HomeInheritedWidget.of(context).object.menuItem.text,
              style: Theme.of(context).textTheme.bodyLarge,
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    snapshot.data?.counter?.name ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Text(
                    snapshot.data?.store?.name ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Text(
                    snapshot.data?.store?.city ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  getCashierName()
                ],
              );
            }
            return Text(
              HomeInheritedWidget.of(context).object.menuItem.text,
              style: Theme.of(context).textTheme.bodyLarge,
            );
          }
          return const Text("Loading ...");
        });
  }

  Widget getUniqueDeviceIdWidget() {
    return FutureBuilder(
        future: getUniqueDeviceId(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.hasError) {
            MyLogUtils.logDebug("snapshot.hasError : ${snapshot.hasError}");
            return Container();
          }
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return SelectableText(
                  'Device Id: ${snapshot.data?.toString() ?? ''}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption);
            }
            return Container();
          }
          return const Text("Loading ...");
        });
  }

  _logout(bool clearConfiguration) async {
    await logout(clearConfiguration, context);
    if (!mounted) return;
    await routeToSplash(context);
  }

  Future<void> _showPettyCashUsage() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const SavePettyCashUsageWidget();
      },
    );
  }

  Future<void> _cashInUsage() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const CashInUsageWidget();
      },
    );
  }

  Future<void> _cashOutUsage() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const CashOutUsageWidget();
      },
    );
  }

  Future<void> _takeBreakDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Container(
          constraints: const BoxConstraints.expand(),
          child: const TakeBreakWidget(),
        );
      },
    );
  }

  _refundCashUsageDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return RefundManagerWidget(
            onSuccess: (String sRefundType) {
              switch (sRefundType) {
                case "Credit Note":
                  Navigator.pop(context);
                  _refundCreditNoteAsCashDialog();
                  break;
                case "Booking Payment":
                  Navigator.pop(context);
                  _refundBookingPaymentAsCashDialog();
                  break;
              }
            },
          );
        });
  }

  Future<void> _refundCreditNoteAsCashDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return RefundCreditNoteDialog(
            onSuccess: (CreditNoteRefund creditNote, String sStoreManagersId) {
          showToast("Credit Notes Refund Successful.", context);
          Navigator.of(context).pop();
          Future.delayed(const Duration(milliseconds: 500), () async {
            await printRefundCreditNotes("Credit Notes Refund In CASH",
                creditNote, sStoreManagersId, false);
          });
        });
      },
    );
  }

  Future<void> _refundBookingPaymentAsCashDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return RefundBookingPaymentDialog(
            onSuccess: (BookingPaymentRefund bookingPaymentRefund) {
          Navigator.of(context).pop();
          Future.delayed(const Duration(milliseconds: 500), () async {
            await printRefundBookingPayment(
                "Booking Payment Refund In CASH", bookingPaymentRefund, false);
          });
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

  _createNewFloatingDisplayWindow() async {
    var extendedDisplayService = appLocator.get<ExtendedDisplayService>();
    await extendedDisplayService.createNewWindow();
  }
}
