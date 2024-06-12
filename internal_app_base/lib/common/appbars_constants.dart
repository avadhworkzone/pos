import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internal_base/common/color_constants.dart';
import 'package:internal_base/common/image_assets.dart';

import 'appbar_action_constants.dart';
import 'size_constants.dart';
import 'text_styles_constants.dart';

class AppBars {
  AppBars._();

  static PreferredSizeWidget appNoBar() {
    return PreferredSize(
        preferredSize: Size.fromHeight(SizeConstants.s1 * 2),
        child: AppBar());
  }


  static PreferredSizeWidget appBar(Function appbarActionInterface,
      String title,
      {double dTitleSpacing = 0.0,
        String iconOne = "",
        String sImageAssetsOne = "",
        String iconTwo = "",
        String sImageAssetsTwo = "",
        String sMenu = ""}) {
    return PreferredSize(
      preferredSize: Size.fromHeight(SizeConstants.s1 * 75),
      child: AppBar(
          elevation: 0,
          toolbarHeight: SizeConstants.s1 * 75,
          titleSpacing: dTitleSpacing,
          bottomOpacity: 0.6,
          automaticallyImplyLeading: false,
          actions: [
            appbarActionIcon(
                appbarActionInterface, Colors.black, iconOne, sImageAssetsOne),
            appbarActionIcon(
                appbarActionInterface, Colors.black, iconTwo, sImageAssetsTwo),
            // appbarActionIcon(
            //     appbarActionInterface, Colors.black, sMenu, "")
          ],
          title: Container(
            height: SizeConstants.s1 * 75,
            child: Row(children: [
              sMenu.isEmpty ?
              SizedBox(width: SizeConstants.s1 * 16,) :
              appbarActionIcon(
                  appbarActionInterface, Colors.black, sMenu, ""),
              Text(title,
                  style: getTextSemiBold(
                      colors: Colors.black, size: SizeConstants.s1 * 18)),
            ]),
          ),
          centerTitle: false,
          iconTheme: const IconThemeData(
            color: Colors.black, //// change your color here
          ),
          backgroundColor: ColorConstants.cScaffoldBackgroundColor
      ),
    );
  }

  static PreferredSizeWidget appBarHome(Function appbarActionInterface,
      String title,
      {double dTitleSpacing = 0.0,
        String iconOne = "",
        String sImageAssetsOne = "",
        String iconTwo = "",
        String sImageAssetsTwo = "",
        String sImageAssets = "",
        String sMenu = ""}) {
    return PreferredSize(
      preferredSize: Size.fromHeight(SizeConstants.s1 * 75),
      child: AppBar(
        elevation: 0,
        toolbarHeight: SizeConstants.s1 * 75,
        titleSpacing: dTitleSpacing,
        bottomOpacity: 0.6,
        automaticallyImplyLeading: false,
        actions: [
          appbarActionIcon(
              appbarActionInterface, Colors.black, iconOne, sImageAssetsOne),
          appbarActionIcon(
              appbarActionInterface, Colors.black, iconTwo, sImageAssetsTwo),
          // appbarActionIcon(
          //     appbarActionInterface, Colors.black, sMenu, "")
        ],
        title: Container(
          height: SizeConstants.s1 * 75,
          child: Row(children: [
            sMenu.isEmpty ?
            SizedBox(width: SizeConstants.s1 * 16,) :
            appbarActionIcon(
                appbarActionInterface, Colors.black, sMenu, ""),
            GestureDetector(
                onTap: () {
                  appbarActionInterface("Profile");
                },
                child:
                Row(
                  children: [
                    Text("Hi ",
                        style: getTextRegular(
                            colors: Colors.grey,
                            size: SizeConstants.width * 0.045)),
                    Text("$title,  ",
                        style: getTextMedium(
                            colors: Colors.black,
                            size: SizeConstants.width * 0.045)),
                    sImageAssets.isNotEmpty ?
                    Image(
                      width: SizeConstants.s1 * 18,
                      height: SizeConstants.s1 * 18,
                      image: AssetImage(sImageAssets ?? ""),
                    ) : SizedBox(),
                  ],
                ))

          ],

          ),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(
          color: Colors.black, //// change your color here
        ),
        backgroundColor: ColorConstants.cScaffoldBackgroundColor,
      ),
    );
  }

  static PreferredSizeWidget appBarBack(Function appbarActionInterface,
      String title,
      {double dTitleSpacing = 0.0,
        String iconOne = "",
        String sImageAssetsOne = "",
        String iconTwo = "",
        String sImageAssetsTwo = "",}) {
    return PreferredSize(
      preferredSize: Size.fromHeight(SizeConstants.s1 * 75),
      child: AppBar(
          elevation: 0,
          toolbarHeight: SizeConstants.s1 * 75,
          titleSpacing: dTitleSpacing,
          bottomOpacity: 0.6,
          automaticallyImplyLeading: false,
          actions: [
            appbarActionIcon(
                appbarActionInterface, Colors.black, iconOne, sImageAssetsOne),
            appbarActionIcon(
                appbarActionInterface, Colors.black, iconTwo, sImageAssetsTwo)
          ],
          title: Container(
              margin: EdgeInsets.only(left: SizeConstants.s1 * 5),
              child: Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.all(SizeConstants.s1 * 0),
                    onPressed: () {
                      appbarActionInterface(AppBarActionConstants.actionBack);
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Colors.black,
                  ),
                  Text(title,
                      style: getTextSemiBold(
                          colors: Colors.black,
                          size: SizeConstants.width * 0.045)),
                ],
              )

          ),
          centerTitle: false,
          iconTheme: const IconThemeData(
            color: Colors.black, //// change your color here
          ),
          backgroundColor: ColorConstants.cScaffoldBackgroundColor
      ),
    );
  }


  static appbarActionIcon(Function appbarActionInterface, Color color,
      String action, String sImageAssets) {
    switch (action) {
      case "":
        return const SizedBox.shrink();

      case AppBarActionConstants.actionMenu:
        return GestureDetector(
          onTap: () {
            appbarActionInterface("Menu");
            // Scaffold.of(context).openDrawer();
          },
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: SizeConstants.s1 * 16,
                left: SizeConstants.s1 * 16,
                top: SizeConstants.s1 * 16,
                bottom: SizeConstants.s1 * 16),
            padding: EdgeInsets.only(
                left: SizeConstants.s1 * 12, right: SizeConstants.s1 * 12),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                    Radius.circular(SizeConstants.s1 * 9))
            ),
            child: Icon(Icons.menu, color: Colors.black),

          ),
        );

      case AppBarActionConstants.actionFilter:
        return
          GestureDetector(
            onTap: () {
              appbarActionInterface(AppBarActionConstants.actionFilter);
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(SizeConstants.s1 * 16),
              padding: EdgeInsets.all(SizeConstants.s1 * 12),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                      Radius.circular(SizeConstants.s1 * 9))
              ),
              child: Image(
                image: AssetImage(sImageAssets ?? ""),),

            ),
          );
    //   IconButton(
    //   onPressed: () {
    //     appbarActionInterface(AppBarActionConstants.actionFilter);
    //     // AppbarStream().addNotificationAction("Search");
    //   },
    //   icon: const Icon(Icons.filter_list_alt),
    //   color: color,
    // );
    }
  }
}
