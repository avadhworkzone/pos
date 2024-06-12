import 'package:jakel_base/utils/appinfo/model/AppInfoModel.dart';
// import 'package:package_info_plus/package_info_plus.dart';

Future<AppInfoModel> getAppInformation() async {
  //PackageInfo packageInfo = await PackageInfo.fromPlatform();

  String appName = "Ariani POS"; //packageInfo.appName;
  String packageName = ""; //packageInfo.packageName;
  String version = "1.51.1"; //packageInfo.version;
  String buildNumber = "1"; // packageInfo.buildNumber;

  return AppInfoModel(
      appName: appName,
      packageName: packageName,
      version: version,
      buildNumber: buildNumber);
}
