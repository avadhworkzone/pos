import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/restapi/sales/model/NewSaleRequest.dart';
import 'package:jakel_base/restapi/vouchers/model/VoucherConfigurationResponse.dart';
import 'package:jakel_pos/modules/vouchers/validate/base_voucher_config.dart';
import 'package:jakel_pos/modules/vouchers/validate/configurations/vc_birthday_customer_flat.dart';
import 'package:jakel_pos/modules/vouchers/validate/configurations/vc_birthday_customer_percentage.dart';
import 'package:jakel_pos/modules/vouchers/validate/configurations/vc_tier_all_flat_multiple.dart';
import 'package:jakel_pos/modules/vouchers/validate/configurations/vc_tier_all_percentage.dart';
import 'package:jakel_pos/modules/vouchers/validate/configurations/vc_tier_all_percentage_multiple.dart';
import 'package:jakel_pos/modules/vouchers/validate/configurations/vc_tier_customer_flat.dart';
import 'package:jakel_pos/modules/vouchers/validate/configurations/vc_tier_customer_percentage.dart';
import 'package:jakel_pos/modules/vouchers/validate/configurations/vc_tier_customer_percentage_multiple.dart';
import 'package:jakel_pos/modules/vouchers/validate/configurations/vc_tier_guest_percentage.dart';
import 'package:jakel_pos/modules/vouchers/validate/configurations/vc_tier_guest_percentage_multiple.dart';
import 'package:jakel_pos/modules/vouchers/validate/configurations/vc_tier_only_guest_flat.dart';
import 'package:jakel_pos/modules/vouchers/validate/configurations/vc_tier_only_guest_flat_multiple.dart';
import 'package:jakel_pos/modules/vouchers/validate/voucher_config_service.dart';

import 'configurations/vc_tier_all_flat.dart';
import 'configurations/vc_tier_customer_flat_multiple.dart';

//Voucher Type Configuration
const tierCustomerPercentage = "TIER_RESTRICTED_BY_MEMBER_PERCENTAGE_VOUCHER";
const tierCustomerFlat = "TIER_RESTRICTED_BY_MEMBER_FLAT_VOUCHER";
const tierAllFlat = "TIER_RESTRICTED_BY_ALL_FLAT_VOUCHER";
const tierAllPercentage = "TIER_RESTRICTED_BY_ALL_PERCENTAGE_VOUCHER";
//

const tierNotCustomerPercentage =
    "TIER_RESTRICTED_BY_NON_MEMBER_PERCENTAGE_VOUCHER";
const tierNotCustomerFlat = "TIER_RESTRICTED_BY_NON_MEMBER_FLAT_VOUCHER";
const multipleAllPercentage = "MULTIPLE_RESTRICTED_BY_ALL_PERCENTAGE_VOUCHER";
const multipleAllFlat = "MULTIPLE_RESTRICTED_BY_ALL_FLAT_VOUCHER";
const multipleCustomerPercentage =
    "MULTIPLE_RESTRICTED_BY_MEMBER_PERCENTAGE_VOUCHER";
const multipleCustomerFlat = "MULTIPLE_RESTRICTED_BY_MEMBER_FLAT_VOUCHER";
const multipleNotCustomerPercentage =
    "MULTIPLE_RESTRICTED_BY_NON_MEMBER_PERCENTAGE_VOUCHER";
const multipleNotCustomerFlat =
    "MULTIPLE_RESTRICTED_BY_NON_MEMBER_FLAT_VOUCHER";

const birthdayCustomerPercentage =
    "BIRTHDAY_RESTRICTED_BY_MEMBER_PERCENTAGE_VOUCHER";
const birthdayCustomerFlat = "BIRTHDAY_RESTRICTED_BY_MEMBER_FLAT_VOUCHER";
const birthdayVoucher = "BIRTHDAY_VOUCHER";
//Exclude Configuration
const excludeNone = "NONE";
const excludeProducts = "PRODUCTS";
const excludeCategories = "CATEGORIES";

//Discount Types
const discountTypeFlatValue = 2;
const discountTypePercentageValue = 1;

const discountTypeFlat = "FLAT";
const discountTypePercentage = "PERCENTAGE";

class VoucherConfigServiceImpl with VoucherConfigService {
  @override
  List<VoucherConfiguration> selectAllVoucherConfiguration(
      CartSummary cartSummary,
      List<VoucherConfiguration> allVoucherConfiguration) {
    List<VoucherConfiguration> voucherConfigurations =
        List.empty(growable: true);

    for (var value in allVoucherConfiguration) {
      BaseVoucherConfig? config = getVoucherConfig(value);

      if (config != null && config.isValidForThisCart(cartSummary, value)) {
        List<SaleVoucherConfigs>? saleConfigs =
            config.getSaleVoucherConfig(cartSummary, value);

        saleConfigs?.forEach((element) {
          voucherConfigurations.add(value);
        });
      }
    }
    return voucherConfigurations;
  }

  @override
  BaseVoucherConfig? getVoucherConfig(
      VoucherConfiguration voucherConfiguration) {
    if (voucherConfiguration.voucherType == tierCustomerPercentage) {
      return VcTierCustomerPercentage();
    }

    if (voucherConfiguration.voucherType == tierCustomerFlat) {
      return VcTierCustomerFlat();
    }

    if (voucherConfiguration.voucherType == tierAllFlat) {
      return VcTierAllFlat();
    }

    if (voucherConfiguration.voucherType == tierAllPercentage) {
      return VcTierAllPercentage();
    }

    if (voucherConfiguration.voucherType == tierNotCustomerFlat) {
      return VcTierGuestFlat();
    }

    if (voucherConfiguration.voucherType == tierNotCustomerPercentage) {
      return VcTierGuestPercentage();
    }

    if (voucherConfiguration.voucherType == multipleAllPercentage) {
      return VcTierAllPercentageMultiple();
    }

    if (voucherConfiguration.voucherType == multipleAllFlat) {
      return VcTierAllFlatMultiple();
    }

    if (voucherConfiguration.voucherType == multipleCustomerPercentage) {
      return VcTierCustomerPercentageMultiple();
    }

    if (voucherConfiguration.voucherType == multipleCustomerFlat) {
      return VcTierCustomerFlatMultiple();
    }

    if (voucherConfiguration.voucherType == multipleNotCustomerPercentage) {
      return VcTierGuestsPercentageMultiple();
    }

    if (voucherConfiguration.voucherType == multipleNotCustomerFlat) {
      return VcTierOnlyGuestFlatMultiple();
    }

    return null;
  }

  @override
  VoucherConfiguration? getBirthdayVoucherConfig(
      List<VoucherConfiguration> allVoucherConfigs, Customers customer) {
    for (var value in allVoucherConfigs) {
      if (value.voucherType == birthdayCustomerPercentage) {
        var voucher = VcBirthdayCustomerPercentage();
        if (voucher.isValidForThisCart(
            CartSummary(customers: customer), value)) {
          return value;
        }
      } else if (value.voucherType == birthdayCustomerFlat) {
        var voucher = VcBirthdayCustomerFlat();
        if (voucher.isValidForThisCart(
            CartSummary(customers: customer), value)) {
          return value;
        }
      }
    }
    return null;
  }
}
