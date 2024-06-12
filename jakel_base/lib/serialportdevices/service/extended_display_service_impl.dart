import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/serialportdevices/service/extended_display_service.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:path_provider/path_provider.dart';

class ExtendedDisplayServiceImpl with ExtendedDisplayService {
  final tag = 'ExtendedDisplayService';

  Future<List<String>> getMediaFiles() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    var adsDirectoryPath = '${directory.path}/pos-advertisement/';

    Directory adsDirectory = Directory(adsDirectoryPath);

    List<String> mediaFiles = List.empty(growable: true);
    if (adsDirectory.existsSync()) {
      List<FileSystemEntity> fileSystemEntity = adsDirectory.listSync();
      for (var element in fileSystemEntity) {
        if (element.path.contains("png") ||
            element.path.contains("jpg") ||
            element.path.contains("jpeg") ||
            element.path.contains("mp4") ||
            element.path.contains("gif")) {
          mediaFiles.add(element.path);
        }
      }
    }

    MyLogUtils.logDebug("getMedia File adsDirectory : $adsDirectory");
    return mediaFiles;
  }

  @override
  Future<bool> createNewWindow() async {
    final window = await DesktopMultiWindow.createWindow(jsonEncode({
      'args1': 'Customer Display',
      'args2': 100,
      'args3': true,
      'business': 'business_test',
      'media_files': await getMediaFiles(),
    }));
    window
      ..setFrame(const Offset(0, 0) & const Size(800, 600))
      ..center()
      ..setTitle('Customer Display')
      ..show();
    return true;
  }

  @override
  Future<bool> notifyCartUpdate(CartSummary cartSummary) async {
    final subWindowIds = await DesktopMultiWindow.getAllSubWindowIds();
    for (final windowId in subWindowIds) {
      MyLogUtils.logDebug("notifyCartUpdate to windowId : $windowId");
      DesktopMultiWindow.invokeMethod(
          windowId, 'broadcast', cartSummary.toJson());
    }
    return true;
  }
}
