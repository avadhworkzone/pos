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
import 'package:jakel_base/database/employee_group/EmployeeGroupLocalApi.dart';
import 'package:jakel_base/database/giftcards/GiftCardsLocalApi.dart';
import 'package:jakel_base/database/holdsaletypes/HoldSaleTypesLocalApi.dart';
import 'package:jakel_base/database/loyaltypointvoucherconfiguration/LoyaltyPointVoucherConfigurationLocalApi.dart';
import 'package:jakel_base/database/loyaltycampaigns/LoyaltyCampaignsLocalApi.dart';
import 'package:jakel_base/database/membergroup/MemberGroupLocalApi.dart';
import 'package:jakel_base/database/memberships/MemberShipsLocalApi.dart';
import 'package:jakel_base/database/paymenttypes/PaymentTypesLocalApi.dart';
import 'package:jakel_base/database/priceoverridetypes/PriceOverrideTypesLocalApi.dart';
import 'package:jakel_base/database/products/ProductsLocalApi.dart';
import 'package:jakel_base/database/promoters/PromotersLocalApi.dart';
import 'package:jakel_base/database/promotions/PromotionsLocalApi.dart';
import 'package:jakel_base/database/salereturnreason/SaleReturnReasonLocalApi.dart';
import 'package:jakel_base/database/storemanagers/StoreManagersLocalApi.dart';
import 'package:jakel_base/database/unitofmeasures/UnitOfMeasureLocalApi.dart';
import 'package:jakel_base/database/user/UserLocalApi.dart';
import 'package:jakel_base/database/vouchers/VoucherConfigLocalApi.dart';
import 'package:jakel_base/database/vouchers/VouchersLocalApi.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/restapi/cashbacks/CashBacksApi.dart';
import 'package:jakel_base/restapi/cashiers/CashiersApi.dart';
import 'package:jakel_base/restapi/cashmovement/CashMovementApi.dart';
import 'package:jakel_base/restapi/companyconfiguration/CompanyConfigurationApi.dart';
import 'package:jakel_base/restapi/complimentaryreason/ComplimentaryApi.dart';
import 'package:jakel_base/restapi/customers/CustomerApi.dart';
import 'package:jakel_base/restapi/denominations/DenominationApi.dart';
import 'package:jakel_base/restapi/directors/DirectorsApi.dart';
import 'package:jakel_base/restapi/dreamprice/DreamPriceApi.dart';
import 'package:jakel_base/restapi/employees/EmployeesApi.dart';
import 'package:jakel_base/restapi/giftcards/GiftCardsApi.dart';
import 'package:jakel_base/restapi/loyaltycampaigns/LoyaltyCampaignsApi.dart';
import 'package:jakel_base/restapi/loyaltypointvoucherconfiguration/LoyaltyPointVoucherConfigurationApi.dart';
import 'package:jakel_base/restapi/managers/StoreManagersApi.dart';
import 'package:jakel_base/restapi/me/MeApi.dart';
import 'package:jakel_base/restapi/paymenttypes/PaymentTypesApi.dart';
import 'package:jakel_base/restapi/priceoverridetypes/PriceOverrideTypesApi.dart';
import 'package:jakel_base/restapi/products/ProductsApi.dart';
import 'package:jakel_base/restapi/promoters/PromotersApi.dart';
import 'package:jakel_base/restapi/promotions/PromotionApi.dart';
import 'package:jakel_base/restapi/sales/SalesApi.dart';
import 'package:jakel_base/restapi/vouchers/VoucherApi.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';

class DownloadDataViewModel extends BaseViewModel {
  void startDownloading(
      Function callBack, Function onCompleted, Function onError) async {
    callBack("Downloading stores & counters details ...");
    await _downloadStores(onError);

    callBack("Downloading configurations ...");
    await _downloadCompanyConfiguration(onError);

    callBack("Downloading denominations details ...");
    await _downloadDenominations(onError);

    callBack("Downloading Membership details ...");
    await _downloadMembershipDetails(onError);

    callBack("Downloading unit of measures ...");
    await _downloadUnitOfMeasures(onError);

    callBack("Downloading payment types ...");
    await _downloadPaymentTypes(onError);

    callBack("Downloading promoters ...");
    await _downloadPromoters(onError);

    callBack("Downloading store managers ...");
    await _downloadStoreManagers(onError);

    callBack("Downloading directors...");
    await _downloadDirectors(onError);

    callBack("Downloading promotions ...");
    await _downloadPromotions(onError);

    callBack("Downloading dream price ...");
    await _downloadDreamPrice(onError);

    callBack("Downloading cashiers price ...");
    await _downloadCashiers(onError);

    callBack("Downloading customer types ...");
    await _downloadCustomerTypes(onError);

    callBack("Downloading complimentary item reasons ...");
    await _downloadComplimentaryReasons(onError);

    callBack("Downloading voucher configurations reasons ...");
    await _downloadVoucherConfiguration(onError);

    callBack("Downloading cashback ...");
    await _downloadCashBacks(onError);

    callBack("Downloading cash movement ...");
    await _downloadCashMovement(onError);

    callBack("Downloading Sale Return reasons  ...");
    await _downloadSaleReturnReasons(onError);

    // Download products
    callBack("Downloading gift cards ...");
    await downloadGiftCards(onError);

    callBack("Downloading Loyalty Campaigns  ...");
    await _downloadLoyaltyCampaigns(onError);

    callBack("Downloading Hold Sale Types  ...");
    await _downloadHoldSaleTypes(onError);

    callBack("Downloading Member group  ...");
    await _downloadMemberGroup(onError);

    callBack("Downloading Employees group  ...");
    await _downloadEmployeesGroup(onError);

    callBack("Downloading Loyalty Point Voucher Configuration  ...");
    await _downloadLoyaltyPointVoucherConfiguration(onError);

    // Download vouchers
    callBack("Downloading vouchers ...");
    await downloadVouchersList(onError, callBack);

    // Download products
    callBack("Downloading products ...");
    await _downloadProducts(onError, callBack);

    // Download item Price Override types
    callBack("Downloading Price Override types ...");
    await _downloadPriceOverrideTypes(onError);

    callBack("Completed");
    // Download Completed
    onCompleted();
  }

  Future _downloadProducts(Function onError, Function callback) async {
    var api = locator.get<ProductsApi>();
    var pageNo = 1;
    const itemsPerPage = 1000;
    List<int> addedProductIds = List.empty(growable: true);

    try {
      var localProductsApi = locator.get<ProductsLocalApi>();
      var currentPageFromApi = 0;
      var lastPageFromApi = 0;

      do {
        var response = await api.getProducts(pageNo, itemsPerPage);

        currentPageFromApi = response.currentPage!;
        lastPageFromApi = response.lastPage!;

        if (response.products != null) {
          response.products?.forEach((element) {
            addedProductIds.add(element.id ?? 0);
          });
          await localProductsApi.saveProducts(response.products!);
        }
        pageNo += 1;

        callback("Downloading products page $pageNo of $lastPageFromApi");
      } while (currentPageFromApi < lastPageFromApi);

      var allProducts = await localProductsApi.getAllProducts();

      // Delete the products that are not in this new products list
      for (var value in allProducts) {
        if (!addedProductIds.contains(value.id ?? 0)) {
          callback("To be deleted value : ${value.id}");
          await localProductsApi.deleteProduct(value.id ?? 0);
        }
      }
    } catch (e) {
      MyLogUtils.logDebug(
          "_downloadProducts failed in page: $pageNo & exception : $e");
      onError("Failed to download product in page : $pageNo");
    }
  }

  Future _downloadUnitOfMeasures(Function onError) async {
    try {
      var unitOfMeasureApi = locator.get<UnitOfMeasureLocalApi>();

      var api = locator.get<ProductsApi>();
      // Unit of measures
      var response = await api.getUnitOfMeasures();

      MyLogUtils.logDebug(
          "_downloadUnitOfMeasures response.unitOfMeasures: ${response.unitOfMeasures} ");

      if (response.unitOfMeasures != null) {
        MyLogUtils.logDebug(
            "_downloadUnitOfMeasures response.unitOfMeasures length: ${response.unitOfMeasures!.length} ");

        await unitOfMeasureApi.save(response.unitOfMeasures!);
      }
    } catch (e) {
      MyLogUtils.logDebug("_downloadUnitOfMeasures failed with exce[tion $e");
      onError("_downloadUnitOfMeasures failed with exce[tion $e");
    }
  }

  Future _downloadPaymentTypes(Function onError) async {
    try {
      var localApi = locator.get<PaymentTypesLocalApi>();

      var restApi = locator.get<PaymentTypesApi>();

      var response = await restApi.getPaymentTypes();

      MyLogUtils.logDebug(
          "_downloadPaymentTypes response: ${response.paymentTypes} ");

      if (response.paymentTypes != null) {
        await localApi.save(response.paymentTypes!);
      }
    } catch (e) {
      MyLogUtils.logDebug("_downloadPaymentTypes failed with exception $e");
      onError("_downloadPaymentTypes failed with exception $e");
    }
  }

  Future _downloadPromoters(Function onError) async {
    try {
      var localApi = locator.get<PromotersLocalApi>();

      var restApi = locator.get<PromotersApi>();

      var response = await restApi.getPromoters();

      MyLogUtils.logDebug(
          "_downloadPromoters response: ${response.promoters} ");

      if (response.promoters != null) {
        await localApi.save(response.promoters!);
      }
    } catch (e) {
      MyLogUtils.logDebug("_downloadPromoters failed with exception $e");
      onError("_downloadPromoters failed with exception $e");
    }
  }

  Future _downloadStoreManagers(Function onError) async {
    try {
      var localApi = locator.get<StoreManagersLocalApi>();

      var restApi = locator.get<StoreManagersApi>();

      var response = await restApi.getStoreManagers();

      MyLogUtils.logDebug(
          "_downloadStoreManagers response: ${response.storeManagers} ");

      if (response.storeManagers != null) {
        await localApi.save(response.storeManagers!);
      }
    } catch (e) {
      MyLogUtils.logDebug("_downloadStoreManagers failed with exception $e");
      onError("_downloadStoreManagers failed with exception $e");
    }
  }

  Future _downloadDirectors(Function onError) async {
    try {
      var localApi = locator.get<DirectorsLocalApi>();

      var restApi = locator.get<DirectorsApi>();

      var response = await restApi.getDirectors();

      MyLogUtils.logDebug(
          "_downloadDirectors response: ${response.directors} ");

      if (response.directors != null) {
        await localApi.save(response.directors!);
      }
    } catch (e) {
      MyLogUtils.logDebug("_downloadDirectors failed with exception $e");
      onError("_downloadDirectors failed with exception $e");
    }
  }

  Future _downloadPromotions(Function onError) async {
    try {
      var localApi = locator.get<PromotionsLocalApi>();

      var restApi = locator.get<PromotionApi>();

      var response = await restApi.getPromotions();

      MyLogUtils.logDebug(
          "_downloadPromotions response: ${response.toJson()} ");

      if (response.promotions != null) {
        await localApi.save(response.promotions!);
      }
    } catch (e) {
      MyLogUtils.logDebug("_downloadPromotions failed with exception $e");
      onError("_downloadPromotions failed with exception $e");
    }
  }

  Future _downloadDreamPrice(Function onError) async {
    try {
      var localApi = locator.get<DreamPriceLocalApi>();

      var restApi = locator.get<DreamPriceApi>();

      var response = await restApi.getDreamPrice();

      MyLogUtils.logDebug(
          "_downloadDreamPrice response: ${response.toJson()} ");

      if (response.dreamPrices != null) {
        await localApi.save(response.dreamPrices!);
      }
    } catch (e) {
      MyLogUtils.logDebug("_downloadDreamPrice failed with exception $e");
      onError("_downloadDreamPrice failed with exception $e");
    }
  }

  Future _downloadCashiers(Function onError) async {
    try {
      var localApi = locator.get<CashiersLocalApi>();

      var restApi = locator.get<CashiersApi>();

      var response = await restApi.getCashiers();

      MyLogUtils.logDebug(
          "_downloadDreamPrice response: ${response.toJson()} ");

      if (response.cashiers != null) {
        await localApi.save(response.cashiers!);
      }
    } catch (e) {
      MyLogUtils.logDebug("_downloadCashiers failed with exception $e");
      onError("_downloadCashiers failed with exception $e");
    }
  }

  Future _downloadCustomerTypes(Function onError) async {
    try {
      var localApi = locator.get<CustomerTypesLocalApi>();

      var restApi = locator.get<CustomerApi>();

      var response = await restApi.getCustomerTypes();

      MyLogUtils.logDebug(
          "_downloadCustomerTypes response: ${response.toJson()} ");

      if (response.types != null) {
        await localApi.save(response.types!);
      }
    } catch (e) {
      MyLogUtils.logDebug("_downloadCustomerTypes failed with exception $e");
      onError("_downloadCustomerTypes failed with exception $e");
    }
  }

  Future _downloadComplimentaryReasons(Function onError) async {
    try {
      var localApi = locator.get<ComplimentaryReasonLocalApi>();

      var restApi = locator.get<ComplimentaryApi>();

      var response = await restApi.getReasons();

      MyLogUtils.logDebug(
          "_downloadDreamPrice response: ${response.toJson()} ");

      if (response.complimentaryItemReasons != null) {
        await localApi.save(response.complimentaryItemReasons!);
      }
    } catch (e) {
      MyLogUtils.logDebug(
          "_downloadComplimentaryReasons failed with exception $e");
      onError("_downloadComplimentaryReasons failed with exception $e");
    }
  }

  Future _downloadVoucherConfiguration(Function onError) async {
    try {
      var localApi = locator.get<VoucherConfigLocalApi>();

      var restApi = locator.get<VoucherApi>();

      var response = await restApi.getVoucherConfigurations();

      MyLogUtils.logDebug(
          "_downloadVoucherConfiguration response: ${response.toJson()} ");

      if (response.voucherConfiguration != null) {
        await localApi.save(response.voucherConfiguration!);
      }
    } catch (e) {
      MyLogUtils.logDebug(
          "_downloadVoucherConfiguration failed with exception $e");
      onError("_downloadVoucherConfiguration failed with exception $e");
    }
  }

  Future downloadVouchersList(Function onError, Function callback) async {
    var api = locator.get<VoucherApi>();
    var pageNo = 1;
    const itemsPerPage = 1000;
    List<String> addedProductIds = List.empty(growable: true);

    try {
      var localProductsApi = locator.get<VouchersLocalApi>();
      var currentPageFromApi = 0;
      var lastPageFromApi = 0;

      do {
        var response = await api.getVouchers(pageNo, itemsPerPage);

        currentPageFromApi = response.currentPage!;
        lastPageFromApi = response.lastPage!;

        if (response.vouchers != null) {
          response.vouchers?.forEach((element) {
            addedProductIds.add(element.number ?? '');
          });
          await localProductsApi.save(response.vouchers!);
        }
        pageNo += 1;

        callback("Downloading vouchers page $pageNo of $lastPageFromApi");
      } while (currentPageFromApi < lastPageFromApi);

      var allProducts = await localProductsApi.getAll();

      // Delete the products that are not in this new products list
      for (var value in allProducts) {
        if (!addedProductIds.contains(value.number ?? "")) {
          callback("downloadVouchersList To be deleted value : ${value.id}");
          await localProductsApi.delete(value.number ?? '');
        }
      }
    } catch (e) {
      MyLogUtils.logDebug(
          "downloadVouchersList failed in page: $pageNo & exception : $e");
      onError("Failed to download vouchers in page : $pageNo");
    }
  }

  // Future downloadVouchersList(Function onError, Function callback) async {
  //   var api = locator.get<VoucherApi>();
  //   var pageNo = 1;
  //   const itemsPerPage = 1000;
  //
  //   try {
  //     var localApi = locator.get<VouchersLocalApi>();
  //     var currentPageFromApi = 0;
  //     var lastPageFromApi = 0;
  //
  //     await localApi.deleteAll();
  //     do {
  //       var response = await api.getVouchers(pageNo, itemsPerPage);
  //
  //       MyLogUtils.logDebug(
  //           "_downloadVouchersList response: ${response.toJson()}");
  //
  //       currentPageFromApi = response.currentPage!;
  //       lastPageFromApi = response.lastPage!;
  //       if (response.vouchers != null) {
  //         await localApi.save(response.vouchers!);
  //       }
  //       pageNo += 1;
  //       callback("Downloading vouchers page $pageNo of $lastPageFromApi");
  //       MyLogUtils.logDebug(
  //           "Downloading vouchers page $pageNo of $lastPageFromApi");
  //     } while (currentPageFromApi < lastPageFromApi);
  //   } catch (e) {
  //     MyLogUtils.logDebug(
  //         "_downloadVouchersList failed in page: $pageNo & exception : $e");
  //     onError("Failed to _downloadVouchersList in page : $pageNo");
  //   }
  // }

  Future _downloadCashBacks(Function onError) async {
    try {
      var localApi = locator.get<CashBacksLocalApi>();

      var restApi = locator.get<CashBacksApi>();

      var response = await restApi.getAllCashBacks();

      MyLogUtils.logDebug(
          "_downloadCashBacks response: ${response.cashbacks} ");

      if (response.cashbacks != null) {
        await localApi.save(response.cashbacks!);
      }
    } catch (e) {
      MyLogUtils.logDebug("_downloadCashBacks failed with exception $e");
      onError("_downloadCashBacks failed with exception $e");
    }
  }

  Future _downloadCashMovement(Function onError) async {
    try {
      var localApi = locator.get<CashMovementLocalApi>();

      var restApi = locator.get<CashMovementApi>();

      var response = await restApi.getCashMovementReasons();

      MyLogUtils.logDebug(
          "_downloadCashMovement response: ${response.cashMovementReasons} ");

      if (response.cashMovementReasons != null) {
        await localApi.save(response.cashMovementReasons!);
      }
    } catch (e) {
      MyLogUtils.logDebug("_downloadCashMovement failed with exception $e");
      onError("_downloadCashMovement failed with exception $e");
    }
  }

  Future _downloadStores(Function onError) async {
    try {
      var localApi = locator.get<UserLocalApi>();

      var localCounterApi = locator.get<CounterLocalApi>();

      var restApi = locator.get<MeApi>();

      var response = await restApi.currentUser();

      await localApi.saveCurrentUser(response);

      if (response.cashier != null) {
        if (response.store != null) {
          await localCounterApi.saveStore(response.store!);
        }

        if (response.counter != null) {
          await localCounterApi.saveCounter(response.counter!);
        }
      }
    } catch (e) {
      MyLogUtils.logDebug("_downloadPromoters failed with exception $e");
      onError("_downloadPromoters failed with exception $e");
    }
  }

  Future _downloadDenominations(Function onError) async {
    try {
      var localApi = locator.get<DenominationsLocalApi>();

      var restApi = locator.get<DenominationApi>();

      var response = await restApi.getDenominations();

      if (response.denominationKey != null) {
        await localApi.save(response.denominationKey!);
      }
    } catch (e) {
      MyLogUtils.logDebug("_downloadDenominations failed with exception $e");
      onError("_downloadDenominations failed with exception $e");
    }
  }

  Future _downloadMembershipDetails(Function onError) async {
    try {
      var localApi = locator.get<MemberShipsLocalApi>();

      var restApi = locator.get<CustomerApi>();

      var response = await restApi.getMembershipDetails();

      if (response.memberships != null) {
        await localApi.save(response.memberships!);
      }
    } catch (e) {
      MyLogUtils.logDebug(
          "_downloadMembershipDetails failed with exception $e");
      onError("_downloadMembershipDetails failed with exception $e");
    }
  }

  Future _downloadSaleReturnReasons(Function onError) async {
    try {
      var localApi = locator.get<SaleReturnReasonLocalApi>();

      var restApi = locator.get<SalesApi>();

      var response = await restApi.getSaleReturnsReason();

      if (response.saleReturnReasons != null) {
        await localApi.save(response.saleReturnReasons!);
      }
    } catch (e) {
      MyLogUtils.logDebug("_downloadCashMovement failed with exception $e");
      onError("_downloadCashMovement failed with exception $e");
    }
  }

  Future _downloadCompanyConfiguration(Function onError) async {
    try {
      var localApi = locator.get<CompanyConfigLocalApi>();

      var restApi = locator.get<CompanyConfigurationApi>();

      var response = await restApi.getCompanyConfiguration();

      await localApi.save(response);
    } catch (e) {
      MyLogUtils.logDebug(
          "_downloadCompanyConfiguration failed with exception $e");
      onError("_downloadCompanyConfiguration failed with exception $e");
    }
  }

  Future downloadGiftCards(Function onError) async {
    var api = locator.get<GiftCardsApi>();
    var pageNo = 1;
    const itemsPerPage = 1000;

    try {
      var localApi = locator.get<GiftCardsLocalApi>();
      var currentPageFromApi = 0;
      var lastPageFromApi = 0;

      await localApi.deleteAll();
      do {
        var response = await api.getGiftCards(pageNo, itemsPerPage);

        currentPageFromApi = response.currentPage!;
        lastPageFromApi = response.lastPage!;

        if (response.giftCards != null) {
          await localApi.save(response.giftCards!);
        }
        pageNo += 1;
      } while (currentPageFromApi < lastPageFromApi);
    } catch (e) {
      MyLogUtils.logDebug(
          "downloadGiftCards failed in page: $pageNo & exception : $e");
      onError("Failed to downloadGiftCards in page : $pageNo");
    }
  }

  Future _downloadLoyaltyCampaigns(Function onError) async {
    try {
      var localApi = locator.get<LoyaltyCampaignsLocalApi>();

      var restApi = locator.get<LoyaltyCampaignsApi>();

      var response = await restApi.getLoyaltyCampaigns();

      if (response.loyaltyCampaigns != null) {
        await localApi.save(response.loyaltyCampaigns!);
      }
    } catch (e) {
      onError("_downloadCashMovement failed with exception $e");
    }
  }

  Future _downloadHoldSaleTypes(Function onError) async {
    try {
      var localApi = locator.get<HoldSaleTypesLocalApi>();

      var restApi = locator.get<SalesApi>();

      var response = await restApi.getHoldSaleTypes();

      if (response.types != null) {
        await localApi.save(response.types!);
      }
    } catch (e) {
      MyLogUtils.logDebug("_downloadHoldSaleTypes failed with exception $e");
      onError("_downloadHoldSaleTypes failed with exception $e");
    }
  }

  Future _downloadMemberGroup(Function onError) async {
    try {
      var localApi = locator.get<MemberGroupLocalApi>();

      var restApi = locator.get<CustomerApi>();

      var response = await restApi.getMemberGroup();

      if (response.memberGroup != null) {
        await localApi.save(response.memberGroup!);
      }
    } catch (e) {
      MyLogUtils.logDebug("_downloadMemberGroup failed with exception $e");
      onError("_downloadMemberGroup failed with exception $e");
    }
  }

  Future _downloadEmployeesGroup(Function onError) async {
    try {
      var localApi = locator.get<EmployeeGroupLocalApi>();

      var restApi = locator.get<EmployeesApi>();

      var response = await restApi.getEmployeeGroup();

      if (response.employeeGroup != null) {
        /// MyLogUtils.logDebug("getEmployeeGroup response jsonEncode : ${jsonEncode(response.employeeGroup)}");
        await localApi.save(response.employeeGroup!);
      }
    } catch (e) {
      MyLogUtils.logDebug("_downloadEmployeesGroup failed with exception $e");
      onError("_downloadEmployeesGroup failed with exception $e");
    }
  }

  Future _downloadLoyaltyPointVoucherConfiguration(Function onError) async {
    try {
      var localApi = locator.get<LoyaltyPointVoucherConfigurationLocalApi>();

      var restApi = locator.get<LoyaltyPointVoucherConfigurationApi>();

      var response = await restApi.getLoyaltyPointVoucherConfiguration();

      await localApi.save(response);

      MyLogUtils.logDebug(
          "_downloadLoyaltyPointVoucherConfiguration done");
    } catch (e) {
      MyLogUtils.logDebug(
          "_downloadLoyaltyPointVoucherConfiguration failed with exception $e");
      onError("_downloadLoyaltyPointVoucherConfiguration failed with exception $e");
    }
  }

  Future _downloadPriceOverrideTypes(Function onError) async {
    try {
      var localApi = locator.get<PriceOverrideTypesLocalApi>();

      var restApi = locator.get<PriceOverrideTypesApi>();

      var response = await restApi.getPriceOverrideTypes();

      if (response.priceOverrideTypes != null) {
        await localApi.save(response.priceOverrideTypes!);
      }
    } catch (e) {
      MyLogUtils.logDebug("_downloadPriceOverrideTypes failed with exception $e");
      onError("_downloadPriceOverrideTypes failed with exception $e");
    }
  }

}
