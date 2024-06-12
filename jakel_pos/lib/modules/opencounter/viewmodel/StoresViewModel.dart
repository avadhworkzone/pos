import 'package:flutter/widgets.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/logs/MyLogs.dart';
import 'package:jakel_base/restapi/counters/CountersApi.dart';
import 'package:jakel_base/restapi/counters/model/GetStoresResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:rxdart/rxdart.dart';

import '../ui/open_counter_in_herited_widget.dart';

class StoresViewModel extends BaseViewModel {
  var responseSubject = PublishSubject<List<Stores>>();

  Stream<List<Stores>> get responseStream => responseSubject.stream;

  void closeObservable() {
    responseSubject.close();
  }

  void getStores() async {
    var logsApi = locator.get<MyLogs>();
    var api = locator.get<CountersApi>();

    try {
      var response = await api.getStores();
      if (response.stores != null) {
        responseSubject.sink.add(response.stores!);
      }
    } catch (e) {
      responseSubject.sink.addError(e);
      logsApi.error("Get Stores Api Error: ", e.toString());
    }
  }

  bool isStoreSelected(BuildContext context, Stores? store) {
    if (store == null) {
      return false;
    }
    return (OpenCounterInHeritedWidget.of(context).object.store != null &&
        store.id == OpenCounterInHeritedWidget.of(context).object.store!.id);
  }
}
