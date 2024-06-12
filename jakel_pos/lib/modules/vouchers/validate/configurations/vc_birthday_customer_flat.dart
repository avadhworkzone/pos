import 'dart:math';

import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/sales/model/NewSaleRequest.dart';
import 'package:jakel_base/restapi/vouchers/model/VoucherConfigurationResponse.dart';
import 'package:jakel_base/utils/my_date_utils.dart';
import 'package:jakel_pos/modules/vouchers/validate/base_voucher_config.dart';
import 'package:jakel_pos/modules/vouchers/validate/voucher_config_service_impl.dart';

import '../voucher_helper.dart';
import '../voucher_validate_helper.dart';

class VcBirthdayCustomerFlat with BaseVoucherConfig {
  final tag = 'VcBirthdayCustomerFlat';

  @override
  String title() {
    return "Birthday Restricted By Member Flat Voucher";
  }

  @override
  String description() {
    return "Birthday Restricted By Member Flat Voucher";
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

    // Check for customer birthday date
    if (!isCustomerBirthdayMonth(cartSummary.customers, voucherConfiguration)) {
      return false;
    }

    //Start & End date should be valid
    if (!checkIsValidDate(
        voucherConfiguration.startDate, voucherConfiguration.endDate)) {
      return false;
    }

    var tier = _getTier(getTotalForVoucherGenerationValidation(cartSummary),
        voucherConfiguration);

    return tier != null;
  }

  @override
  double getVoucherAmount(
      CartSummary cartSummary, VoucherConfiguration voucherConfiguration) {
    if (isValidForThisCart(cartSummary, voucherConfiguration)) {
      var tier = _getTier(getTotalForVoucherGenerationValidation(cartSummary),
          voucherConfiguration);
      return tier?.flatAmount ?? 0.0;
    }

    return 0;
  }

  VoucherConfigTiers? _getTier(
      double total, VoucherConfiguration voucherConfiguration) {
    return VoucherConfigTiers(
      flatAmount: voucherConfiguration.flatAmount ?? 0,
      minimumSpendAmount: voucherConfiguration.issueMinimumSpendAmount ?? 0,
    );
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

    if (tier == null) {
      return null;
    }
    return [
      SaleVoucherConfigs(
          discountType: getDiscountType(),
          voucherConfigurationId: voucherConfiguration.id,
          number: createVoucherNumber(cartSummary, voucherConfiguration),
          minimumSpendAmount: voucherConfiguration.useMinimumSpendAmount,
          percentage: null,
          flatAmount: tier.flatAmount ?? 0.0,
          expiredAt: addDaysToDate(voucherConfiguration.validityDays ?? 0))
    ];
  }
}
