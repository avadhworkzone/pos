import 'package:flutter/material.dart';
import 'package:member_app/common/word_constants.dart';
import '../localization/language/language_en.dart';

import 'language/language_my.dart';


class AppLocalizationsDelegate  {

  const AppLocalizationsDelegate();

  static WordConstants load(Locale locale)  {
    switch (locale.languageCode) {
      case 'en':
        return LanguageEn();
        case 'my':
        return LanguageMy();
      default:
        return LanguageEn();
    }
  }
}
