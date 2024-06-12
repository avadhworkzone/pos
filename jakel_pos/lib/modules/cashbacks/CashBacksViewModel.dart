import 'package:jakel_base/database/cashbacks/CashBacksLocalApi.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/restapi/cashbacks/model/CashbacksResponse.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';

class CashBacksViewModel extends BaseViewModel {
  Future<List<Cashbacks>> getAllCashBacks() async {
    var api = locator.get<CashBacksLocalApi>();
    List<Cashbacks> cashBacks = await api.getAll();
    return cashBacks;
  }
}
