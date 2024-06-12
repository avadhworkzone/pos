import '../model/MayBankPaymentDetails.dart';

mixin MayBankTerminalService {
  void requestPaymentAsync(double amount, bool triggerMayBankCard,
      bool triggerMayBankQrCode, Function onProcessCompleted);

  Future<bool> echoTerminalTest();

  Future<bool> initDevice();

  Future<bool> closeThePort();
}
