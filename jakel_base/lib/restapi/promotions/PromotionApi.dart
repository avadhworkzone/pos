import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';

abstract class PromotionApi {
  Future<PromotionsResponse> getPromotions();
}
