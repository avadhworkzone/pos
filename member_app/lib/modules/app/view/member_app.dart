import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:member_app/common/app_constants.dart';
import 'package:member_app/common/color_constants.dart';
import 'package:member_app/common/utils/device_utils.dart';
import 'package:member_app/common/word_constants.dart';
import 'package:member_app/modules/app/ui/material_app.dart';

class MemberApp extends StatefulWidget {
  const MemberApp({Key? key}) : super(key: key);

  @override
  _MemberAppState createState() => _MemberAppState();
}

class _MemberAppState extends State<MemberApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    initCreateLanguages(context);
    if (DeviceUtils.getPlatform() == AppConstants.platformAndroid) {
      setPortraitOrientation();
    }
    return getMaterialApp(context);
  }

  Future<void> setPortraitOrientation() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstants.kPrimaryColor,
      statusBarBrightness: Brightness.light,
    ));
  }

  Future<void> initCreateLanguages(BuildContext context) async {
    AppConstants.mWordConstants = await WordConstants.of(context);
  }
}