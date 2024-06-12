import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/loyaltycampaigns/model/LoyaltyCampaignsResponse.dart';

mixin LoyaltyCampaignsService {

  /// Apply this loyalty campaigns to the cart
  CartSummary applyLoyaltyCampaigns(CartSummary cartSummary, List<LoyaltyCampaigns> loyaltyCampaigns);

}
