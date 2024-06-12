import 'package:jakel_base/database/directors/DirectorsLocalApi.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/restapi/directors/model/DirectorsResponse.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';

class DirectorsViewModel extends BaseViewModel {
  Future<List<Directors>> getAllDirectors() async {
    var api = locator.get<DirectorsLocalApi>();
    List<Directors> directors = await api.getAll();
    return directors;
  }

  Future<Directors?> getDirector(String password, String staffId) async {
    List<Directors> allDirectors = await getAllDirectors();
    for (var value in allDirectors) {
      if (value.passcode == password && value.staffId == staffId) {
        return value;
      }
    }
    throw Exception("");
  }
}
