import 'package:jakel_base/restapi/cashbacks/model/CashbacksResponse.dart';
import 'package:jakel_base/restapi/cashmovement/model/CashMovementReasonResponse.dart';
import 'package:jakel_base/restapi/companyconfiguration/model/CompanyConfigurationResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/VoucherConfigurationResponse.dart';

abstract class CompanyConfigLocalApi {
  /// Save
  Future<void> save(CompanyConfigurationResponse response);

  /// Get
  Future<CompanyConfigurationResponse?> getConfig();

  /// Delete
  Future<bool> deleteAll();

  Future<void> clearBox();
}
