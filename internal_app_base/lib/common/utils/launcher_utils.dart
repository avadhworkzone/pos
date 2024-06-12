import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';


class LauncherUtils {
  // Singleton approach
  static final LauncherUtils _instance = LauncherUtils._internal();

  factory LauncherUtils() => _instance;

  LauncherUtils._internal();

  launchPhone(String phone) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'tel',
      path: phone,
    );

    launchUrl(emailLaunchUri);
  }

  launchEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      // query: encodeQueryParameters(<String, String>{
      //   'subject': 'Example Subject & Symbols are allowed!'
      // }),
    );

    launchUrl(emailLaunchUri);
  }

  // launchWebUrlInsideApp(String webUrl, BuildContext context) async {
  //   if (webUrl.toString().toLowerCase() != "null" && webUrl.isNotEmpty) {
  //     Navigator.pushNamed(context, RouteConstants.rWebPageScreen,
  //         arguments: WebPageArgs(
  //           webPageURL: webUrl.toString().trim(),
  //         ));
  //
  //     // if (await canLaunchUrl(Uri.parse(webUrl))) {
  //     //   await launchUrl(Uri.parse(webUrl));
  //     // } else {
  //     //  // debugPrint("Unable to launch website url");
  //     // }
  //   }
  // }

  launchWebUrl(String webUrl, BuildContext context) async {
    if (webUrl.toString().toLowerCase() != "null" && webUrl.isNotEmpty) {
      if (await canLaunchUrl(Uri.parse(webUrl))) {
        await launchUrl(Uri.parse(webUrl));
      } else {
        // debugPrint("Unable to launch website url");
      }
    }
  }

  launchWebUrlExternalApp(String webUrl, BuildContext context) async {
    if (webUrl.toString().toLowerCase() != "null" && webUrl.isNotEmpty) {
      if (await canLaunchUrl(Uri.parse(webUrl))) {
        await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalNonBrowserApplication);
      } else {
        // debugPrint("Unable to launch website url");
      }
    }
  }

  launchWhatsApp(String whatsAppNumber, String countryCode) async {
    // String androidWhatsApp = "https://wa.me/$countryCode$whatsAppNumber/?text=${Uri.parse("")}";
    // String androidWhatsApp = "https://wa.me/7200707613/?text=damu";
    // String androidWhatsApp = "https://api.whatsapp.com/send/?phone=$countryCode$whatsAppNumber";
    String androidWhatsApp =
        "whatsapp://send?phone=$countryCode$whatsAppNumber";

    String iOSWhatsAppNumber = whatsAppNumber.replaceAll(' ', '');
    String iOSWhatsApp = "https://wa.me/$countryCode$iOSWhatsAppNumber";

    // "https://api.whatsapp.com/send?phone=$iOSWhatsAppNumber=${Uri.parse("")}";
    // "https://wa.me/11115131618"; -- working url for launching the whatsapp in iOS

    if (Platform.isAndroid) {
      if (await canLaunchUrl(Uri.parse(androidWhatsApp))) {
        await launchUrl(Uri.parse(androidWhatsApp));
      }
    } else {
      if (await canLaunchUrl(Uri.parse(iOSWhatsApp))) {
        await launchUrl(Uri.parse(iOSWhatsApp));
      }
    }
  }

  launchMap(double latitude, double longitude) async {
    // debugPrint("launchMap $latitude");
    String googleMapUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    // final String googleMapUrl = "comgooglemaps://?center=$latitude,$longitude";
    final String appleMapUrl = "https://maps.apple.com/?q=$latitude,$longitude";

    // await canLaunch(googleMapUrl).then((value) {
    //   // debugPrint(" value $value");
    // });

    if (Platform.isIOS) {
      if (await canLaunchUrl(Uri.parse(appleMapUrl))) {
        await launchUrl(Uri.parse(appleMapUrl));
      }
    } else if (await canLaunchUrl(Uri.parse(googleMapUrl))) {
      // debugPrint("googleMapUrl $googleMapUrl");
      await launchUrl(Uri.parse(googleMapUrl));
    }
  }

  launchStore() async {
    // debugPrint("launchStore");
    String playStoreUrl = "market://details?id=superapp.hrdcorp.gov.my";
    // String playStoreFullUrl =
    //     "https://play.google.com/store/apps/details?id=superapp.hrdcorp.gov.my";
    // String appStoreUrl = "apps://itunes.apple.com/app/id1610995232";
    String appStoreUrl = "https://apps.apple.com/in/app/myhrdcorp/id1610995232";
    // debugPrint("launchStore isAndroid ${Platform.isAndroid}");

    if (Platform.isAndroid && await canLaunchUrl(Uri.parse(playStoreUrl))) {
      try {
        // debugPrint("launchStore playStoreUrl");
        await launchUrl(Uri.parse(playStoreUrl));
      } on PlatformException catch (e) {
        // debugPrint("launchStore playStoreFullUrl");
        launchUrl(Uri.parse(playStoreUrl));
      }
    } else if (Platform.isIOS) {
      // debugPrint("launchStore appStoreUrl");
      launchUrl(Uri.parse(appStoreUrl));
    }
  }

  // launchForceUpdate(BuildContext context, String iOSAppVersion,
  //     String androidAppVersion, String forceUpdateMessage) {
  //   if (Platform.isAndroid) {
  //     int webApiAndroidAppVersionCode = int.parse(androidAppVersion);
  //     // int   webApiAndroidAppVersionCode =6;
  //     // debugPrint("webApiAndroidAppVersionCode $webApiAndroidAppVersionCode");
  //     AppUtils.getAndroidAppVersionCode().then((currentAndroidAppVersionCode) {
  //       // debugPrint(
  //       //     "currentAndroidAppVersionCode $currentAndroidAppVersionCode");
  //       if (webApiAndroidAppVersionCode > currentAndroidAppVersionCode) {
  //         AppAlert.showCustomDialogOK(context, forceUpdateMessage)
  //             .then((value) {
  //           LauncherUtils().launchStore();
  //         });
  //       }
  //     });
  //   } else if (Platform.isIOS) {
  //     if(iOSAppVersion.isNotEmpty){
  //       double webApiIOSAppVersionCode = double.parse(iOSAppVersion);
  //       // debugPrint("webApiIOSAppVersionCode $webApiIOSAppVersionCode");
  //       AppUtils.getIOSAppVersionCode().then((currentIOSAppVersionCode) {
  //         // debugPrint("currentIOSAppVersionCode $currentIOSAppVersionCode");
  //         if (webApiIOSAppVersionCode > currentIOSAppVersionCode) {
  //           AppAlert.showCustomDialogOK(context, forceUpdateMessage)
  //               .then((value) {
  //             LauncherUtils().launchStore();
  //           });
  //         }
  //       });
  //     }
  //   }
  // }
}
