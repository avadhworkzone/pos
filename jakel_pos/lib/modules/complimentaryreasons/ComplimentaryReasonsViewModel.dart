import 'package:jakel_base/database/complimentaryreason/ComplimentaryReasonLocalApi.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/restapi/complimentaryreason/model/ComplimentaryReasonResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';

class ComplimentaryReasonsViewModel extends BaseViewModel {
  Future<List<ComplimentaryItemReasons>> getAllReasons() async {
    var api = locator.get<ComplimentaryReasonLocalApi>();
    List<ComplimentaryItemReasons> reasons = await api.getAll();
    MyLogUtils.logDebug(" getAllReasons : $reasons");
    return reasons;
  }
}
