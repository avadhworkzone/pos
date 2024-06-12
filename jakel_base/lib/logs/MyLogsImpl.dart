import 'package:jakel_base/logs/MyLogs.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';

class MyLogsImpl extends MyLogs {
  @override
  error(String tag, String? message) async {
    var messageValue = '[error][$tag]-$message';
    MyLogUtils.logDebug(messageValue);
    return true;
  }

  @override
  info(String tag, String? message) async {
    MyLogUtils.logDebug('[info][$tag]-$message');
    return true;
  }

  @override
  warning(String tag, String? message) async {
    MyLogUtils.logDebug('[warning][$tag]-$message');
    return true;
  }

  @override
  Future<bool> exception(Exception? exception) async {
    return true;
  }

  @override
  Future<bool> logNetworkError(
      String? url, dynamic request, dynamic response, int? responseCode) async {
    MyLogUtils.logDebug(
        "Url : $url , status code: $responseCode & response :$response",
        type: LogType.NETWORK_ERRORS);

    return true;
  }
}
