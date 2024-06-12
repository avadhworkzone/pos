import 'package:get_it/get_it.dart';
import 'package:jakel_base/database/employee_group/EmployeeGroupLocalApi.dart';
import 'package:jakel_base/database/employee_group/EmployeeGroupLocalApiImpl.dart';
import 'package:jakel_base/database/priceoverridetypes/PriceOverrideTypesLocalApi.dart';
import 'package:jakel_base/database/priceoverridetypes/PriceOverrideTypesLocalApiImpl.dart';
import 'package:jakel_pos/modules/cashbacks/validate/cashback_service.dart';
import 'package:jakel_pos/modules/cashbacks/validate/cashback_service_impl.dart';
import 'package:jakel_pos/modules/dreamprices/dream_price_service.dart';
import 'package:jakel_pos/modules/dreamprices/dream_price_service_impl.dart';
import 'package:jakel_pos/modules/loyaltycampaigns/validate/loyalty_campaign_service_impl.dart';
import 'package:jakel_pos/modules/loyaltycampaigns/validate/loyalty_campaigns_service.dart';
import 'package:jakel_pos/modules/newsale/service/cart_service.dart';
import 'package:jakel_pos/modules/newsale/service/cart_service_impl.dart';
import 'package:jakel_pos/modules/newsale/service/item_price_override_service.dart';
import 'package:jakel_pos/modules/newsale/service/item_price_override_service_impl.dart';
import 'package:jakel_pos/modules/newsale/service/new_sale_config_service.dart';
import 'package:jakel_pos/modules/newsale/service/new_sale_config_service_impl.dart';
import 'package:jakel_pos/modules/offline/database/onholdsales/OnHoldSalesLocalApi.dart';
import 'package:jakel_pos/modules/offline/database/onholdsales/OnHoldSalesLocalApiImpl.dart';
import 'package:jakel_pos/modules/promotions/validate/promotions_service.dart';
import 'package:jakel_pos/modules/promotions/validate/promotions_service_impl.dart';
import 'package:jakel_pos/modules/vouchers/validate/voucher_config_service.dart';
import 'package:jakel_pos/modules/vouchers/validate/voucher_config_service_impl.dart';
import 'package:jakel_pos/modules/vouchers/validate/voucher_service.dart';
import 'package:jakel_pos/modules/vouchers/validate/voucher_service_impl.dart';

GetIt appLocator = GetIt.instance;

void setUpAppLocator() {
  /// Services API
  appLocator
      .registerLazySingleton<PromotionsService>(() => PromotionsServiceImpl());
  appLocator.registerLazySingleton<VoucherConfigService>(
      () => VoucherConfigServiceImpl());
  appLocator.registerLazySingleton<VoucherService>(() => VoucherServiceImpl());
  appLocator.registerLazySingleton<LoyaltyCampaignsService>(
      () => LoyaltyCampaignsServiceImpl());
  appLocator
      .registerLazySingleton<CashBackService>(() => CashBackServiceImpl());

  appLocator.registerLazySingleton<NewSaleConfigService>(
      () => NewSaleConfigServiceImpl());

  appLocator.registerLazySingleton<CartService>(() => CartServiceImpl());

  appLocator
      .registerLazySingleton<DreamPriceService>(() => DreamPriceServiceImpl());

  appLocator.registerLazySingleton<ItemPriceOverrideService>(
      () => ItemPriceOverrideServiceImpl());

  ///Local API
  appLocator.registerLazySingleton<OnHoldSalesLocalApi>(
      () => OnHoldSalesLocalApiImpl());

  ///EmployeesGroup
  appLocator.registerLazySingleton<EmployeeGroupLocalApi>(
      () => EmployeeGroupLocalApiImpl());

  /// Item Price override types
  appLocator.registerLazySingleton<PriceOverrideTypesLocalApi>(
      () => PriceOverrideTypesLocalApiImpl());
}
