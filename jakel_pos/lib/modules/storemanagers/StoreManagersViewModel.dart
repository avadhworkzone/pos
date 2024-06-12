import 'package:jakel_base/database/storemanagers/StoreManagersLocalApi.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/restapi/managers/model/StoreManagersResponse.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';

class StoreManagersViewModel extends BaseViewModel {
  Future<List<StoreManagers>> getAllStoreManagers() async {
    var api = locator.get<StoreManagersLocalApi>();
    List<StoreManagers> directors = await api.getAll();
    return directors;
  }

  Future<StoreManagers?> getStoreManager(
      String password, String employeeId) async {
    List<StoreManagers> allManagers = await getAllStoreManagers();
    for (var value in allManagers) {
      if (value.passcode == password && value.staffId == employeeId) {
        return value;
      }
    }
    throw Exception("");
  }

  StoreManagers? filterStoreManager(
    List<StoreManagers> allManagers,
    String? employeeId,
    String? password,
  ) {
    for (var value in allManagers) {
      if (value.passcode == password && value.staffId == employeeId) {
        return value;
      }
    }
    return null;
  }
}
