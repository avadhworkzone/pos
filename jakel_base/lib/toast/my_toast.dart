import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

void showToast(String message, BuildContext context) {
  //BotToast.showText(text: message);
  BotToast.showSimpleNotification(
      backgroundColor: Colors.indigo,
      title: message,
      duration: const Duration(seconds: 4),
      subTitle: "",
      titleStyle: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white));
}

void showWarning(String message, BuildContext context) {
  BotToast.showText(text: message, duration: const Duration(seconds: 10));
}

void showError(String message, BuildContext context) {
  BotToast.showText(text: message, duration: const Duration(seconds: 10));
}

void showSuccess(String message, BuildContext context) {
  BotToast.showText(text: message, duration: const Duration(seconds: 10));
}

void showInfo(String message, BuildContext context) {
  BotToast.showText(text: message, duration: const Duration(seconds: 10));
}
