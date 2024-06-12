import 'package:flutter/material.dart';
import 'package:internal_app_warehose_manager/routes/route_constants.dart';
import 'package:internal_base/common/alert/app_alert.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/message_constants.dart';
import 'package:internal_base/common/utils/network_utils.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_login/bloc/warehouse_manager_login_screen_bloc.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_login/bloc/warehouse_manager_login_screen_event.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_login/bloc/warehouse_manager_login_screen_state.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_login/repo/warehouse_manager_login_screen_request.dart';
import 'package:internal_base/data/remote/web_constants.dart';

class WarehouseManagerLoginScreenModel {
  final BuildContext cBuildContext;
  late CallbackModel mCallbackModel;
  late TextEditingController mUserNameTextEditingController;
  late TextEditingController mPasswordTextEditingController;

  WarehouseManagerLoginScreenModel(this.cBuildContext){

    mCallbackModel = CallbackModel();

    mUserNameTextEditingController = TextEditingController();
    mPasswordTextEditingController = TextEditingController();
  }


  showDashboardPage() async {
    Navigator.pushReplacementNamed(
        cBuildContext, RouteConstants.rWarehouseManagerHomeViewScreenWidget,
        arguments: mCallbackModel);
  }

  ///WarehouseManagerLoginScreen

  late WarehouseManagerLoginScreenBloc _mWarehouseManagerLoginScreenBloc;

  setWarehouseManagerLoginScreenBloc() {
    _mWarehouseManagerLoginScreenBloc = WarehouseManagerLoginScreenBloc();
  }

  getWarehouseManagerLoginScreenBloc() {
    return _mWarehouseManagerLoginScreenBloc;
  }

  Future<void> fetchWarehouseManagerLoginScreenUrl() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _mWarehouseManagerLoginScreenBloc.add(WarehouseManagerLoginScreenClickEvent(
            mWarehouseManagerLoginScreenListRequest: WarehouseManagerLoginScreenRequest(
                clientId: WebConstants.sWarehouseManagerClientId,
                clientSecret: WebConstants.sWarehouseManagerClientSecret,
                grantType: WebConstants.sGrantType,
                scope: WebConstants.sWarehouseManagerScope,
                userName: mUserNameTextEditingController.text,
                password: mPasswordTextEditingController.text)));
      } else {
        AppAlert.showSnackBar(
            cBuildContext, MessageConstants.noInternetConnection);
      }
    });
  }

  blocWarehouseManagerLoginScreenListener(
      BuildContext context, WarehouseManagerLoginScreenState state) {
    switch (state.status) {
      case WarehouseManagerLoginScreenStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case WarehouseManagerLoginScreenStatus.failed:
        AppAlert.closeDialog(context);
        AppAlert.showSnackBar(
            context, state.webResponseFailed?.statusMessage ?? "");
        break;
      case WarehouseManagerLoginScreenStatus.success:
        AppAlert.closeDialog(context);
        showDashboardPage();
        break;
    }
  }
}
