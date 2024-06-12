import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../text/HeaderTextWidget.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: HeaderTextWidget(
      text: tr('no_data'),
      color: Theme.of(context).primaryColor,
    ));
  }
}
