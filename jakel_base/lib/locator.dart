import 'package:get_it/get_it.dart';
import 'package:jakel_base/converter/bookingpayment/CartToBookingPaymentConverterImpl.dart';
import 'package:jakel_base/converter/sale/CartSummaryToSaleConverter.dart';
import 'package:jakel_base/converter/sale/CartSummaryToSaleConverterImpl.dart';
import 'package:jakel_base/database/cashbacks/CashBacksLocalApi.dart';
import 'package:jakel_base/database/cashbacks/CashBacksLocalApiImpl.dart';
import 'package:jakel_base/database/cashiers/CashiersLocalApi.dart';
import 'package:jakel_base/database/cashiers/CashiersLocalApiImpl.dart';
import 'package:jakel_base/database/cashmovement/CashMovementLocalApi.dart';
import 'package:jakel_base/database/cashmovement/CashMovementLocalApiImpl.dart';
import 'package:jakel_base/database/companyconfig/CompanyConfigLocalApi.dart';
import 'package:jakel_base/database/companyconfig/CompanyConfigLocalApiImpl.dart';
import 'package:jakel_base/database/complimentaryreason/ComplimentaryReasonLocalApi.dart';
import 'package:jakel_base/database/complimentaryreason/ComplimentaryReasonLocalApiImpl.dart';
import 'package:jakel_base/database/counter/CounterLocalApi.dart';
import 'package:jakel_base/database/counter/CounterLocalApiImpl.dart';
import 'package:jakel_base/database/customertypes/CustomerTypesLocalApi.dart';
import 'package:jakel_base/database/customertypes/CustomerTypesLocalApiImpl.dart';
import 'package:jakel_base/database/denominations/DenominationsLocalApi.dart';
import 'package:jakel_base/database/denominations/DenominationsLocalApiImpl.dart';
import 'package:jakel_base/database/directors/DirectorsLocalApi.dart';
import 'package:jakel_base/database/directors/DirectorsLocalApiImpl.dart';
import 'package:jakel_base/database/dreamprice/DreamPriceLocalApi.dart';
import 'package:jakel_base/database/dreamprice/DreamPriceLocalApiImpl.dart';
import 'package:jakel_base/database/giftcards/GiftCardsLocalApi.dart';
import 'package:jakel_base/database/giftcards/GiftCardsLocalApiImpl.dart';
import 'package:jakel_base/database/loyaltycampaigns/LoyaltyCampaignsLocalApi.dart';
import 'package:jakel_base/database/loyaltycampaigns/LoyaltyCampaignsLocalApiImpl.dart';
import 'package:jakel_base/database/holdsaletypes/HoldSaleTypesLocalApi.dart';
import 'package:jakel_base/database/holdsaletypes/HoldSaleTypesLocalApiImpl.dart';
import 'package:jakel_base/database/loyaltypointvoucherconfiguration/LoyaltyPointVoucherConfigurationLocalApi.dart';
import 'package:jakel_base/database/loyaltypointvoucherconfiguration/LoyaltyPointVoucherConfigurationLocalApiImpl.dart';
import 'package:jakel_base/database/membergroup/MemberGroupLocalApi.dart';
import 'package:jakel_base/database/membergroup/MemberGroupLocalApiImpl.dart';
import 'package:jakel_base/database/memberships/MemberShipsLocalApi.dart';
import 'package:jakel_base/database/memberships/MemberShipsLocalApiImpl.dart';
import 'package:jakel_base/database/offlinedata/OfflineCashMovementDataApi.dart';
import 'package:jakel_base/database/offlinedata/OfflineCashMovementDataApiImpl.dart';
import 'package:jakel_base/database/offlinedata/OfflineCloseCounterDataApi.dart';
import 'package:jakel_base/database/offlinedata/OfflineCloseCounterDataApiImpl.dart';
import 'package:jakel_base/database/offlinedata/OfflineOpenCounterDataApi.dart';
import 'package:jakel_base/database/offlinedata/OfflineOpenCounterDataApiImpl.dart';
import 'package:jakel_base/database/offlinedata/OfflineSalesDataApi.dart';
import 'package:jakel_base/database/offlinedata/OfflineSalesDataApiImpl.dart';
import 'package:jakel_base/database/paymenttypes/PaymentTypesLocalApi.dart';
import 'package:jakel_base/database/paymenttypes/PaymentTypesLocalApiImpl.dart';
import 'package:jakel_base/database/products/ProductsLocalApi.dart';
import 'package:jakel_base/database/products/ProductsLocalApiImpl.dart';
import 'package:jakel_base/database/promoters/PromotersLocalApi.dart';
import 'package:jakel_base/database/promoters/PromotersLocalApiImpl.dart';
import 'package:jakel_base/database/promotions/PromotionsLocalApi.dart';
import 'package:jakel_base/database/promotions/PromotionsLocalApiImpl.dart';
import 'package:jakel_base/database/sale/OfflineSaleApi.dart';
import 'package:jakel_base/database/sale/OfflineSaleApiImpl.dart';
import 'package:jakel_base/database/salereturnreason/SaleReturnReasonLocalApiImpl.dart';
import 'package:jakel_base/database/serialport/SerialPortDevicesApi.dart';
import 'package:jakel_base/database/serialport/SerialPortDevicesApiImpl.dart';
import 'package:jakel_base/database/storemanagers/StoreManagersLocalApi.dart';
import 'package:jakel_base/database/storemanagers/StoreManagersLocalApiImpl.dart';
import 'package:jakel_base/database/unitofmeasures/UnitOfMeasureLocalApi.dart';
import 'package:jakel_base/database/unitofmeasures/UnitOfMeasureLocalApiImpl.dart';
import 'package:jakel_base/database/user/UserLocalApi.dart';
import 'package:jakel_base/database/user/UserLocalApiImpl.dart';
import 'package:jakel_base/database/vouchers/VoucherConfigLocalApi.dart';
import 'package:jakel_base/database/vouchers/VoucherConfigLocalApiImpl.dart';
import 'package:jakel_base/database/vouchers/VouchersLocalApi.dart';
import 'package:jakel_base/database/vouchers/VouchersLocalApiImpl.dart';
import 'package:jakel_base/logs/MyLogs.dart';
import 'package:jakel_base/logs/MyLogsImpl.dart';
import 'package:jakel_base/printer/service/my_printer_service.dart';
import 'package:jakel_base/printer/service/my_printer_service_impl.dart';
import 'package:jakel_base/restapi/bookingpayment/BookingPaymentApi.dart';
import 'package:jakel_base/restapi/bookingpayment/BookingPaymentApiImpl.dart';
import 'package:jakel_base/restapi/cashbacks/CashBacksApi.dart';
import 'package:jakel_base/restapi/cashbacks/CashBacksApiImpl.dart';
import 'package:jakel_base/restapi/cashiers/CashiersApi.dart';
import 'package:jakel_base/restapi/cashiers/CashiersApiImpl.dart';
import 'package:jakel_base/restapi/cashmovement/CashMovementApi.dart';
import 'package:jakel_base/restapi/cashmovement/CashMovementApiImpl.dart';
import 'package:jakel_base/restapi/companyconfiguration/CompanyConfigurationApi.dart';
import 'package:jakel_base/restapi/companyconfiguration/CompanyConfigurationApiImpl.dart';
import 'package:jakel_base/restapi/complimentaryreason/ComplimentaryApi.dart';
import 'package:jakel_base/restapi/complimentaryreason/ComplimentaryApiImpl.dart';
import 'package:jakel_base/restapi/configurationkey/ConfigurationApi.dart';
import 'package:jakel_base/restapi/configurationkey/ConfigurationApiImpl.dart';
import 'package:jakel_base/restapi/counters/CountersApi.dart';
import 'package:jakel_base/restapi/counters/CounterApiImpl.dart';
import 'package:jakel_base/restapi/creditnotedetailsbyid/CreditNotesApi.dart';
import 'package:jakel_base/restapi/customers/CustomerApi.dart';
import 'package:jakel_base/restapi/customers/CustomerApiImpl.dart';
import 'package:jakel_base/restapi/denominations/DenominationApi.dart';
import 'package:jakel_base/restapi/denominations/DenominationApiImpl.dart';
import 'package:jakel_base/restapi/directors/DirectorsApi.dart';
import 'package:jakel_base/restapi/directors/DirectorsApiImpl.dart';
import 'package:jakel_base/restapi/dreamprice/DreamPriceApi.dart';
import 'package:jakel_base/restapi/dreamprice/DreamPriceApiImpl.dart';
import 'package:jakel_base/restapi/employees/EmployeesApi.dart';
import 'package:jakel_base/restapi/employees/EmployeesApiImpl.dart';
import 'package:jakel_base/restapi/generatememberloyaltypointvoucher/GenerateMemberLoyaltyPointVoucherApi.dart';
import 'package:jakel_base/restapi/generatememberloyaltypointvoucher/GenerateMemberLoyaltyPointVoucherApiImpl.dart';
import 'package:jakel_base/restapi/giftcards/GiftCardsApi.dart';
import 'package:jakel_base/restapi/giftcards/GiftCardsApiImpl.dart';
import 'package:jakel_base/restapi/login/LoginApi.dart';
import 'package:jakel_base/restapi/login/LoginApiImpl.dart';
import 'package:jakel_base/restapi/loyaltycampaigns/LoyaltyCampaignsApi.dart';
import 'package:jakel_base/restapi/loyaltycampaigns/LoyaltyCampaignsApiImpl.dart';
import 'package:jakel_base/restapi/loyaltypointvoucherconfiguration/LoyaltyPointVoucherConfigurationApi.dart';
import 'package:jakel_base/restapi/loyaltypointvoucherconfiguration/LoyaltyPointVoucherConfigurationApiImpl.dart';
import 'package:jakel_base/restapi/managers/StoreManagersApi.dart';
import 'package:jakel_base/restapi/managers/StoreManagersApiImpl.dart';
import 'package:jakel_base/restapi/me/MeApi.dart';
import 'package:jakel_base/restapi/me/MeApiImpl.dart';
import 'package:jakel_base/restapi/paymenttypes/PaymentTypesApi.dart';
import 'package:jakel_base/restapi/paymenttypes/PaymentTypesApiImpl.dart';
import 'package:jakel_base/restapi/pettycash/PettyCashApi.dart';
import 'package:jakel_base/restapi/pettycash/PettyCashApiImpl.dart';
import 'package:jakel_base/restapi/priceoverridetypes/PriceOverrideTypesApi.dart';
import 'package:jakel_base/restapi/priceoverridetypes/PriceOverrideTypesApiImpl.dart';
import 'package:jakel_base/restapi/products/ProductsApi.dart';
import 'package:jakel_base/restapi/products/ProductsApiImpl.dart';
import 'package:jakel_base/restapi/promoters/PromotersApi.dart';
import 'package:jakel_base/restapi/promoters/PromotersApiImpl.dart';
import 'package:jakel_base/restapi/promotions/PromotionApi.dart';
import 'package:jakel_base/restapi/promotions/PromotionsApiImpl.dart';
import 'package:jakel_base/restapi/sales/SalesApi.dart';
import 'package:jakel_base/restapi/sales/SalesApiImpl.dart';
import 'package:jakel_base/restapi/takebreak/TakeBreakApi.dart';
import 'package:jakel_base/restapi/takebreak/TakeBreakApiImpl.dart';
import 'package:jakel_base/restapi/vouchers/VoucherApi.dart';
import 'package:jakel_base/restapi/vouchers/VoucherApiImpl.dart';
import 'package:jakel_base/serialportdevices/service/display_device_service.dart';
import 'package:jakel_base/serialportdevices/service/display_device_service_impl.dart';
import 'package:jakel_base/serialportdevices/service/extended_display_service.dart';
import 'package:jakel_base/serialportdevices/service/extended_display_service_impl.dart';
import 'package:jakel_base/serialportdevices/service/may_bank_terminal_service.dart';
import 'package:jakel_base/serialportdevices/service/may_bank_terminal_service_impl.dart';
import 'package:jakel_base/serialportdevices/service/process_runner_service.dart';
import 'package:jakel_base/serialportdevices/service/process_runner_service_impl.dart';

import 'NavigationService.dart';
import 'converter/bookingpayment/CartToBookingPaymentConverter.dart';
import 'database/printer/PrinterLocalApi.dart';
import 'database/printer/PrinterLocalApiImpl.dart';
import 'database/salereturnreason/SaleReturnReasonLocalApi.dart';
import 'restapi/creditnotedetailsbyid/CreditNotesApiImpl.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<NavigationService>(() => NavigationService());

  /// Local Database API
  locator.registerLazySingleton<UserLocalApi>(() => UserLocalApiImpl());
  locator.registerLazySingleton<CounterLocalApi>(() => CounterLocalApiImpl());
  locator.registerLazySingleton<ProductsLocalApi>(() => ProductsLocalApiImpl());
  locator.registerLazySingleton<UnitOfMeasureLocalApi>(
      () => UnitOfMeasureLocalApiImpl());
  locator.registerLazySingleton<PaymentTypesLocalApi>(
      () => PaymentTypesLocalApiImpl());
  locator
      .registerLazySingleton<PromotersLocalApi>(() => PromotersLocalApiImpl());
  locator.registerLazySingleton<StoreManagersLocalApi>(
      () => StoreManagersLocalApiImpl());
  locator.registerLazySingleton<PromotionsLocalApi>(
      () => PromotionsLocalApiImpl());
  locator.registerLazySingleton<DreamPriceLocalApi>(
      () => DreamPriceLocalApiImpl());
  locator
      .registerLazySingleton<DirectorsLocalApi>(() => DirectorsLocalApiImpl());
  locator.registerLazySingleton<CashiersLocalApi>(() => CashiersLocalApiImpl());
  locator.registerLazySingleton<ComplimentaryReasonLocalApi>(
      () => ComplimentaryReasonLocalApiImpl());
  locator.registerLazySingleton<VoucherConfigLocalApi>(
      () => VoucherConfigLocalApiImpl());
  locator.registerLazySingleton<VouchersLocalApi>(() => VouchersLocalApiImpl());
  locator.registerLazySingleton<LoyaltyCampaignsLocalApi>(
      () => LoyaltyCampaignsLocalApiImpl());
  locator
      .registerLazySingleton<CashBacksLocalApi>(() => CashBacksLocalApiImpl());
  locator.registerLazySingleton<CashMovementLocalApi>(
      () => CashMovementLocalApiImpl());

  locator.registerLazySingleton<DenominationsLocalApi>(
      () => DenominationsLocalApiImpl());
  locator.registerLazySingleton<PrinterLocalApi>(() => PrinterLocalApiImpl());

  locator.registerLazySingleton<SerialPortDevicesApi>(
      () => SerialPortDevicesApiImpl());

  locator.registerLazySingleton<MemberShipsLocalApi>(
      () => MemberShipsLocalApiImpl());

  locator.registerLazySingleton<OfflineSaleApi>(() => OfflineSaleApiImpl());

  locator.registerLazySingleton<CustomerTypesLocalApi>(
      () => CustomerTypesLocalApiImpl());

  locator.registerLazySingleton<SaleReturnReasonLocalApi>(
      () => SaleReturnReasonLocalApiImpl());

  locator.registerLazySingleton<CompanyConfigLocalApi>(
      () => CompanyConfigLocalApiImpl());

  locator
      .registerLazySingleton<GiftCardsLocalApi>(() => GiftCardsLocalApiImpl());

  locator.registerLazySingleton<OfflineCloseCounterDataApi>(
      () => OfflineCloseCounterDataApiImpl());

  locator.registerLazySingleton<OfflineOpenCounterDataApi>(
      () => OfflineOpenCounterDataApiImpl());

  locator.registerLazySingleton<OfflineSalesDataApi>(
      () => OfflineSalesDataApiImpl());

  locator.registerLazySingleton<OfflineCashMovementDataApi>(
      () => OfflineCashMovementDataApiImpl());

  locator.registerLazySingleton<HoldSaleTypesLocalApi>(
      () => HoldSaleTypesLocalApiImpl());

  locator.registerLazySingleton<MemberGroupLocalApi>(
      () => MemberGroupLocalApiImpl());

  ///LoyaltyPointVoucherConfiguration
  locator.registerLazySingleton<LoyaltyPointVoucherConfigurationLocalApi>(
          () =>LoyaltyPointVoucherConfigurationLocalApiImpl());

  ///Item Price override types
  locator.registerLazySingleton<PriceOverrideTypesApi>(
          () => PriceOverrideTypesApiImpl());

  /// Rest API
  locator.registerLazySingleton<MeApi>(() => MeApiImpl());
  locator.registerLazySingleton<MyLogs>(() => MyLogsImpl());
  locator.registerLazySingleton<LoginApi>(() => LoginApiImpl());
  locator.registerLazySingleton<CountersApi>(() => CountersApiImpl());
  locator.registerLazySingleton<StoreManagersApi>(() => StoreManagersApiImpl());
  locator.registerLazySingleton<PaymentTypesApi>(() => PaymentTypesApiImpl());
  locator.registerLazySingleton<ProductsApi>(() => ProductsApiImpl());
  locator.registerLazySingleton<SalesApi>(() => SalesApiImpl());
  locator.registerLazySingleton<CustomerApi>(() => CustomerApiImpl());
  locator.registerLazySingleton<PromotersApi>(() => PromotersApiImpl());
  locator.registerLazySingleton<PromotionApi>(() => PromotionsApiImpl());
  locator.registerLazySingleton<LoyaltyCampaignsApi>(
      () => LoyaltyCampaignsAPIImpl());
  locator
      .registerLazySingleton<BookingPaymentApi>(() => BookingPaymentApiImpl());
  locator.registerLazySingleton<PettyCashApi>(() => PettyCashApiImpl());
  locator.registerLazySingleton<DreamPriceApi>(() => DreamPriceApiImpl());
  locator.registerLazySingleton<DirectorsApi>(() => DirectorsApiImpl());
  locator.registerLazySingleton<CashiersApi>(() => CashiersApiImpl());
  locator.registerLazySingleton<ComplimentaryApi>(() => ComplimentaryApiImpl());
  locator.registerLazySingleton<VoucherApi>(() => VoucherApiImpl());
  locator.registerLazySingleton<CashBacksApi>(() => CashBacksApiImpl());
  locator.registerLazySingleton<CashMovementApi>(() => CashMovementApiImpl());
  locator.registerLazySingleton<ConfigurationApi>(() => ConfigurationApiImpl());
  locator.registerLazySingleton<DenominationApi>(() => DenominationApiImpl());
  locator.registerLazySingleton<EmployeesApi>(() => EmployeesApiImpl());
  locator.registerLazySingleton<CompanyConfigurationApi>(
      () => CompanyConfigurationApiImpl());
  locator.registerLazySingleton<GiftCardsApi>(() => GiftCardsApiImpl());
  locator.registerLazySingleton<TakeBreakApi>(() => TakeBreakApiImpl());
  locator.registerLazySingleton<CreditNotesApi>(() => CreditNotesApiImpl());

  /// Services
  locator.registerLazySingleton<MyPrinterService>(() => MyPrinterServiceImpl());
  locator.registerLazySingleton<MayBankTerminalService>(
      () => MayBankTerminalServiceImpl());
  locator.registerLazySingleton<DisplayDeviceService>(
      () => DisplayDeviceServiceImpl());
  locator.registerLazySingleton<ProcessRunnerService>(
      () => ProcessRunnerServiceImpl());
  locator.registerLazySingleton<ExtendedDisplayService>(
      () => ExtendedDisplayServiceImpl());

  // Converter
  locator.registerLazySingleton<CartSummaryToSaleConverter>(
      () => CartSummaryToSaleConverterImpl());
  locator.registerLazySingleton<CartToBookingPaymentConverter>(
      () => CartToBookingPaymentConverterImpl());

  ///LoyaltyPointVoucherConfiguration
  locator.registerLazySingleton<LoyaltyPointVoucherConfigurationApi>(
          () =>LoyaltyPointVoucherConfigurationApiImpl());

  ///GenerateMemberLoyaltyPointVoucher
  locator.registerLazySingleton<GenerateMemberLoyaltyPointVoucherApi>(
          () =>GenerateMemberLoyaltyPointVouchersApiImpl());
}
