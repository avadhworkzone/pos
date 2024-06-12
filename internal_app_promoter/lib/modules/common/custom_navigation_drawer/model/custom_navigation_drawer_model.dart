import 'package:flutter/material.dart';
import 'package:internal_app_promoter/constants/image_assets_constants.dart';
import 'package:internal_base/common/alert/app_alert.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/message_constants.dart';


class CustomNavigationDrawerModel {
  final BuildContext cBuildContext;
  final CallbackModel mCallbackModel;

  late List<String> listBottomBar;

  CustomNavigationDrawerModel(
      this.cBuildContext, this.mCallbackModel) {
    listBottomBar = [
      AppConstants.cWordConstants.wHomeText,
      AppConstants.cWordConstants.wCommissionText,
      AppConstants.cWordConstants.wSalesReturnsText,
      AppConstants.cWordConstants.wProductListText,
      AppConstants.cWordConstants.wProfileSettingsText
    ];
  }

  getHomeAssets(){
    if(mCallbackModel.sMenuValue == AppConstants.cWordConstants.wHomeText){
      return ImageAssetsConstants.warehouseManagerDashboardSelectHome;
    }
    return ImageAssetsConstants.warehouseManagerDashboardHome;
  }

  getCommissionAssets(){
    if(mCallbackModel.sMenuValue == AppConstants.cWordConstants.wCommissionText){
      return ImageAssetsConstants.dashboardSelectCommissionList;
    }
    return ImageAssetsConstants.dashboardCommissionList;
  }

  getSaleReturnAssets(){
    if(mCallbackModel.sMenuValue == AppConstants.cWordConstants.wSalesReturnsText){
      return ImageAssetsConstants.dashboardSelectSaleReturn;
    }
    return ImageAssetsConstants.dashboardSaleReturn;
  }

  getProductListAssets(){
    if(mCallbackModel.sMenuValue == AppConstants.cWordConstants.wProductListText){
      return ImageAssetsConstants.warehouseManagerDashboardSelectProductList;
    }
    return ImageAssetsConstants.warehouseManagerDashboardProductList;
  }

  getProfileSettingsAssets(){
    if(mCallbackModel.sMenuValue == AppConstants.cWordConstants.wProfileSettingsText){
      return ImageAssetsConstants.warehouseManagerDashboardSelectProfile;
    }
    return ImageAssetsConstants.warehouseManagerDashboardProfile;
  }

  selectedIcon(){

  }

  unSelectedIcon(){

  }

  openNext(String sRoute,String sValue){
    AppAlert.showProgress = false;
    Navigator.pop(cBuildContext);
    if (sRoute.isEmpty) {
      if (sValue == AppConstants.cWordConstants.wLogoutText) {
        ///Logout
        AppAlert.showCustomDialogYesNo(
            cBuildContext,sValue, MessageConstants.wLogoutMessage);
      }
    } else if(mCallbackModel.sMenuValue !=sValue){
      if(isGet(sValue)){
        Navigator.pushReplacementNamed(cBuildContext, sRoute,
            arguments: mCallbackModel);
      }else {
        Navigator.pushNamed(cBuildContext, sRoute,
            arguments: mCallbackModel);
      }
    }

  }

  isGet(String sValue){
    for(var element in listBottomBar){
      if(sValue == element){
        return true;
      }
    }
    return false;
  }

  isSelectedMenu(String sValue){
    if(mCallbackModel.sMenuValue ==sValue){
      return true;
    }
    return false;
  }
}
