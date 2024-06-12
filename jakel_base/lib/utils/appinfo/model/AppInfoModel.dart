import 'dart:convert';

/// appName : ""
/// packageName : ""
/// version : ""
/// buildNumber : ""

AppInfoModel appInfoModelFromJson(String str) =>
    AppInfoModel.fromJson(json.decode(str));

String appInfoModelToJson(AppInfoModel data) => json.encode(data.toJson());

class AppInfoModel {
  AppInfoModel({
    String? appName,
    String? packageName,
    String? version,
    String? buildNumber,
  }) {
    _appName = appName;
    _packageName = packageName;
    _version = version;
    _buildNumber = buildNumber;
  }

  AppInfoModel.fromJson(dynamic json) {
    _appName = json['appName'];
    _packageName = json['packageName'];
    _version = json['version'];
    _buildNumber = json['buildNumber'];
  }

  String? _appName;
  String? _packageName;
  String? _version;
  String? _buildNumber;

  AppInfoModel copyWith({
    String? appName,
    String? packageName,
    String? version,
    String? buildNumber,
  }) =>
      AppInfoModel(
        appName: appName ?? _appName,
        packageName: packageName ?? _packageName,
        version: version ?? _version,
        buildNumber: buildNumber ?? _buildNumber,
      );

  String? get appName => _appName;

  String? get packageName => _packageName;

  String? get version => _version;

  String? get buildNumber => _buildNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['appName'] = _appName;
    map['packageName'] = _packageName;
    map['version'] = _version;
    map['buildNumber'] = _buildNumber;
    return map;
  }
}
