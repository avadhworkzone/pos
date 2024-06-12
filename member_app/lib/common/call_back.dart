import 'package:flutter/material.dart';
import 'package:member_app/modules/home/my_card/view/my_card_screen.dart';
import 'package:member_app/modules/home/my_profile/view/my_profile_screen.dart';
import 'package:member_app/modules/home/reward/view/reward_screen.dart';

class CallbackModel {
  final ValueChanged<dynamic> returnValueChanged;
  dynamic sValue ;
  List<dynamic> levyArrearsVOList = [];
  CallbackModel(this.returnValueChanged);
}