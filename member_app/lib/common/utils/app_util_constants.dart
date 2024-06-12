class AppUtilConstants{
  // Pattern Matcher
  static const String patternEmail =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static const String patternMobile = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  static const String patternPassword = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*|_~`\=+-[{},.?:;])(?=.{8,}))';
  static const String patternStringCapsSpace= r'[A-Z ]';
  static const String patternStringCapsNumbers= r'[A-Z0-9]';
  static const String patternOnlyNumber = "[0-9]";
  static const String patternDecimalNumber = "[0-9.]";
  static const String patternTwoDecimalNumberOnly = r'(^\d*\.?\d{0,2})';
  static const String patternOnlyString = "[a-zA-Z]";
  static const String patternStringAndSpace = "[a-zA-Z ]";
  static const String patternEmailStringAtDot = "[a-zA-Z0-9-.@_]";
  static const String patternMyCroIdStringAtDot = "[a-zA-Z0-9- .@_]";
  // static const String patternStringNumber = "[a-zA-Z0-9]";
  static const String patternStringNumberSpace = "[a-zA-Z0-9 ]";
  static const String patternUrlLink = "[a-zA-Z0-9;,/?:@&=+\$-_.!~*'()#]";
  static const String patternAddress = "[a-zA-Z0-9.,/' ]";
  static const String patternSkills = "[a-zA-Z, ]";
  static const String patternCompanyRegNumber = "[0-9A-Z-]";
  static const String patternCompanyName = "[a-zA-Z0-9-. ]";
  static const String patternToRemoveEmoji =  r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])';
  static const String patternWebUrl =  r"(http|ftp|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?";
}