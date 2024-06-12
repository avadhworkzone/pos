import 'dart:io';
import 'package:async_queue/async_queue.dart';
import 'package:jakel_base/utils/my_date_utils.dart';
import 'package:jakel_base/queuejobs/my_job_scheduler.dart';
import 'package:path_provider/path_provider.dart';

enum LogType { MBB, SALE_MISMATCH, NETWORK_ERRORS, MBB_PAYSYS }

class LogContent {
  final String content;
  final LogType? type;

  LogContent(this.content, this.type);
}

class MyLogUtils {
  static void logDebug(String message, {LogType? type}) {
    print(message);
    MyJobScheduler().addLogUploadJob(LogContent(message, type));
  }

  static void logSaleMismatch(String message) {
    print('[SaleMismatch] $message');
    MyJobScheduler().addLogUploadJob(LogContent(message, LogType.SALE_MISMATCH));
    // writeInLogFile(message, LogType.SALE_MISMATCH);
  }

  static Future<void> writeInLogFile(String message, LogType? type) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    var fileName = '${directory.path}/pos-log/${todayDateYmd()}';

    if (type == LogType.MBB) {
      fileName = '${directory.path}/pos-log/mbb-${todayDateYmd()}';
    }
    if (type == LogType.MBB_PAYSYS) {
      fileName = '${directory.path}/pos-log/mbb-paysys-${todayDateYmd()}';
    }
    if (type == LogType.SALE_MISMATCH) {
      fileName = '${directory.path}/pos-log/sale-mismatch-${todayDateYmd()}';
    }

    if (type == LogType.NETWORK_ERRORS) {
      fileName = '${directory.path}/pos-log/network-errors-${todayDateYmd()}';
    }

    final File file = File(fileName);
    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    await file.writeAsString('\n [${dateTimeYmdHisMillis24Hour()}] - $message \n',
        mode: FileMode.append);
    await file.writeAsString(
        "---------------------------------------------------------------------",
        mode: FileMode.append);
  }
}
