import 'package:jakel_base/database/loyaltycampaigns/LoyaltyCampaignsLocalApi.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/restapi/loyaltycampaigns/model/LoyaltyCampaignsResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:jakel_pos/modules/app_locator.dart';
import 'package:jakel_pos/modules/loyaltycampaigns/validate/loyalty_campaigns_service.dart';

class LoyaltyCampaignsViewModel extends BaseViewModel {
  ///Get valid loyalty configs to cart
  Future<CartSummary> getValidLoyaltyCampaignsToCart(
      CartSummary cartSummary) async {
    List<LoyaltyCampaigns> allLoyaltyPoints = await getAllLoyaltyPointsFromDB();

    try {
      var api = appLocator.get<LoyaltyCampaignsService>();

      CartSummary returnCartSummary =
          api.applyLoyaltyCampaigns(cartSummary, allLoyaltyPoints);

      return returnCartSummary;
    } catch (e) {
      MyLogUtils.logDebug("getValidLoyalty Campaigns exception $e");
    }

    return cartSummary;
  }

  ///Get all loyalty configs from local
  Future<List<LoyaltyCampaigns>> getAllLoyaltyPointsFromDB() async {
    var api = locator.get<LoyaltyCampaignsLocalApi>();
    List<LoyaltyCampaigns> loyaltyCampaigns = await api.getAll();
    return loyaltyCampaigns;
  }
}
