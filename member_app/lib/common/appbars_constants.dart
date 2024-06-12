import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:member_app/common/color_constants.dart';
import 'package:member_app/common/image_assets.dart';

import 'appbar_action_constants.dart';
import 'size_constants.dart';
import 'text_styles_constants.dart';

class AppBars {
  AppBars._();
  static PreferredSizeWidget appNoBar() {
    return PreferredSize(
        preferredSize: Size.fromHeight(SizeConstants.s2),
        child: AppBar());
  }



  static PreferredSizeWidget appBar(
      ValueChanged<String> appbarActionInterface, String title,
      {double dTitleSpacing = 0.0,
      String subTitle = "",
      String iconOne = "",
      String iconTwo = ""}) {
    return PreferredSize(
      preferredSize: Size.fromHeight(SizeConstants.s_64),
      child: AppBar(
        toolbarHeight: SizeConstants.s_64,
        titleSpacing: dTitleSpacing,
        bottomOpacity: 0.6,
        actions: [
          appbarActionIcon(appbarActionInterface, Colors.black, iconOne),
          appbarActionIcon(appbarActionInterface, Colors.black, iconTwo)
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: getTextMedium(
                    colors: Colors.white, size: SizeConstants.width * 0.045)),
            Container(
              margin: EdgeInsets.only(right: SizeConstants.s_15),
              child: Image.asset(
                ImageAssets.imageArianiLogo,
                height: SizeConstants.s1*36,
              ),
            )

          ],
        ),
        bottom: subTitle.isEmpty
            ? PreferredSize(
                preferredSize: Size.fromHeight(SizeConstants.s1),
                child: Container())
            : PreferredSize(
                preferredSize: Size.fromHeight(SizeConstants.s1),
                child: Row(
                  children: [
                    Container(
                      width: dTitleSpacing,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: SizeConstants.width * 0.0, bottom: 8.0),
                      child: Text(subTitle,
                          textAlign: TextAlign.left,
                          style: getTextRegular(
                              colors: Colors.white,
                              size: SizeConstants.width * 0.033)),
                    )
                  ],
                ),
              ),
        centerTitle: false,
        iconTheme: const IconThemeData(
          color: Colors.white, //// change your color here
        ),
          backgroundColor:ColorConstants.kPrimaryColor,
        // systemOverlayStyle: const SystemUiOverlayStyle(
        //     statusBarColor: ColorConstants.kPrimaryColor,
        //     statusBarIconBrightness: Brightness.light),
      ),
    );
  }


  static PreferredSizeWidget appBarHome(
      ValueChanged<String> appbarActionInterface, String title,
      {double dTitleSpacing = 0.0,
        String subTitle = "",
        String iconOne = "",
        String iconTwo = ""}) {
    return PreferredSize(
      preferredSize: Size.fromHeight(SizeConstants.s_64),
      child: AppBar(
        toolbarHeight: SizeConstants.s_64,
        titleSpacing: dTitleSpacing,
        bottomOpacity: 0.6,
        actions: [
          appbarActionIcon(appbarActionInterface, Colors.black, iconOne),
          appbarActionIcon(appbarActionInterface, Colors.black, iconTwo)
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                margin: EdgeInsets.only(left: SizeConstants.s_15),
                child:   Text(title,
                  style: getTextMedium(
                      colors: Colors.white, size: SizeConstants.width * 0.045)),
            ),

            Container(
              margin: EdgeInsets.only(right: SizeConstants.s_15),
              child: Image.asset(
                ImageAssets.imageArianiLogo,
                height: SizeConstants.s1*36,
              ),
            )

          ],
        ),
        bottom: subTitle.isEmpty
            ? PreferredSize(
            preferredSize: Size.fromHeight(SizeConstants.s1),
            child: Container())
            : PreferredSize(
          preferredSize: Size.fromHeight(SizeConstants.s1),
          child: Row(
            children: [
              Container(
                width: dTitleSpacing,
              ),
              Container(
                padding: EdgeInsets.only(
                    left: SizeConstants.width * 0.0, bottom: 8.0),
                child: Text(subTitle,
                    textAlign: TextAlign.left,
                    style: getTextRegular(
                        colors: Colors.white,
                        size: SizeConstants.width * 0.033)),
              )
            ],
          ),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(
          color: Colors.white, //// change your color here
        ),
        backgroundColor:ColorConstants.kPrimaryColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: ColorConstants.kPrimaryColor,
            statusBarIconBrightness: Brightness.light),
      ),
    );
  }

  static PreferredSizeWidget appBarLogo(
      ValueChanged<String> appbarActionInterface, Image assetImage,
      {double dTitleSpacing = 0.0,
        String subTitle = "",
        String iconOne = "",
        String iconTwo = ""}) {
    return PreferredSize(
      preferredSize: Size.fromHeight(SizeConstants.s_64),
      child: AppBar(
        toolbarHeight: SizeConstants.s_64,
        titleSpacing: dTitleSpacing,
        bottomOpacity: 0.6,
        actions: [
          appbarActionIcon(appbarActionInterface, Colors.black, iconOne),
          appbarActionIcon(appbarActionInterface, Colors.black, iconTwo)
        ],
        title: Container(margin:EdgeInsets.only(left: SizeConstants.s_15,),height: SizeConstants.s_18, child: assetImage),

        bottom: subTitle.isEmpty
            ? PreferredSize(
            preferredSize: Size.fromHeight(SizeConstants.s1),
            child: Container())
            : PreferredSize(
          preferredSize: Size.fromHeight(SizeConstants.s1),
          child: Row(
            children: [
              Container(
                width: dTitleSpacing,
              ),
              Container(
                padding: EdgeInsets.only(
                    left: SizeConstants.width * 0.0, bottom: 8.0),
                child: Text(subTitle,
                    textAlign: TextAlign.left,
                    style: getTextRegular(
                        colors: Colors.black,
                        size: SizeConstants.width * 0.033)),
              )
            ],
          ),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(
          color: Colors.black, //// change your color here
        ),
        backgroundColor:ColorConstants.cScaffoldBackgroundColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: ColorConstants.kPrimaryColor,
            statusBarIconBrightness: Brightness.light),
      ),
    );
  }

  static appbarActionIcon(
      ValueChanged<String> appbarActionInterface, Color color, String action) {
    switch (action) {
      case "":
        return const SizedBox.shrink();
      case AppBarActionConstants.actionSearch:
        return SizedBox(
          width: 30,
          child: IconButton(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            onPressed: () {
              appbarActionInterface(AppBarActionConstants.actionSearch);
              // AppbarStream().addNotificationAction("Search");
            },
            icon: const Icon(Icons.search),
            color: color,
          ),
        );

      case AppBarActionConstants.actionNotification:
        return IconButton(
          onPressed: () {
            appbarActionInterface(AppBarActionConstants.actionNotification);
            // AppbarStream().addNotificationAction("Search");
          },
          icon: const Icon(Icons.notifications_outlined),
          color: color,
        );
      case AppBarActionConstants.actionSave:
        return IconButton(
          onPressed: () {
            appbarActionInterface(AppBarActionConstants.actionSave);
            // AppbarStream().addNotificationAction("Search");
          },
          icon: const Icon(Icons.favorite_border),
          color: color,
        );
      case AppBarActionConstants.actionQrCode:
        return IconButton(
          onPressed: () {
            appbarActionInterface(AppBarActionConstants.actionQrCode);
            // AppbarStream().addNotificationAction("Search");
          },
          icon: const Icon(Icons.qr_code_scanner_rounded),
          color: color,
        );
      case AppBarActionConstants.actionUnSave:
        return IconButton(
          onPressed: () {
            appbarActionInterface(AppBarActionConstants.actionUnSave);
            // AppbarStream().addNotificationAction("Search");
          },
          icon: const Icon(Icons.favorite),
          color: ColorConstants.cOrangeButton,
        );
      case AppBarActionConstants.actionSaved:
        return IconButton(
          onPressed: () {
            appbarActionInterface(AppBarActionConstants.actionSaved);
            // AppbarStream().addNotificationAction("Search");
          },
          icon: const Icon(Icons.save_alt),
          color: color,
        );
      case AppBarActionConstants.actionShare:
        return IconButton(
          onPressed: () {
            appbarActionInterface(AppBarActionConstants.actionShare);
            // AppbarStream().addNotificationAction("Search");
          },
          icon: const Icon(Icons.share),
          color: color,
        );
      case AppBarActionConstants.actionLogout:
        return IconButton(
          onPressed: () {
            appbarActionInterface(AppBarActionConstants.actionLogout);
            // AppbarStream().addNotificationAction("Search");
          },
          icon: const Icon(Icons.logout),
          color: color,
        );

      case AppBarActionConstants.actionCancel:
        return IconButton(
          onPressed: () {
            appbarActionInterface(AppBarActionConstants.actionCancel);
            // AppbarStream().addNotificationAction("Search");
          },
          icon: const Icon(Icons.close),
          color: color,
        );

      case AppBarActionConstants.actionFilter:
        return IconButton(
          onPressed: () {
            appbarActionInterface(AppBarActionConstants.actionFilter);
            // AppbarStream().addNotificationAction("Search");
          },
          icon: const Icon(Icons.filter_alt_outlined),
          color: color,
        );
      case AppBarActionConstants.actionSort:
        return IconButton(
          onPressed: () {
            appbarActionInterface(AppBarActionConstants.actionSort);
            // AppbarStream().addNotificationAction("Search");
          },
          icon: const Icon(Icons.sort_sharp),
          color: color,
        );
      case AppBarActionConstants.actionEdit:
        return IconButton(
          onPressed: () {
            appbarActionInterface(AppBarActionConstants.actionEdit);
            // AppbarStream().addNotificationAction("Search");
          },
          icon: const Icon(Icons.edit),
          color: color,
        );
      case AppBarActionConstants.actionInformation:
        return IconButton(
          onPressed: () {
            appbarActionInterface(AppBarActionConstants.actionInformation);
            // AppbarStream().addNotificationAction("Search");
          },
          icon: const Icon(Icons.info_outline),
          color: color,
        );
      case AppBarActionConstants.actionHome:
        return IconButton(
          onPressed: () {
            appbarActionInterface(AppBarActionConstants.actionHome);
            // AppbarStream().addNotificationAction("Search");
          },
          icon: const Icon(Icons.home),
          color: color,
        );
    }
  }
}
