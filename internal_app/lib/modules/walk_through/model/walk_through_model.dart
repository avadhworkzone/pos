import 'package:flutter/material.dart';
import 'package:internal_app/routes/route_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';

class WalkThroughScreenModel {
  final BuildContext cBuildContext;

  WalkThroughScreenModel(this.cBuildContext);

  initSharedPreferencesInstance() async {
    await SharedPrefs().sharedPreferencesInstance();
  }

  showLoginPage(String sTitle) async {
    CallbackModel mCallbackModel = CallbackModel();
    mCallbackModel.sValue = sTitle;
    switch(sTitle){
      case "Promoter":
        Navigator.pushNamed(
          cBuildContext, RouteConstants.rPromoterLoginScreenWidget,);
        break;
      case "Store Manager":
        Navigator.pushNamed(
            cBuildContext, RouteConstants.rStoreManagerLoginScreenWidget,
            arguments: mCallbackModel);
        break;
      case "Warehouse Manager":
        Navigator.pushNamed(
            cBuildContext, RouteConstants.rWarehouseManagerLoginScreenWidget,);

        break;
    }
  }
}
