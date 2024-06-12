import 'package:jakel_base/locator.dart';
import 'package:jakel_base/restapi/counters/CountersApi.dart';
import 'package:jakel_base/restapi/counters/model/ClosedCountesrHistoryResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:rxdart/rxdart.dart';

class ClosedCountersHistoryViewModel extends BaseViewModel {
  var responseSubject = PublishSubject<ClosedCountersHistoryResponse>();

  Stream<ClosedCountersHistoryResponse> get responseStream =>
      responseSubject.stream;

  void closeObservable() {
    responseSubject.close();
  }

  void getClosedCountersHistory(int pageNo, int perPage) async {
    var api = locator.get<CountersApi>();

    try {
      var response = await api.getLastThirtyDaysClosedCounters(pageNo, perPage);

      MyLogUtils.logDebug(
          "getClosedCountersHistory response : ${response.toJson()}");

      responseSubject.sink.add(response);
    } catch (e) {
      MyLogUtils.logDebug("getCountersHistory exception $e");
      responseSubject.sink.addError(e);
    }
  }
}
