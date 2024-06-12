import 'package:intl/intl.dart';


String getDateFromFormatter(String dateStr, String fromFormatter, String toFormatter) {

  if (dateStr == null) {
    return "";
  }
  var parseDate = DateFormat(fromFormatter).parse(dateStr);
  var outputDate = DateFormat(toFormatter).format(parseDate);

  return outputDate;
}

