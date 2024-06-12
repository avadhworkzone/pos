import 'package:jakel_base/database/dreamprice/DreamPriceLocalApi.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/restapi/dreamprice/model/DreamPriceResponse.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';

class DreamPricesViewModel extends BaseViewModel {
  Future<List<DreamPrices>> getDreamPrices() async {
    var api = locator.get<DreamPriceLocalApi>();
    List<DreamPrices> dreamPrices = await api.getAll();
    return dreamPrices;
  }
}
