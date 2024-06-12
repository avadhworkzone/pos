import 'package:flutter/material.dart';
import 'package:internal_app/routes/route_constants.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/common/call_back.dart';

class SplashScreenModel {
  final BuildContext cBuildContext;
  final SharedPrefs sharedPrefs = SharedPrefs();
  late String loginUserType = "";

  SplashScreenModel(this.cBuildContext);

  initSharedPreferencesInstance() async {
    await SharedPrefs().sharedPreferencesInstance();
  }

  getToken() async {
    bool bReturn = false;
    await SharedPrefs().getUserToken().then((tokenValue) async {
      if(tokenValue.toString()!="null"&&tokenValue.toString().isNotEmpty) {
        await SharedPrefs().getUserTokenType().then((roleType) async {
          if (roleType.toString()!="null"&&roleType.toString().isNotEmpty) {
            loginUserType = roleType;
            bReturn =  true;
          }
        });
      }
    });
    return bReturn;
  }

  getOpenScreen() async{
    if(await getToken()){
      switch(loginUserType){
        case "PromoterLogin":
          Navigator.pushNamed(
              cBuildContext,
              RouteConstants.rPromoterHomeViewScreenWidget,
              arguments: CallbackModel()
          );
          break;

        case "StoreManagerLogin":
          Navigator.pushNamed(
              cBuildContext,
              RouteConstants.rStoreManagerHomeScreenWidget,
              arguments: CallbackModel()
          );
          break;

        case "WarehouseManagerLogin":
          Navigator.pushNamed(
              cBuildContext,
              RouteConstants.rWarehouseManagerHomeViewScreenWidget,
              arguments: CallbackModel()
          );
          break;
      }

    }else{
      print("#####loginUserType##### $loginUserType");

      Navigator.pushNamed(
        cBuildContext,
        RouteConstants.rWalkThroughScreenWidget,
      );
    }
  }

  // getToken() async {
  //   Navigator.pushNamedAndRemoveUntil(
  //     cBuildContext,
  //     RouteConstants.rWalkThroughScreenWidget,
  //     (route) => false,
  //   );
  // }
}
