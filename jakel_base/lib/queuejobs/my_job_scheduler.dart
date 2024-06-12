import 'dart:collection';
import 'dart:math';

import 'package:async_queue/async_queue.dart';

import '../utils/MyLogUtils.dart';

class MyJobScheduler {
  static final MyJobScheduler _singleton = MyJobScheduler._internal();
  final autoAsyncLogQ = AsyncQueue.autoStart();
  var refreshProductsData = false;

  MyJobScheduler._internal();

  factory MyJobScheduler() {
    return _singleton;
  }

  void addLogUploadJob(LogContent content) {
    try {
      autoAsyncLogQ.addJob(
          label:
              '${content.content}-${DateTime.now().millisecondsSinceEpoch} - ${Random().nextInt(9)}',
          () => MyLogUtils.writeInLogFile(content.content, content.type));
    } catch (e) {
      print("Add Log Job Exception  ${e}");
    }
  }

  void addSaleSyncJob() {}

  void executeJob() {
    autoAsyncLogQ.addQueueListener((event) {
      print(
          "Current Queue Size : ${event.currentQueueSize} & job label : ${event.jobLabel}");
    });
  }
}
