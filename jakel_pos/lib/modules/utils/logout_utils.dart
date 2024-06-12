import 'package:flutter/cupertino.dart';
import 'package:jakel_base/database/cashbacks/CashBacksLocalApi.dart';
import 'package:jakel_base/database/cashiers/CashiersLocalApi.dart';
import 'package:jakel_base/database/cashmovement/CashMovementLocalApi.dart';
import 'package:jakel_base/database/companyconfig/CompanyConfigLocalApi.dart';
import 'package:jakel_base/database/complimentaryreason/ComplimentaryReasonLocalApi.dart';
import 'package:jakel_base/database/counter/CounterLocalApi.dart';
import 'package:jakel_base/database/customertypes/CustomerTypesLocalApi.dart';
import 'package:jakel_base/database/denominations/DenominationsLocalApi.dart';
import 'package:jakel_base/database/directors/DirectorsLocalApi.dart';
import 'package:jakel_base/database/dreamprice/DreamPriceLocalApi.dart';
import 'package:jakel_base/database/giftcards/GiftCardsLocalApi.dart';
import 'package:jakel_base/database/memberships/MemberShipsLocalApi.dart';
import 'package:jakel_base/database/offlinedata/OfflineCashMovementDataApi.dart';
import 'package:jakel_base/database/offlinedata/OfflineCloseCounterDataApi.dart';
import 'package:jakel_base/database/offlinedata/OfflineOpenCounterDataApi.dart';
import 'package:jakel_base/database/offlinedata/OfflineSalesDataApi.dart';
import 'package:jakel_base/database/paymenttypes/PaymentTypesLocalApi.dart';
import 'package:jakel_base/database/products/ProductsLocalApi.dart';
import 'package:jakel_base/database/promoters/PromotersLocalApi.dart';
import 'package:jakel_base/database/promotions/PromotionsLocalApi.dart';
import 'package:jakel_base/database/sale/OfflineSaleApi.dart';
import 'package:jakel_base/database/salereturnreason/SaleReturnReasonLocalApi.dart';
import 'package:jakel_base/database/storemanagers/StoreManagersLocalApi.dart';
import 'package:jakel_base/database/unitofmeasures/UnitOfMeasureLocalApi.dart';
import 'package:jakel_base/database/user/UserLocalApi.dart';
import 'package:jakel_base/database/vouchers/VoucherConfigLocalApi.dart';
import 'package:jakel_base/database/vouchers/VouchersLocalApi.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_pos/modules/offline/database/onholdsales/OnHoldSalesLocalApi.dart';

import '../../routing/route_names.dart';

logout(bool clearConfiguration, BuildContext context) async {
  var localUserApi = locator.get<UserLocalApi>();
  var counterApi = locator.get<CounterLocalApi>();

  if (clearConfiguration) {
    await localUserApi.deleteConfiguration();
    await counterApi.deleteCounter();
    await counterApi.deleteStore();

    await locator.get<OfflineCashMovementDataApi>().clearBox();
    await locator.get<OfflineCloseCounterDataApi>().clearBox();
    await locator.get<OfflineOpenCounterDataApi>().clearBox();
    await locator.get<OfflineSalesDataApi>().clearBox();

    await locator.get<CashBacksLocalApi>().clearBox();
    await locator.get<CashiersLocalApi>().clearBox();
    await locator.get<CashMovementLocalApi>().clearBox();

    await locator.get<CompanyConfigLocalApi>().clearBox();
    await locator.get<ComplimentaryReasonLocalApi>().clearBox();
    await locator.get<CounterLocalApi>().clearBox();

    await locator.get<CustomerTypesLocalApi>().clearBox();
    await locator.get<DenominationsLocalApi>().clearBox();
    await locator.get<DirectorsLocalApi>().clearBox();

    await locator.get<DreamPriceLocalApi>().clearBox();
    await locator.get<GiftCardsLocalApi>().clearBox();
    await locator.get<MemberShipsLocalApi>().clearBox();

    await locator.get<PaymentTypesLocalApi>().clearBox();
    await locator.get<ProductsLocalApi>().clearBox();
    await locator.get<PromotersLocalApi>().clearBox();

    await locator.get<PromotionsLocalApi>().clearBox();
    await locator.get<OfflineSaleApi>().clearBox();
    await locator.get<SaleReturnReasonLocalApi>().clearBox();

    await locator.get<StoreManagersLocalApi>().clearBox();
    await locator.get<UnitOfMeasureLocalApi>().clearBox();
    await locator.get<UserLocalApi>().clearBox();
    await locator.get<VoucherConfigLocalApi>().clearBox();
    await locator.get<VouchersLocalApi>().clearBox();

    await locator.get<OnHoldSalesLocalApi>().clearBox();
  }
  await localUserApi.logout();
}

routeToSplash(BuildContext context) {
  Navigator.popUntil(context, ModalRoute.withName(SplashRoute));
  Navigator.pushNamed(
    context,
    SplashRoute,
  );
}
