import 'dart:math';

import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/sales/model/NewSaleRequest.dart';
import 'package:jakel_base/restapi/vouchers/model/VoucherConfigurationResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/my_date_utils.dart';
import 'package:jakel_pos/modules/vouchers/validate/base_voucher_config.dart';
import 'package:jakel_pos/modules/vouchers/validate/voucher_config_service_impl.dart';

import '../voucher_helper.dart';

class VcTierCustomerFlatMultiple with BaseVoucherConfig {
  final tag = "VcTierCustomerFlatMultiple";

  @override
  String title() {
    return "Multiple Restricted By All Percentage Voucher";
  }

  @override
  String description() {
    return "Vouchers are issued in multiples as per the purchase amount. "
        "Ex: Minimum spend amount is RM100 and if a customer spends RM200, he/she will get two vouchers.";
  }

  @override
  bool isValidForThisCart(
      CartSummary cartSummary, VoucherConfiguration voucherConfiguration) {
    if (!isBasicValidationPassed(cartSummary)) {
      return false;
    }

    // Customer should be linked
    if (cartSummary.customers == null) {
      return false;
    }

    //Start & End date should be valid
    if (!checkIsValidDate(
        voucherConfiguration.startDate, voucherConfiguration.endDate)) {
      return false;
    }

    var tier = _getTier(getTotalForVoucherGenerationValidation(cartSummary),
        voucherConfiguration);

    return tier.isNotEmpty;
  }

  @override
  double getVoucherAmount(
      CartSummary cartSummary, VoucherConfiguration voucherConfiguration) {
    if (isValidForThisCart(cartSummary, voucherConfiguration)) {
      var tier = _getTier(getTotalForVoucherGenerationValidation(cartSummary),
          voucherConfiguration);

      var total = 0.0;
      for (var element in tier) {
        total = total + (element.flatAmount ?? 0);
      }
      return total;
    }

    return 0;
  }

  List<VoucherConfigTiers> _getTier(
      double total, VoucherConfiguration voucherConfiguration) {
    List<VoucherConfigTiers> tiers = List.empty(growable: true);

    bool checkForTiers = voucherConfiguration.issueMinimumSpendAmount != null &&
        (voucherConfiguration.issueMinimumSpendAmount ?? 0) > 0;

    while (checkForTiers) {
      MyLogUtils.logDebug("$tag _getTier total : $total");
      MyLogUtils.logDebug("$tag _getTier checkForTiers : $checkForTiers");
      var configTier = VoucherConfigTiers();
      configTier.flatAmount = voucherConfiguration.flatAmount;
      if (total > (voucherConfiguration.issueMinimumSpendAmount ?? 0)) {
        tiers.add(configTier);
        total = total - (voucherConfiguration.issueMinimumSpendAmount ?? 0);
      } else {
        checkForTiers = false;
      }
    }

    return tiers;
  }

  @override
  int getDiscountType() {
    return discountTypeFlatValue;
  }

  @override
  String createVoucherNumber(
      CartSummary cartSummary, VoucherConfiguration voucherConfiguration) {
    return "${voucherConfiguration.id}${getNow().millisecondsSinceEpoch}${cartSummary.customers?.id ?? 0}${Random().nextInt(10000)}";
  }

  @override
  List<SaleVoucherConfigs>? getSaleVoucherConfig(
      CartSummary cartSummary, VoucherConfiguration voucherConfiguration) {
    var tier = _getTier(getTotalForVoucherGenerationValidation(cartSummary),
        voucherConfiguration);

    MyLogUtils.logDebug("[$tag] getSaleVoucherConfig : ${tier}");

    if (tier.isEmpty) {
      return null;
    }
    List<SaleVoucherConfigs> configs = List.empty(growable: true);

    for (var element in tier) {
      configs.add(SaleVoucherConfigs(
          discountType: getDiscountType(),
          voucherConfigurationId: voucherConfiguration.id,
          number: createVoucherNumber(cartSummary, voucherConfiguration),
          minimumSpendAmount: voucherConfiguration.useMinimumSpendAmount,
          percentage: null,
          flatAmount: element.flatAmount ?? 0.0,
          expiredAt: addDaysToDate(voucherConfiguration.validityDays ?? 0)));
    }

    return configs;
  }
}
