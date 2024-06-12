import 'package:flutter/material.dart';
import 'package:internal_app_store_manager/routes/route_constants.dart';
import 'package:internal_base/common/alert/app_alert.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/message_constants.dart';
import 'package:internal_base/common/utils/network_utils.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_login/bloc/store_manager_login_screen_bloc.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_login/bloc/store_manager_login_screen_event.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_login/bloc/store_manager_login_screen_state.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_login/repo/store_manager_login_screen_request.dart';
import 'package:internal_base/data/remote/web_constants.dart';

class StoreManagerLoginScreenModel {
  final BuildContext cBuildContext;
  late TextEditingController mUserNameTextEditingController;
  late TextEditingController mPasswordTextEditingController;
  late CallbackModel mCallbackModel;

  StoreManagerLoginScreenModel(this.cBuildContext){
    mUserNameTextEditingController = TextEditingController();
    mPasswordTextEditingController = TextEditingController();
    mCallbackModel = CallbackModel();
  }

  showDashboardPage() async {
    Navigator.pushReplacementNamed(
        cBuildContext, RouteConstants.rStoreManagerHomeScreenWidget,
        arguments: mCallbackModel);
  }

  ///StoreManagerLoginScreen

  late StoreManagerLoginScreenBloc _mStoreManagerLoginScreenBloc;

  setStoreManagerLoginScreenBloc() {
    _mStoreManagerLoginScreenBloc = StoreManagerLoginScreenBloc();
  }

  getStoreManagerLoginScreenBloc() {
    return _mStoreManagerLoginScreenBloc;
  }

  Future<void> fetchStoreManagerLoginScreenUrl() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _mStoreManagerLoginScreenBloc.add(StoreManagerLoginScreenClickEvent(
            mStoreManagerLoginScreenListRequest: StoreManagerLoginScreenRequest(
                clientId: WebConstants.sStoreManagerClientId,
                clientSecret: WebConstants.sStoreManagerClientSecret,
                grantType: WebConstants.sGrantType,
                scope: WebConstants.sStoreManagerScope,
                userName: mUserNameTextEditingController.text,
                password: mPasswordTextEditingController.text)));
      } else {
        AppAlert.showSnackBar(
            cBuildContext, MessageConstants.noInternetConnection);
      }
    });
  }

  blocStoreManagerLoginScreenListener(
      BuildContext context, StoreManagerLoginScreenState state) {
    switch (state.status) {
      case StoreManagerLoginScreenStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case StoreManagerLoginScreenStatus.failed:
        AppAlert.closeDialog(context);
        AppAlert.showSnackBar(
            context, state.webResponseFailed?.statusMessage ?? "");
        break;
      case StoreManagerLoginScreenStatus.success:
        AppAlert.closeDialog(context);
        showDashboardPage();
        break;
    }
  }

}
