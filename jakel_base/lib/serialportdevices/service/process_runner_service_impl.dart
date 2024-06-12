import 'package:jakel_base/serialportdevices/service/process_runner_service.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:process_run/shell.dart';

class ProcessRunnerServiceImpl with ProcessRunnerService {
  final tag = 'ProcessRunnerService';

  @override
  Future<bool> execute(String message) async {
    var shell = Shell();
    MyLogUtils.logDebug("$tag execute : $message");
    var result = await shell.run('''$message''');
    MyLogUtils.logDebug("$tag result  :$result for command : $message");
    return true;
  }
}
