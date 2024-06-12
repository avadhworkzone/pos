import 'package:intl/intl.dart';

bool checkIsValidDate(String? startDateAsString, String? endDateAsString) {
  if (startDateAsString == null && endDateAsString == null) {
    return true;
  }

  var now = getCurrentDate();

  //End date is empty. So check only for start date
  if (endDateAsString == null) {
    var startDate = DateFormat("yyyy-MM-dd").parse(startDateAsString!);
    if (now.isAfter(startDate) || now.isAtSameMomentAs(startDate)) {
      return true;
    }
  }

  //Start date is empty. So check only for end date
  if (startDateAsString == null) {
    var endDate = DateFormat("yyyy-MM-dd").parse(endDateAsString!);
    if (now.isBefore(endDate) || now.isAtSameMomentAs(endDate)) {
      return true;
    }
  }

  if(startDateAsString != null && endDateAsString != null) {
    var startDate = DateFormat("yyyy-MM-dd").parse(startDateAsString!);
    var endDate = DateFormat("yyyy-MM-dd").parse(endDateAsString!);

  if ((now.isAfter(startDate) || now.isAtSameMomentAs(startDate)) &&
      (now.isBefore(endDate) || now.isAtSameMomentAs(endDate))) {
    return true;
    }
  }
  return false;
}

String addDaysToDate(int days) {
  var date = getNow().add(Duration(days: days));
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(date);
}

String addDaysToTargatedDate(int days, String dateAsString) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  if (dateAsString != null) {
    var targetDate = DateFormat("yyyy-MM-dd").parse(dateAsString!);
    var date = targetDate.add(Duration(days: days));
    return formatter.format(date);
  }
  return dateAsString;
}


bool isGiftCardsDateExpired(String? dateAsString) {
  var now = getCurrentDate();

  if (dateAsString != null) {
    var targetDate = DateFormat("yyyy-MM-dd").parse(dateAsString!);
    if (targetDate.millisecondsSinceEpoch >= now.millisecondsSinceEpoch) {
      return true;
    }
  }

  return false;
}

bool isVoucherDateExpired(String? dateAsString) {
  if (dateAsString == null) {
    return false;
  }

  var now = DateTime.now();

  var targetDate = DateFormat("yyyy-MM-dd").parse(dateAsString).add(Duration(days: 1));

  if (targetDate.compareTo(now)<0) {
    return true;
  }

  return false;
}

bool isDateExpired(String? dateAsString) {
  if (dateAsString == null) {
    return false;
  }

  var now = getNow();

  var targetDate = DateFormat("yyyy-MM-dd").parse(dateAsString);

  if (now.isAfter(targetDate)) {
    return true;
  }

  return false;
}

bool isSameDate(String? dateAsString) {
  if (dateAsString == null) {
    return false;
  }

  var now = getNow();

  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(now);

  if (formatted == dateAsString) {
    return true;
  }

  return false;
}

bool checkIsValidTime(
    String? date, String? startTimeAsString, String? endTimeAsString) {
  if (startTimeAsString == null && endTimeAsString == null) {
    return true;
  }

  var now = getCurrentDateAndTime();

  //End time is empty. So check only for start date
  if (endTimeAsString == null) {
    var startDate =
        DateFormat("yyyy-MM-dd HH:mm:ss").parse('$date $startTimeAsString');
    if (now.isAfter(startDate) || now.isAtSameMomentAs(startDate)) {
      return true;
    }
  }

  //Start date is empty. So check only for end date
  if (startTimeAsString == null) {
    var endDate =
        DateFormat("yyyy-MM-dd HH:mm:ss").parse('$date $endTimeAsString');
    if (now.isBefore(endDate) || now.isAtSameMomentAs(endDate)) {
      return true;
    }
  }

  var startDate =
      DateFormat("yyyy-MM-dd HH:mm:ss").parse('$date $startTimeAsString');
  var endDate =
      DateFormat("yyyy-MM-dd HH:mm:ss").parse('$date $endTimeAsString');

  if (now.isAfter(startDate) && now.isBefore(endDate)) {
    return true;
  }

  return false;
}

int getUtcTimeInMs() {
  return DateTime.now().toUtc().millisecondsSinceEpoch;
}

String readableDateBig(int? millis) {
  if (millis == null) {
    return "--";
  }
  final DateTime now =
      DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true).toLocal();
  final DateFormat formatter = DateFormat('EEE ,dd MMM, yyyy');
  final String formatted = formatter.format(now);
  return formatted;
}

String readableDateVeryBig(int? millis) {
  DateTime now = getNow();
  if (millis != null) {
    now = DateTime.fromMillisecondsSinceEpoch(millis);
  }

  final DateFormat formatter = DateFormat('EEE, dd MMM, yyyy, hh:mm aa');
  final String formatted = formatter.format(now);
  return formatted.toUpperCase();
}

String readableDateSmall(int? millis) {
  if (millis == null) {
    return "--";
  }
  final DateTime now =
      DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true).toLocal();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(now);
  return formatted;
}

String dateTimeYmdHis() {
  final DateTime now = getNow();
  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  final String formatted = formatter.format(now);
  return formatted;
}

String dateTimeYmdHis24Hour() {
  final DateTime now = getNow();
  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  final String formatted = formatter.format(now);
  return formatted;
}

String dateTimeYmdHisMillis24Hour() {
  final DateTime now = getNow();
  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
  final String formatted = formatter.format(now);
  return formatted;
}

String todayDateYmd() {
  final DateTime now = getNow();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(now);
  return formatted;
}

String dateYmdHis(DateTime dateTime) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
  final String formatted = formatter.format(dateTime);
  return formatted;
}

String dateYmd(int? millis) {
  if (millis == null) {
    return "--";
  }
  final DateTime now =
      DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true).toLocal();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(now);
  return formatted;
}

String? dateYmdFromDate(DateTime? from) {
  if (from == null) {
    return null;
  }
  final DateTime now = from.toLocal();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(now);
  return formatted;
}

String? dateTimeFromDate(DateTime? from) {
  if (from == null) {
    return null;
  }
  final DateTime now = from.toLocal();
  final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm a');
  final String formatted = formatter.format(now);
  return formatted;
}

DateTime getDateFromYmd(String date) {
  return DateFormat("yyyy-MM-dd").parse(date).toLocal();
}

DateTime getDateFromYmdHis(String date) {
  return DateFormat("yyyy-MM-dd HH:mm:ss").parse(date);
}

DateTime getNow() {
  // var location = tz.getLocation('Asia/Kuala_Lumpur');
  // var now = tz.TZDateTime.now(location);
  // malaysian time is +8 hours
  return DateTime.now().toUtc().add(const Duration(hours: 8));
}

/// Get local date&time from system
DateTime getCurrentDate() {
  final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  return DateFormat('yyyy-MM-dd').parse(currentDate).toLocal();
}

/// Get local date&time from system
DateTime getCurrentDateAndTime() {
  final currentDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  return DateFormat('yyyy-MM-dd HH:mm:ss').parse(currentDate).toLocal();
}

/// Check the date is After or on the same day
bool checkTheDateIsAfterOrSame(String date) {
  var from = getDateFromYmd(date);
  var now = getCurrentDate();
  return (now.isAfter(from) || now.isAtSameMomentAs(from));
}

/// Check the date is Before or on the same day
bool checkTheDateIsBeforeOrSame(String date) {
  var to = getDateFromYmd(date);
  var now = getCurrentDate();
  return (now.isBefore(to) || now.isAtSameMomentAs(to));
}
