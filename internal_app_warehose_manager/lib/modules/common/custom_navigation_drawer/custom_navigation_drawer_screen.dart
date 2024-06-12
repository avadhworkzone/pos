import 'package:flutter/material.dart';
import 'package:internal_app_warehose_manager/constants/image_assets_constants.dart';
import 'package:internal_app_warehose_manager/modules/common/custom_navigation_drawer/model/custom_navigation_drawer_model.dart';
import 'package:internal_app_warehose_manager/routes/route_constants.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:internal_base/common/color_constants.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/text_styles_constants.dart';

class CustomNavigationDrawer extends StatefulWidget {
  final CallbackModel mCallbackModel;

  const CustomNavigationDrawer({super.key, required this.mCallbackModel});

  @override
  State<CustomNavigationDrawer> createState() => _CustomNavigationDrawerState();
}

class _CustomNavigationDrawerState extends State<CustomNavigationDrawer> {
  late CustomNavigationDrawerModel mCustomNavigationDrawerModel;

  @override
  void initState() {
    mCustomNavigationDrawerModel =
        CustomNavigationDrawerModel(context, widget.mCallbackModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(child: buildDrawerView());
  }

  buildDrawerView() {
    return FocusDetector(
      onVisibilityGained: () async {},
      child: Container(
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: SizeConstants.s1 * 35,
                ),
                color: ColorConstants.kPrimaryColor,
                height: SizeConstants.width * 0.55,
                width: SizeConstants.width,
                child: Image.asset(ImageAssetsConstants.splashLogo),
              ),
              Expanded(
                  child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(children: [
                  ///Home
                  _buildSideMenuItemAsset(
                      mCustomNavigationDrawerModel.getHomeAssets(),
                      AppConstants.cWordConstants.wHomeText,
                      RouteConstants.rWarehouseManagerHomeViewScreenWidget),

                  ///ProductList
                  _buildSideMenuItemAsset(
                      mCustomNavigationDrawerModel.getProductListAssets(),
                      AppConstants.cWordConstants.wProductListText,
                      RouteConstants.rWarehouseManagerProductListScreenWidget),

                  ///ProfileSettings
                  _buildSideMenuItemAsset(
                      mCustomNavigationDrawerModel.getProfileSettingsAssets(),
                      AppConstants.cWordConstants.wProfileSettingsText,
                      RouteConstants
                          .rWarehouseManagerProfileSettingsScreenWidget),

                  ///Logout
                  _buildSideMenuItemIcon(
                      const Icon(Icons.logout, color: Colors.black),
                      AppConstants.cWordConstants.wLogoutText,
                      ""),
                ]),
              ))
            ],
          )),
    );
  }

  _buildSideMenuItemAsset(String icon, String title, String navRoute,
      [dynamic args]) {
    return Container(
      margin: EdgeInsets.only(
          left: SizeConstants.s1 * 15,
          right: SizeConstants.s1 * 15,
          top: SizeConstants.s1 * 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.all(Radius.circular(SizeConstants.s1 * 9))),
      child: ListTile(
        leading: Padding(
            padding: EdgeInsets.only(left: SizeConstants.s1 * 8),
            child: SizedBox(
                height: SizeConstants.s1 * 22,
                width: SizeConstants.s1 * 22,
                child: Image.asset(icon))),
        title: Text(
          title,
          style: getTextSemiBold(
            size: SizeConstants.s1 * 16,
            colors: mCustomNavigationDrawerModel.isSelectedMenu(title)
                ? ColorConstants.kPrimaryColor
                : ColorConstants.cBlack,
          ),
        ),
        onTap: () async {
          mCustomNavigationDrawerModel.openNext(navRoute, title);
        },
      ),
    );
  }

  _buildSideMenuItemIcon(Icon icon, String title, String navRoute,
      [dynamic args]) {
    return Container(
      margin: EdgeInsets.only(
          left: SizeConstants.s1 * 15,
          right: SizeConstants.s1 * 15,
          top: SizeConstants.s1 * 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.all(Radius.circular(SizeConstants.s1 * 9))),
      child: ListTile(
        leading: Padding(
            padding: EdgeInsets.only(left: SizeConstants.s1 * 8),
            child: SizedBox(
                height: SizeConstants.s1 * 22,
                width: SizeConstants.s1 * 22,
                child: icon)),
        title: Text(
          title,
          style: getTextSemiBold(
            size: SizeConstants.s1 * 16,
            colors: mCustomNavigationDrawerModel.isSelectedMenu(title)
                ? ColorConstants.kPrimaryColor
                : ColorConstants.cBlack,
          ),
        ),
        onTap: () async {
          mCustomNavigationDrawerModel.openNext(navRoute, title);
        },
      ),
    );
  }
}
