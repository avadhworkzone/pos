import 'package:jakel_base/restapi/vouchers/model/BirthdayVoucherResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/VoucherConfigurationResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/VouchersListResponse.dart';

abstract class VoucherApi {
  Future<VoucherConfigurationResponse> getVoucherConfigurations();

  Future<VouchersListResponse> getVouchers(int pageNo, int perPage);

  Future<BirthdayVoucherResponse> generateBirthdayVoucher(
      int customerId, VoucherConfiguration voucherConfiguration, String number);
}
