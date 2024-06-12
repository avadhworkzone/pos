import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/utils/my_date_utils.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../utils/MyLogUtils.dart';

class SelectDateRangeDialog extends StatefulWidget {
  final Function onDateSelected;

  const SelectDateRangeDialog({Key? key, required this.onDateSelected})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SelectDateRangeState();
  }
}

class _SelectDateRangeState extends State<SelectDateRangeDialog>
    with WidgetsBindingObserver {
  DateTime? startDate;
  DateTime? endDate;
  double boxWidth = 180;

  @override
  void initState() {
    super.initState();
    updateStartAndEndDate(getNow(), null);
    endDate = null;
  }

  void updateStartAndEndDate(DateTime? startWithTime, DateTime? endWithTime) {
    startWithTime ??= getNow();

    startDate = DateTime(
        startWithTime.year, startWithTime.month, startWithTime.day, 0, 0, 0)
        .toLocal();
    if (endWithTime != null) {
      endDate = DateTime(
          endWithTime.year, endWithTime.month, endWithTime.day, 23, 59, 59)
          .toLocal();
    } else {
      endDate = null;
    }
  }

  double height = 0.0;
  double width = 0.0;

  @override
  Widget build(BuildContext context) {
    var deviceType = getDeviceType(MediaQuery
        .of(context)
        .size);
    switch (deviceType) {
      case DeviceScreenType.desktop:
        height = 500;
        width = (MediaQuery
            .of(context)
            .size
            .width * 2) / 3;
        break;
      case DeviceScreenType.tablet:
        height = 500;
        width = (MediaQuery
            .of(context)
            .size
            .width * 2) / 3;
        break;
      case DeviceScreenType.mobile:
        height = (MediaQuery
            .of(context)
            .size
            .height);
        width = (MediaQuery
            .of(context)
            .size
            .width);
        break;
    }
    return Dialog(
      child: Container(
          padding: EdgeInsets.all(10.0),
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: getWhiteColor(context),
            shape: BoxShape.rectangle,
          ),
          child: Column(
            children: [
              getHeaderChild(),
              const Divider(),
              getContentWidget(context),
              const Divider(),
              getBottomButtons()
            ],
          )),
    );
  }

  Widget getContentWidget(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Center(
            child: SfDateRangePicker(
              startRangeSelectionColor: Theme
                  .of(context)
                  .primaryColor
                  .withOpacity(0.2),
              endRangeSelectionColor: Theme
                  .of(context)
                  .primaryColor
                  .withOpacity(0.2),
              selectionColor: Theme
                  .of(context)
                  .primaryColor
                  .withOpacity(0.2),
              selectionTextStyle: TextStyle(
                  fontSize: 13,
                  color: Theme
                      .of(context)
                      .primaryColor),
              onSelectionChanged: _onSelectionChanged,
              selectionMode: DateRangePickerSelectionMode.range,
              initialSelectedRange: PickerDateRange(startDate, endDate),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: Wrap(
              direction: Axis.vertical,
              children: getOrdersChildren(),
            ),
          ),
        )
      ],
    );
  }

  Widget getHeaderChild() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "SELECT DATE",
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyText1,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                icon: Icon(Icons.close),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      MyLogUtils.logDebug("Select Date args.value : ${args.value}");
      if (args.value is List<DateTime>) {
        for (DateTime dateTime in args.value) {
          MyLogUtils.logDebug("Select Date Dialog dateTime : ${dateTime}");
          startDate = dateTime;
          updateStartAndEndDate(startDate, null);
        }
      } else if (args.value is PickerDateRange) {
        MyLogUtils.logDebug("Select Date endDATE : ${args.value.endDate}");
        MyLogUtils.logDebug("Select Date startDate : ${args.value.startDate}");
        updateStartAndEndDate(args.value.startDate, args.value.endDate);
      }
    });
  }

  List<Widget> getOrdersChildren() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(InkWell(
      onTap: () {
        setState(() {
          updateStartAndEndDate(getNow(), null);
          widget.onDateSelected(startDate, endDate, "TODAY");
          Navigator.pop(context);
        });
      },
      hoverColor: Theme
          .of(context)
          .primaryColor
          .withOpacity(0.3),
      child: SizedBox(
          height: 50,
          width: boxWidth,
          child: Card(
            shadowColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 10,
            child: getBigDataBox2("TODAY"),
          )),
    ));
    widgets.add(InkWell(
      onTap: () {
        setState(() {
          DateTime fromDate =
          DateTime(getNow().year, getNow().month, getNow().day - 1, 0, 0, 0)
              .toLocal();
          DateTime toDate = DateTime(
              getNow().year, getNow().month, getNow().day - 1, 23, 59, 59)
              .toLocal();
          updateStartAndEndDate(fromDate, toDate);
          widget.onDateSelected(startDate, endDate, "YESTERDAY");
          Navigator.pop(context);
        });
      },
      hoverColor: Theme
          .of(context)
          .primaryColor
          .withOpacity(0.3),
      child: SizedBox(
          height: 50,
          width: boxWidth,
          child: Card(
            shadowColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 10,
            child: getBigDataBox2("YESTERDAY"),
          )),
    ));

    widgets.add(InkWell(
      onTap: () {
        setState(() {
          DateTime today = getNow();
          DateTime firstDayOfTheWeek =
          today.subtract(Duration(days: today.weekday - 1));

          DateTime fromDate = DateTime(firstDayOfTheWeek.year,
              firstDayOfTheWeek.month, firstDayOfTheWeek.day, 0, 0, 0);
          DateTime toDate = today;
          updateStartAndEndDate(fromDate, toDate);
          widget.onDateSelected(startDate, endDate, "THIS WEEK");
          Navigator.pop(context);
        });
      },
      hoverColor: Theme
          .of(context)
          .primaryColor
          .withOpacity(0.3),
      child: SizedBox(
          height: 50,
          width: boxWidth,
          child: Card(
            shadowColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 40,
            child: getBigDataBox2("THIS WEEK"),
          )),
    ));
    widgets.add(InkWell(
      onTap: () {
        setState(() {
          DateTime today = getNow();
          DateTime firstDayOfTheWeek =
          today.subtract(Duration(days: today.weekday - 1));

          DateTime fromDate = DateTime(firstDayOfTheWeek.year,
              firstDayOfTheWeek.month, firstDayOfTheWeek.day - 7, 0, 0, 0);
          DateTime toDate = DateTime(firstDayOfTheWeek.year,
              firstDayOfTheWeek.month, firstDayOfTheWeek.day - 1, 23, 59, 59);
          updateStartAndEndDate(fromDate, toDate);
          widget.onDateSelected(startDate, endDate, "LAST WEEK");
          Navigator.pop(context);
        });
      },
      hoverColor: Theme
          .of(context)
          .primaryColor
          .withOpacity(0.3),
      child: SizedBox(
          height: 50,
          width: boxWidth,
          child: Card(
            shadowColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 10,
            child: getBigDataBox2("LAST WEEK"),
          )),
    ));
    widgets.add(InkWell(
      onTap: () {
        setState(() {
          DateTime today = getNow();
          DateTime firstDayOfTheMonth =
          DateTime.utc(today.year, today.month, 1);
          DateTime fromDate = DateTime(firstDayOfTheMonth.year,
              firstDayOfTheMonth.month, firstDayOfTheMonth.day, 0, 0, 0);
          DateTime toDate = today;
          updateStartAndEndDate(fromDate, toDate);
          widget.onDateSelected(startDate, endDate, "THIS MONTH");
          Navigator.pop(context);
        });
      },
      hoverColor: Theme
          .of(context)
          .primaryColor
          .withOpacity(0.3),
      child: SizedBox(
          height: 50,
          width: boxWidth,
          child: Card(
            shadowColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 10,
            child: getBigDataBox2("THIS MONTH"),
          )),
    ));
    widgets.add(InkWell(
      onTap: () {
        setState(() {
          DateTime firstDayOfTheMonth =
          DateTime.utc(getNow().year, getNow().month, 1).toLocal();

          DateTime fromDate = DateTime(firstDayOfTheMonth.year,
              firstDayOfTheMonth.month - 1, firstDayOfTheMonth.day, 0, 0, 0);
          DateTime toDate = DateTime(firstDayOfTheMonth.year,
              firstDayOfTheMonth.month, firstDayOfTheMonth.day - 1, 23, 59, 59);
          updateStartAndEndDate(fromDate, toDate);
          widget.onDateSelected(startDate, endDate, "LAST MONTH");
          Navigator.pop(context);
        });
      },
      hoverColor: Theme
          .of(context)
          .primaryColor
          .withOpacity(0.3),
      child: SizedBox(
          height: 50,
          width: boxWidth,
          child: Card(
            shadowColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 10,
            child: InkWell(
              child: getBigDataBox2("LAST MONTH"),
            ),
          )),
    ));
    widgets.add(InkWell(
      onTap: () {
        setState(() {
          DateTime today = getNow();

          DateTime firstDayOfTheMonth =
          DateTime.utc(today.year, today.month, 1);

          DateTime fromDate = DateTime(firstDayOfTheMonth.year,
              firstDayOfTheMonth.month - 3, firstDayOfTheMonth.day, 0, 0, 0);
          DateTime toDate = today;
          updateStartAndEndDate(fromDate, toDate);
          widget.onDateSelected(startDate, endDate, "LAST 3 MONTHS");
          Navigator.pop(context);
        });
      },
      hoverColor: Theme
          .of(context)
          .primaryColor
          .withOpacity(0.3),
      child: SizedBox(
          height: 50,
          width: 180,
          child: Card(
            shadowColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 10,
            child: getBigDataBox2("LAST 3 MONTHS"),
          )),
    ));
    return widgets;
  }

  Widget getBigDataBox2(String title) {
    return Align(
        alignment: Alignment.center,
        child: Padding(
          padding:
          EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
          child: Text(title, style: Theme
              .of(context)
              .textTheme
              .bodyMedium),
        ));
  }

  Widget getBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IntrinsicWidth(
          child: IntrinsicHeight(
            child: InkWell(
              hoverColor: Theme
                  .of(context)
                  .primaryColor
                  .withOpacity(0.3),
              onTap: () {
                setState(() {
                  widget.onDateSelected(startDate, endDate, null);
                  Navigator.pop(context);
                });
              },
              child: Center(
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 45.0, right: 45.0, top: 15.0, bottom: 15.0),
                    child: Text("UPDATE",
                        style: TextStyle(
                          color: Theme
                              .of(context)
                              .primaryColor,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
              ),
            ),
          ),
        ),
        IntrinsicWidth(
            child: IntrinsicHeight(
              child: InkWell(
                hoverColor: Theme
                    .of(context)
                    .primaryColor
                    .withOpacity(0.3),
                onTap: () {
                  setState(() {
                    widget.onDateSelected(null, null, null);
                    Navigator.pop(context);
                  });
                },
                child: Center(
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 45.0, right: 45.0, top: 15.0, bottom: 15.0),
                      child: Text("CLEAR DATE FILTER",
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                ),
              ),

            ))
      ],
    );
  }
}
