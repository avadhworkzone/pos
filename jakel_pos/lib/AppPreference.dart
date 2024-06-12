class AppPreference {
  static final AppPreference _singleton = AppPreference._internal();

  factory AppPreference() {
    return _singleton;
  }

  AppPreference._internal();

  var refreshProductsData = false;
}
