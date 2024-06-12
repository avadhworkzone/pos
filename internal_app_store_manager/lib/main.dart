import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:internal_base/data/remote/web_http_overrides.dart';
import 'modules/app/view/member_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = WebHttpOverrides();
  runApp(const MemberApp());
}


