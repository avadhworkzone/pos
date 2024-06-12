import 'package:flutter/material.dart';
import 'package:internal_app_warehose_manager/constants/image_assets_constants.dart';
import 'package:internal_app_warehose_manager/routes/route_constants.dart';
import 'package:internal_base/common/alert/app_alert.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/message_constants.dart';
import 'package:rxdart/rxdart.dart';

class CustomNavigationDrawerModel {
  final BuildContext cBuildContext;
  final CallbackModel mCallbackModel;

  late List<String> listBottomBar;

  CustomNavigationDrawerModel(this.cBuildContext, this.mCallbackModel) {
    listBottomBar = [
      AppConstants.cWordConstants.wHomeText,
      AppConstants.cWordConstants.wProductListText,
      AppConstants.cWordConstants.wProfileSettingsText
    ];
  }

  getHomeAssets() {
    if (mCallbackModel.sMenuValue == AppConstants.cWordConstants.wHomeText) {
      return ImageAssetsConstants.warehouseManagerDashboardSelectHome;
    }
    return ImageAssetsConstants.warehouseManagerDashboardHome;
  }

  getProductListAssets() {
    if (mCallbackModel.sMenuValue ==
        AppConstants.cWordConstants.wProductListText) {
      return ImageAssetsConstants.warehouseManagerDashboardSelectProductList;
    }
    return ImageAssetsConstants.warehouseManagerDashboardProductList;
  }

  getProfileSettingsAssets() {
    if (mCallbackModel.sMenuValue ==
        AppConstants.cWordConstants.wProfileSettingsText) {
      return ImageAssetsConstants.warehouseManagerDashboardSelectProfile;
    }
    return ImageAssetsConstants.warehouseManagerDashboardProfile;
  }

  selectedIcon() {}

  unSelectedIcon() {}

  openNext(String sRoute, String sValue) {
    Navigator.pop(cBuildContext);
    if (sRoute.isEmpty) {
      if (sValue == AppConstants.cWordConstants.wLogoutText) {
        ///Logout
        AppAlert.showCustomDialogYesNo(
            cBuildContext,sValue, MessageConstants.wLogoutMessage);
      }
    } else if (mCallbackModel.sMenuValue != sValue) {
      if (isGet(sValue)) {
        Navigator.pushReplacementNamed(cBuildContext, sRoute,
            arguments: mCallbackModel);
      } else {
        Navigator.pushNamed(cBuildContext, sRoute, arguments: mCallbackModel);
      }
    }
  }

  isGet(String sValue) {
    for (var element in listBottomBar) {
      if (sValue == element) {
        return true;
      }
    }
    return false;
  }

  isSelectedMenu(String sValue) {
    if (mCallbackModel.sMenuValue == sValue) {
      return true;
    }
    return false;
  }
}
