import 'package:jakel_base/restapi/priceoverridetypes/model/PriceOverrideTypesResponse.dart';

abstract class PriceOverrideTypesApi {
  Future<PriceOverrideTypesResponse> getPriceOverrideTypes();
}
