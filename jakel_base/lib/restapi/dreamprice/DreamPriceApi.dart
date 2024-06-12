import 'package:jakel_base/restapi/dreamprice/model/DreamPriceResponse.dart';

abstract class DreamPriceApi {
  Future<DreamPriceResponse> getDreamPrice();
}
