import 'package:flutter/material.dart';

import '../../theme/colors/my_colors.dart';

class MyTextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode node;
  final String hint;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextAlign? textAlign;
  final bool? obscureText;
  final bool? enabled;

  const MyTextFieldWidget(
      {Key? key,
      required this.controller,
      required this.node,
      required this.hint,
      this.keyboardType = TextInputType.text,
      this.textAlign = TextAlign.start,
      this.onChanged,
      this.enabled = true,
      this.obscureText = false,
      this.onSubmitted})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyTextFieldState();
  }
}

class _MyTextFieldState extends State<MyTextFieldWidget> {
  late Color primaryColor;

  @override
  Widget build(BuildContext context) {
    primaryColor = getPrimaryColor(context);
    return TextField(
      controller: widget.controller,
      focusNode: widget.node,
      textAlign: widget.textAlign == null ? TextAlign.start : widget.textAlign!,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText!,
      enabled: widget.enabled,
      style: Theme.of(context).textTheme.bodySmall,
      decoration: InputDecoration(
        label: Text(
          widget.hint,
          style: Theme.of(context).textTheme.caption,
        ),
        contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        filled: true,
        fillColor: getWhiteColor(context),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: primaryColor.withOpacity(0.6), width: 1),
        ),
        hintText: widget.hint,
        hintStyle: Theme.of(context).textTheme.caption,
      ),
    );
  }
}
