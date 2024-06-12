import 'package:flutter/material.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../utils/MyLogUtils.dart';

class SelectDateDialog extends StatefulWidget {
  final Function onDateSelected;

  const SelectDateDialog({Key? key, required this.onDateSelected})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SelectDateState();
  }
}

class _SelectDateState extends State<SelectDateDialog>
    with WidgetsBindingObserver {
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    updateStartAndEndDate(DateTime.now(), null);
    endDate = null;
  }

  void updateStartAndEndDate(DateTime? startWithTime, DateTime? endWithTime) {
    startWithTime ??= DateTime.now();
    startDate = DateTime(
        startWithTime.year, startWithTime.month, startWithTime.day, 0, 0, 0);
    if (endWithTime != null) {
      endDate = DateTime(
          endWithTime.year, endWithTime.month, endWithTime.day, 23, 59, 59);
    } else {
      endDate = null;
    }
  }

  double height = 0.0;
  double width = 0.0;

  @override
  Widget build(BuildContext context) {
    var deviceType = getDeviceType(MediaQuery.of(context).size);
    switch (deviceType) {
      case DeviceScreenType.desktop:
        height = (MediaQuery.of(context).size.height * 2) / 3;
        width = (MediaQuery.of(context).size.width * 2) / 3;
        break;
      case DeviceScreenType.tablet:
        height = (MediaQuery.of(context).size.height * 2) / 3;
        width = (MediaQuery.of(context).size.width * 2) / 3;
        break;
      case DeviceScreenType.mobile:
        height = (MediaQuery.of(context).size.height);
        width = (MediaQuery.of(context).size.width);
        break;
    }
    return Dialog(
      child: Container(
          height: height,
          width: width,
          padding: EdgeInsets.all(10.0),
          decoration: new BoxDecoration(
            color: getWhiteColor(context),
            shape: BoxShape.rectangle,
          ),
          child: Column(
            children: [
              getChild0(),
              Center(
                child: SfDateRangePicker(
                  onSelectionChanged: _onSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.single,
                  initialSelectedRange: PickerDateRange(startDate, endDate),
                ),
              ),
              getBottomButtons()
            ],
          )),
    );
  }

  Widget getChild0() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(),
              Text(
                "SELECT DATE OF BIRTH",
                style: Theme.of(context).textTheme.bodyMedium,
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
      updateStartAndEndDate(args.value, null);
    });
  }

  Widget getBottomButtons() {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: IntrinsicWidth(
              child: IntrinsicHeight(
                child: InkWell(
                  hoverColor: Theme.of(context).primaryColor.withOpacity(0.5),
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
                        padding: EdgeInsets.only(
                            left: 45.0, right: 45.0, top: 15.0, bottom: 15.0),
                        child: Text("DONE",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                  ),
                ),
              ),
            ))
      ],
    );
  }
}
