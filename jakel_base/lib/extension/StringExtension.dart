import 'package:jakel_base/routing/RoutingData.dart';

extension StringExtension on String {
  RoutingData get getRoutingData {
    var uriData = Uri.parse(this);
    return RoutingData(
      queryParameters: uriData.queryParameters,
      route: uriData.path,
    );
  }
}

extension CapExtension on String {
  String get inCaps =>
      '${this[0].toUpperCase()}${this.substring(1).toLowerCase()}';

  String get allInCaps => this.toUpperCase();
}
