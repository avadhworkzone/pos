

import 'dart:async';

import 'package:flutter/material.dart';

focusSocpeNext(BuildContext context,FocusNode next){
  Timer(const Duration(milliseconds: 35), () {
    FocusScope.of(context).requestFocus(next);
  });
}