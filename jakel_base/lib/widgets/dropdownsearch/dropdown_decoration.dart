import 'package:flutter/material.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';

InputDecoration getDecoration(BuildContext context) {
  final primaryColor = getPrimaryColor(context);

  return InputDecoration(
      labelText: "Reason",
      hintText: "Select reason",
      hintStyle: Theme.of(context).textTheme.caption,
      labelStyle: Theme.of(context).textTheme.caption,
      border: OutlineInputBorder(
        borderSide:
            BorderSide(color: primaryColor.withOpacity(0.6), width: 0.3),
      ));
}
