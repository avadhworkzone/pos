import 'dart:io';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';

class MyVideoPlayerViewModel extends BaseViewModel {
  Future<File> getVideoFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    var fileName = '${directory.path}/pos-data/pos_advertiserment_1.mp4';
    MyLogUtils.logDebug("getVideoFile fileName : $fileName");
    return File(fileName);
  }
}
