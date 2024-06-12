import 'package:jakel_base/restapi/BaseApi.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';

class HomeScreenViewModel extends BaseViewModel {
  Future<String> packageName() async {
    String sPackageName = await BaseApi().getMasterUrl();
    return sPackageName.split("/")[2].split(".")[0];
  }
}
