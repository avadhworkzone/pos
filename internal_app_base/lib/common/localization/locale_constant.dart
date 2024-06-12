import 'package:shared_preferences/shared_preferences.dart';

const String prefSelectedLanguageCode = "SelectedLanguageCode";

class InterfaceSetLocale{
  void getDone(){}
}

 setLocale(String languageCode, InterfaceSetLocale mInterfaceSetLocale) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(prefSelectedLanguageCode, languageCode);
  mInterfaceSetLocale.getDone();
  // return _locale(languageCode);
}

Future<String> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(prefSelectedLanguageCode) ?? "en";
  return languageCode;
}

