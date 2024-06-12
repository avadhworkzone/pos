import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/VoucherConfigurationResponse.dart';

import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'base_voucher_config.dart';

mixin VoucherConfigService {
  /// Select all valid voucher config for this sale from available promotions
  List<VoucherConfiguration> selectAllVoucherConfiguration(
      CartSummary cartSummary,
      List<VoucherConfiguration> allVoucherConfiguration);

  // Get voucher config class for the given voucher configuration
  BaseVoucherConfig? getVoucherConfig(
      VoucherConfiguration voucherConfiguration);

  // Check
  VoucherConfiguration? getBirthdayVoucherConfig(
      List<VoucherConfiguration> allVoucherConfigs, Customers customer);
}
