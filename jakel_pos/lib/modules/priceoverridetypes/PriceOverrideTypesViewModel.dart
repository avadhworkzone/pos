import 'package:jakel_base/database/priceoverridetypes/PriceOverrideTypesLocalApi.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/restapi/priceoverridetypes/model/PriceOverrideTypesResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';

class PriceOverrideTypesViewModel extends BaseViewModel {
  List<PriceOverrideTypes> priceOverrideTypes=[];

  Future<List<PriceOverrideTypes>> getAllTypes() async {
    var api = locator.get<PriceOverrideTypesLocalApi>();
    List<PriceOverrideTypes> types = await api.getAll();
    MyLogUtils.logDebug(" getAll Price override types : $types");
    return types;
  }

}
