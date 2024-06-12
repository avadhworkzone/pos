import 'package:jakel_base/locator.dart';
import 'package:jakel_base/restapi/pettycash/PettyCashApi.dart';
import 'package:jakel_base/restapi/pettycash/model/PettyCashUsageResponse.dart';
import 'package:jakel_base/restapi/pettycash/model/PettyCashUsagesResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:rxdart/rxdart.dart';

class PettyCashViewModel extends BaseViewModel {
  var responseSubject = PublishSubject<bool>();

  Stream<bool> get responseStream => responseSubject.stream;

  var usageResponseSubject = PublishSubject<PettyCashUsagesResponse>();

  Stream<PettyCashUsagesResponse> get usageResponseStream =>
      usageResponseSubject.stream;

  void getPettyCashUsages(int pageNo, int perPage) async {
    var api = locator.get<PettyCashApi>();

    try {
      var response = await api.getPettyCashUsages(pageNo, perPage, true);
      usageResponseSubject.sink.add(response);
    } catch (e) {
      MyLogUtils.logDebug("getPettyCashUsages exception $e");
      usageResponseSubject.sink.addError(e);
    }
  }

  void closeObservable() {
    responseSubject.close();
  }

  void savePettyCashUsage(int reasonId, double amount) async {
    var api = locator.get<PettyCashApi>();

    try {
      var response = await api.savePettyCash(reasonId, amount);
      responseSubject.sink.add(response);
    } catch (e) {
      MyLogUtils.logDebug("savePettyCashUsage exception $e");
      responseSubject.sink.addError(e);
    }
  }

  Future<List<PettyCashUsageReasons>> getPettyCashReasons() async {
    var api = locator.get<PettyCashApi>();
    var response = await api.getPettyCashUsageReasons();
    List<PettyCashUsageReasons> filtered = List.empty(growable: true);

    response.pettyCashUsageReasons?.forEach((element) {
      if (element.id != 1) {
        filtered.add(element);
      }
    });

    return filtered;
  }
}
