import 'package:jakel_base/locator.dart';
import 'package:jakel_base/serialportdevices/model/MayBankPaymentDetails.dart';
import 'package:jakel_base/serialportdevices/service/may_bank_terminal_service.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:rxdart/rxdart.dart';

class MbbViewModel extends BaseViewModel {
  var mbbResponseSubject = PublishSubject<MayBankPaymentDetails?>();

  Stream<MayBankPaymentDetails?> get mbbResponseStream =>
      mbbResponseSubject.stream;

  void closeObservable() {
    mbbResponseSubject.close();
  }

  void triggerPaymentTerminalAsync(
      double amount, bool triggerMayBankCard, bool triggerMayBankQrCode) async {
    MyLogUtils.logDebug(
        type: LogType.MBB, "triggerPaymentTerminalAsync started");
    var service = locator.get<MayBankTerminalService>();

    service
        .requestPaymentAsync(amount, triggerMayBankCard, triggerMayBankQrCode,
            (MayBankPaymentDetails? data) {
      MyLogUtils.logDebug(
          type: LogType.MBB,
          "triggerPaymentTerminalAsync on Process completed");

      MyLogUtils.logDebug(type: LogType.MBB, "${data?.toJson()}");

      mbbResponseSubject.sink.add(data);
    });
  }

  Future<bool> closeThePort() async {
    var service = locator.get<MayBankTerminalService>();
    return await service.closeThePort();
  }
}
