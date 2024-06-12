import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:internal_app_promoter/routes/route_constants.dart';
import 'package:internal_base/common/alert/app_alert.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/message_constants.dart';
import 'package:internal_base/common/utils/network_utils.dart';
import 'package:internal_base/data/all_bloc/promoter/promoter_login/bloc/promoter_login_screen_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/promoter_login/bloc/promoter_login_screen_event.dart';
import 'package:internal_base/data/all_bloc/promoter/promoter_login/bloc/promoter_login_screen_state.dart';
import 'package:internal_base/data/all_bloc/promoter/promoter_login/repo/promoter_login_screen_request.dart';
import 'package:internal_base/data/remote/web_constants.dart';

class PromoterLoginScreenModel {
  final BuildContext cBuildContext;
  late TextEditingController mUserNameTextEditingController;
  late TextEditingController mPasswordTextEditingController;
  late CallbackModel mCallbackModel;

  PromoterLoginScreenModel(this.cBuildContext) {
    mCallbackModel = CallbackModel();

    mUserNameTextEditingController = TextEditingController();
    mPasswordTextEditingController = TextEditingController();
  }

  showDashboardPage() async {
    Navigator.pushReplacementNamed(cBuildContext,
        RouteConstants.rPromoterHomeViewScreenWidget,
        arguments: mCallbackModel);
  }

  ///PromoterLoginScreen

  late PromoterLoginScreenBloc _mPromoterLoginScreenBloc;

  setPromoterLoginScreenBloc() {
    _mPromoterLoginScreenBloc = PromoterLoginScreenBloc();
  }

  getPromoterLoginScreenBloc() {
    return _mPromoterLoginScreenBloc;
  }

  Future<void> fetchPromoterLoginScreenUrl() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _mPromoterLoginScreenBloc.add(PromoterLoginScreenClickEvent(
            mPromoterLoginScreenListRequest: PromoterLoginScreenRequest(
                clientId: WebConstants.sClientId,
                clientSecret: WebConstants.sClientSecret,
                grantType: WebConstants.sGrantType,
                scope: WebConstants.sPromoterScope,
                userName: mUserNameTextEditingController.text,
                password: mPasswordTextEditingController.text)));
      } else {
        AppAlert.showSnackBar(
            cBuildContext, MessageConstants.noInternetConnection);
      }
    });
  }

  blocPromoterLoginScreenListener(
      BuildContext context, PromoterLoginScreenState state) {
    switch (state.status) {
      case PromoterLoginScreenStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case PromoterLoginScreenStatus.failed:
        AppAlert.closeDialog(context);
        AppAlert.showSnackBar(
            context, state.webResponseFailed?.statusMessage ?? "");
        break;
      case PromoterLoginScreenStatus.success:
        AppAlert.closeDialog(context);
        showDashboardPage();
        break;
    }
  }

}
