import 'package:jakel_base/restapi/takebreak/model/TakeBreakRequest.dart';

abstract class TakeBreakApi {
  Future<bool> takeBreak(TakeBreakRequest takeBreakRequest);
}
