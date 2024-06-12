import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:internal_base/common/color_constants.dart';

getCalendarDatePicker2(BuildContext context) {
  const dayTextStyle =
      TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
  final weekendTextStyle = TextStyle(
      color: ColorConstants.kPrimaryColor[400], fontWeight: FontWeight.w700);
  final anniversaryTextStyle = TextStyle(
    color: Colors.red[400],
    fontWeight: FontWeight.w700,
    decoration: TextDecoration.underline,
  );
  final config = CalendarDatePicker2WithActionButtonsConfig(
    dayTextStyle: dayTextStyle,
    calendarType: CalendarDatePicker2Type.range,
    selectedDayHighlightColor: ColorConstants.cOutOfStockTextColor,
    closeDialogOnCancelTapped: true,
    firstDayOfWeek: 1,
    weekdayLabelTextStyle: const TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.bold,
    ),
    controlsTextStyle: const TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    ),
    centerAlignModePicker: true,
    customModePickerIcon: const SizedBox(),
    selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
    dayTextStylePredicate: ({required date}) {
      TextStyle? textStyle;
      if (date.weekday == DateTime.saturday ||
          date.weekday == DateTime.sunday) {
        textStyle = weekendTextStyle;
      }
      // if (DateUtils.isSameDay(date, DateTime(2023, 6, 25))) {
      //   textStyle = anniversaryTextStyle;
      // }
      return textStyle;
    },
    dayBuilder: ({
      required date,
      textStyle,
      decoration,
      isSelected,
      isDisabled,
      isToday,
    }) {
      Widget? dayWidget;
      if (date.day % 3 == 0 && date.day % 9 != 0) {
        dayWidget = Container(
          decoration: decoration,
          child: Center(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Text(
                  MaterialLocalizations.of(context).formatDecimal(date.day),
                  style: textStyle,
                ),
              ],
            ),
          ),
        );
      }
      return dayWidget;
    },
    yearBuilder: ({
      required year,
      decoration,
      isCurrentYear,
      isDisabled,
      isSelected,
      textStyle,
    }) {
      return Center(
        child: Container(
          decoration: decoration,
          height: 36,
          width: 72,
          child: Center(
            child: Semantics(
              selected: isSelected,
              button: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    year.toString(),
                    style: textStyle,
                  ),
                  if (isCurrentYear == true)
                    Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(left: 5),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.redAccent,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );

  return config;
}

getCalendarDatePickerSingle(BuildContext context) {
  const dayTextStyle =
  TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
  final weekendTextStyle = TextStyle(
      color: ColorConstants.kPrimaryColor[400], fontWeight: FontWeight.w700);
  final anniversaryTextStyle = TextStyle(
    color: Colors.red[400],
    fontWeight: FontWeight.w700,
    decoration: TextDecoration.underline,
  );
  final config = CalendarDatePicker2WithActionButtonsConfig(
    dayTextStyle: dayTextStyle,
    calendarType: CalendarDatePicker2Type.single,
    selectedDayHighlightColor: ColorConstants.cOutOfStockTextColor,
    closeDialogOnCancelTapped: true,
    firstDayOfWeek: 1,
    weekdayLabelTextStyle: const TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.bold,
    ),
    controlsTextStyle: const TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    ),
    centerAlignModePicker: true,
    customModePickerIcon: const SizedBox(),
    selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
    dayTextStylePredicate: ({required date}) {
      TextStyle? textStyle;
      if (date.weekday == DateTime.saturday ||
          date.weekday == DateTime.sunday) {
        textStyle = weekendTextStyle;
      }
      // if (DateUtils.isSameDay(date, DateTime(2023, 6, 25))) {
      //   textStyle = anniversaryTextStyle;
      // }
      return textStyle;
    },
    dayBuilder: ({
      required date,
      textStyle,
      decoration,
      isSelected,
      isDisabled,
      isToday,
    }) {
      Widget? dayWidget;
      if (date.day % 3 == 0 && date.day % 9 != 0) {
        dayWidget = Container(
          decoration: decoration,
          child: Center(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Text(
                  MaterialLocalizations.of(context).formatDecimal(date.day),
                  style: textStyle,
                ),
              ],
            ),
          ),
        );
      }
      return dayWidget;
    },
    yearBuilder: ({
      required year,
      decoration,
      isCurrentYear,
      isDisabled,
      isSelected,
      textStyle,
    }) {
      return Center(
        child: Container(
          decoration: decoration,
          height: 36,
          width: 72,
          child: Center(
            child: Semantics(
              selected: isSelected,
              button: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    year.toString(),
                    style: textStyle,
                  ),
                  if (isCurrentYear == true)
                    Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(left: 5),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.redAccent,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );

  return config;
}

List<String> getValueText(
  CalendarDatePicker2Type datePickerType,
  List<DateTime?> values,
) {
  List<String> sentValue = [];
  if (values.isEmpty) {
    return sentValue;
  }
  values = values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
  // var valueText = (values.isNotEmpty ? values[0] : "")
  //     .toString()
  //     .replaceAll('00:00:00.000', '');
  if (datePickerType == CalendarDatePicker2Type.single) {
    final startDate = (values.isNotEmpty ? values[0] : "")
        .toString()
        .replaceAll('00:00:00.000', '');
    sentValue.add(startDate);
    // valueText = '$startDate';
  } else if (datePickerType == CalendarDatePicker2Type.multi) {
    // valueText = values.isNotEmpty
    //     ? values
    //     .map((v) => v.toString().replaceAll('00:00:00.000', ''))
    //     .join(', ')
    //     : 'null';
  } else if (datePickerType == CalendarDatePicker2Type.range) {
    if (values.isNotEmpty) {
      final startDate = values[0].toString().replaceAll('00:00:00.000', '');
      final endDate = values.length > 1
          ? values[1].toString().replaceAll('00:00:00.000', '')
          : 'null';
      sentValue.add(startDate);
      sentValue.add(endDate);
      //  valueText = '$startDate to $endDate';
    } else {
      return sentValue;
    }
  }

  return sentValue;
}
