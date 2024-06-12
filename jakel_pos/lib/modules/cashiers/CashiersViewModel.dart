import 'package:jakel_base/database/cashiers/CashiersLocalApi.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/restapi/cashiers/model/CashiersResponse.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';

class CashiersViewModel extends BaseViewModel {
  Future<List<Cashiers>> getAllCashiers() async {
    var api = locator.get<CashiersLocalApi>();
    return await api.getAll();
  }
}
