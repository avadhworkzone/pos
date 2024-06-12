import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/loyaltycampaigns/model/LoyaltyCampaignsResponse.dart';
import 'package:jakel_base/restapi/sales/model/UpdateLoyaltyPointsRequest.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/my_date_utils.dart';
import 'package:jakel_pos/modules/loyaltycampaigns/validate/loyalty_campaigns_service.dart';

class LoyaltyCampaignsServiceImpl with LoyaltyCampaignsService {
  @override
  CartSummary applyLoyaltyCampaigns(
      CartSummary cartSummary, List<LoyaltyCampaigns> loyaltyCampaigns) {
    // int totalEarnedLoyaltyPoints = 0;
    List<LoyaltyPoints> appliedLoyaltyConfigs = [];

    MyLogUtils.logDebug(
        "customer adding before ${cartSummary.customers?.email}");

    if (cartSummary.customers == null) {
      return cartSummary;
    }

    MyLogUtils.logDebug("customer adding after");

    for (var eachLoyaltyCampaign
        in getValidLoyaltyCampaigns(loyaltyCampaigns)) {
      int eachConfigLoyaltyPts = 0;

      cartSummary.cartItems?.forEach((element) {
        if (!itemBrandIsExcluded(eachLoyaltyCampaign, element)) {
          var minSpendAmount = eachLoyaltyCampaign.minimumSpendAmount ?? 0.0;
          var productPrice = element.cartItemPrice?.totalAmount ?? 0;
          var earnedPts = (productPrice ~/ minSpendAmount);
          eachConfigLoyaltyPts = eachConfigLoyaltyPts + earnedPts;
        }
      });
      appliedLoyaltyConfigs.add(appliedLoyaltyCampaign(
          eachLoyaltyCampaign, eachConfigLoyaltyPts, cartSummary));

      // totalEarnedLoyaltyPoints =
      //     totalEarnedLoyaltyPoints + eachConfigLoyaltyPts;
    }
    // cartSummary.totalLoyaltyPoints = totalEarnedLoyaltyPoints;
    cartSummary.loyaltyPoints = appliedLoyaltyConfigs;

    return cartSummary;
  }

  ///get valid loyalty campaigns
  List<LoyaltyCampaigns> getValidLoyaltyCampaigns(
      List<LoyaltyCampaigns> loyaltyCampaigns) {
    Iterable<LoyaltyCampaigns> validLoyaltyCampaigns =
        loyaltyCampaigns.where((element) {
      return checkIsValidDate(element.startDate, element.endDate);
    });

    return List.from(validLoyaltyCampaigns);
  }

  ///Check item brand is excluded or not
  bool itemBrandIsExcluded(
      LoyaltyCampaigns loyaltyCampaigns, CartItem eachItem) {
    return (loyaltyCampaigns.excludedBrands
            ?.map((item) => item.id)
            .contains(eachItem.product?.brand?.id)) ??
        false;
  }

  ///Applied loyalty points to the cart
  LoyaltyPoints appliedLoyaltyCampaign(LoyaltyCampaigns loyaltyCampaigns,
      int eachLoyaltyConfigPts, CartSummary cartSummary) {
    return LoyaltyPoints(
        loyaltyCampaignID: loyaltyCampaigns.id,
        minSpendAmount: loyaltyCampaigns.minimumSpendAmount,
        points: eachLoyaltyConfigPts,
        expiredAt: loyaltyPointsExpiredDate(cartSummary));
  }

  ///Get expire date of the loyalty config
  String? loyaltyPointsExpiredDate(CartSummary cartSummary) {
    return addDaysToDate(
        cartSummary.companyConfiguration?.loyaltyPointExpirationDays ?? 0);
  }
}
