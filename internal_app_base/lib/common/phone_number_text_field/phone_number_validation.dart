import 'package:flutter/material.dart';
import 'package:internal_base/common/color_constants.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

phoneNumberTextField() {
  GlobalKey<FormState> _formKey = GlobalKey();
  FocusNode focusNode = FocusNode();
  return Form(
    key: _formKey,
    child: IntlPhoneField(
      focusNode: focusNode,
      decoration: const InputDecoration(
        labelText: 'Phone Number',
        border: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
      ),
      languageCode: "en",
      onChanged: (phone) {
        print(phone.completeNumber);
      },
      onCountryChanged: (country) {
        print('Country changed to: ${country.name}');
      },
    ),
  );
}
