import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/database/sale/model/PaymentTypeData.dart';
import 'package:jakel_base/restapi/bookingpayment/model/NewBookingRequest.dart';
import 'package:jakel_base/restapi/bookingpayment/model/ResetBookingRequest.dart';
import 'package:jakel_base/restapi/managers/model/StoreManagersResponse.dart';
import 'package:jakel_base/restapi/sales/model/NewSaleRequest.dart';
import 'package:jakel_base/restapi/sales/model/UpdateLoyaltyPointsRequest.dart';
import 'package:jakel_base/sale/get_extra_details_from_mbb.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/my_date_utils.dart';
import 'package:jakel_base/utils/num_utils.dart';

import '../../vouchers/validate/voucher_config_service.dart';

Future<ResetBookingRequest> getResetBookingRequestObject(
    CartSummary cartSummary, String offlineSaleId) async {
  List<ResetBookingProducts> items = List.empty(growable: true);
  cartSummary.cartItems?.forEach((element) {
    List<int> promoterIds = List.empty(growable: true);
    element.promoters?.forEach((element) {
      promoterIds.add(element.id ?? 0);
    });

    items.add(ResetBookingProducts(
        productId: element.product!.id!,
        promoterIds: promoterIds,
        quantity: getDoubleValue(element.qty)));
  });

  List<int> promoterIds = List.empty(growable: true);

  cartSummary.promoters?.forEach((element) {
    promoterIds.add(element.id ?? 0);
  });

  ///ResetBookingRequest
  var request = ResetBookingRequest(
    products: items,
    promoterIds: promoterIds,
  );
  return request;
}

Future<NewBookingRequest> getNewBookingRequestObject(CartSummary cartSummary,
    String offlineSaleId, StoreManagers? mStoreManagers) async {
  int? customerId = cartSummary.customers?.id;
  List<NewBookingProducts> items = List.empty(growable: true);
  cartSummary.cartItems?.forEach((element) {
    List<int> promoterIds = List.empty(growable: true);
    element.promoters?.forEach((element) {
      promoterIds.add(element.id ?? 0);
    });

    items.add(NewBookingProducts(
        productId: element.product!.id!,
        promoterIds: promoterIds,
        quantity: getInValue(element.qty)));
  });

  // This is used mainly because offline sale.
  // In this customer details will be attached along with sale.
  NewMember? newMember;
  if (cartSummary.customers != null && cartSummary.customers?.id == null) {
    newMember = NewMember(
      firstName: cartSummary.customers?.firstName,
      typeId: cartSummary.customers?.typeDetails?.id,
      mobileNumber: cartSummary.customers?.mobileNumber,
      cardNumber: cartSummary.customers?.cardNumber,
    );
  }

  PaymentTypeData? paymentTypeData;
  cartSummary.payments?.forEach((element) {
    if (element.amount > 0) {
      paymentTypeData = element;
    }
  });

  List<int> promoterIds = List.empty(growable: true);

  cartSummary.promoters?.forEach((element) {
    promoterIds.add(element.id ?? 0);
  });

  ///StoreManager
  var storeManagerId = "store_manager_id";
  var storeManagerPasscode = "store_manager_passcode";
  if (mStoreManagers != null) {
    storeManagerId = mStoreManagers.id.toString();
    storeManagerPasscode = mStoreManagers.passcode.toString();
  }

  ///NewBookingRequest
  var request = NewBookingRequest(
      offlineId: offlineSaleId,
      products: items,
      member: newMember,
      customerId: customerId,
      promoterIds: promoterIds,
      amount: paymentTypeData?.amount,
      billReferenceNumber: cartSummary.billReferenceNumber,
      remarks: cartSummary.remarks,
      paymentTypeId: paymentTypeData?.paymentType!.id,
      storeManagerId: storeManagerId,
      storeManagerPasscode: storeManagerPasscode,
      happenedAt: dateTimeYmdHis());
  return request;
}

Future<NewSaleRequest> getSaleRequestForNewSale(
    CartSummary cartSummary,
    VoucherConfigService voucherConfigService,
    String offlineSaleId,
    StoreManagers? mStoreManager) async {
  cartSummary.offlineSaleId = offlineSaleId;

  if (cartSummary.happenedAt == null || cartSummary.happenedAt!.isEmpty) {
    cartSummary.happenedAt = dateTimeYmdHis();
  }

  int? customerId = cartSummary.customers?.id;

  int? employeeId = cartSummary.employees?.id;

  /// Add items
  List<Items> items = List.empty(growable: true);
  List<SaleReturnItems> returnItems = List.empty(growable: true);

  cartSummary.cartItems?.forEach((element) {
    List<int>? promoterIds;

    if (element.promoters != null && element.promoters!.isNotEmpty) {
      promoterIds = List.empty(growable: true);
      element.promoters?.forEach((element) {
        promoterIds!.add(element.id!);
      });
    }

    if (element.saleReturnsItemData == null) {
      double qty = getDoubleValue(element.getDerivativeQty());
      double price = element.getOriginalProductPrice();

      int? isExchange;

      if (element.isNewItemForExchange == true) {
        qty = element.qty ?? 0;
        isExchange = 1;
      }

      if (element.itemWisePromotionData?.promotionId != null ||
          element.cartItemFocData?.complimentaryItemReasonId != null) {
        items.add(Items(
            quantity: qty,
            id: element.product?.id,
            price: price,
            openPrice: element.openPrice,
            totalPricePaid: element.cartItemPrice?.totalAmount ?? 0,
            isExchange: isExchange,
            dreamPriceAmount: element.cartItemDreamPriceData?.dreamPrice,
            dreamPriceId: element.cartItemDreamPriceData?.dreamPriceId,
            promoterIds: promoterIds,
            isGiftWithPurchase:
                element.makeItGiftWithPurchase == true ? true : null,
            batchNumber: element.batchNumber,
            batchDetails: element.batchDetails ?? [],
            promotionId: element.itemWisePromotionData?.promotionId,
            groupId: element.itemWisePromotionData?.promotionGroupId,
            priceOverrideAmount:
                element.cartItemPriceOverrideData?.priceOverrideAmount,
            cashierId: element.cartItemPriceOverrideData?.cashierId,
            storeManagerId: element.cartItemFocData?.storeManagerId ??
                element.cartItemPriceOverrideData?.storeManagerId,
            storeManagerPasscode:
                element.cartItemFocData?.storeManagerPasscode ??
                    element.cartItemPriceOverrideData?.storeManagerPasscode,
            directorId: element.cartItemPriceOverrideData?.directorId,
            directorPasscode:
                element.cartItemPriceOverrideData?.directorPasscode,
            complimentaryItemReasonId:
                element.cartItemFocData?.complimentaryItemReasonId,
            complimentaryItemDiscount: element.isComplementaryItem()
                ? element.getDiscountAmount() > 0
                    ? element.getDiscountAmount()
                    : null
                : null,
            itemDiscountAmount: element.isComplementaryItem()
                ? element.getDiscountAmount()
                : element.cartItemPrice?.automaticItemDiscount));
      } else {
        items.add(Items(
          quantity: qty,
          id: element.product?.id,
          price: price,
          openPrice: element.openPrice,
          totalPricePaid: element.cartItemPrice?.totalAmount ?? 0,
          isExchange: isExchange,
          dreamPriceAmount: element.cartItemDreamPriceData?.dreamPrice,
          dreamPriceId: element.cartItemDreamPriceData?.dreamPriceId,
          promoterIds: promoterIds,
          isGiftWithPurchase:
              element.makeItGiftWithPurchase == true ? true : null,
          batchNumber: element.batchNumber,
          batchDetails: element.batchDetails ?? [],
          priceOverrideAmount:
              element.cartItemPriceOverrideData?.priceOverrideAmount,
          cashierId: element.cartItemPriceOverrideData?.cashierId,
          storeManagerId: element.cartItemPriceOverrideData?.storeManagerId,
          storeManagerPasscode:
              element.cartItemPriceOverrideData?.storeManagerPasscode,
          directorId: element.cartItemPriceOverrideData?.directorId,
          directorPasscode: element.cartItemPriceOverrideData?.directorPasscode,
        ));
      }
    } else {
      var saleReturnItems = SaleReturnItems();

      List<SaleReturnDetails> saleReturnDetails = List.empty(growable: true);

      saleReturnDetails.add(SaleReturnDetails(
          quantity: getInValue(element.qty),
          saleReturnReasonId: element.saleReturnsItemData?.reason?.id ?? 1,
          batchNumber: element.saleReturnsItemData?.batchNumber));

      saleReturnItems.saleReturnDetails = saleReturnDetails;

      saleReturnItems.quantity = getInValue(element.qty);

      saleReturnItems.pricePaidPerUnit = element.getPricePaidPerUnitInReturns();

      saleReturnItems.saleItemId =
          element.saleReturnsItemData?.saleItem?.id ?? 0;
      returnItems.add(saleReturnItems);
    }
  });

  //Add Payments
  List<PaidPayments> payments = List.empty(growable: true);
  cartSummary.payments?.forEach((element) {
    if (element.amount > 0) {
      var paidPayment = PaidPayments(
          typeId: element.paymentType?.id,
          amount: element.amount,
          creditNoteId: element.creditNoteId,
          giftCardId: element.giftCardId,
          loyaltyPoints: element.loyaltyPoints,
          bookingPaymentId: element.bookingPayments?.id);
      payments.add(paidPayment);
    }
  });

  //Add Loyalty Points
  List<LoyaltyPoints> loyaltyPoints = List.empty(growable: true);
  cartSummary.loyaltyPoints?.forEach((element) {
    if ((element.points ?? 0) > 0) {
      var eachLoyaltyPoint = LoyaltyPoints(
        loyaltyCampaignID: element.loyaltyCampaignID,
        minSpendAmount: element.minSpendAmount,
        points: element.points,
        expiredAt: element.expiredAt,
      );
      loyaltyPoints.add(eachLoyaltyPoint);
    }
  });

  //Add Voucher Configs
  List<SaleVoucherConfigs> voucherConfigs = List.empty(growable: true);

  MyLogUtils.logDebug(
      "cartSummary selectedVoucherConfigs length  : ${cartSummary.selectedVoucherConfigs?.length}");

  // Make sure configuration id is difference.
  // Here, for multiple already selectedVoucherConfigs is added mulitple times.
  // Now here after iterating if we get voucher config again, it will be double tripple times.
  // Since,again for each configuration 2 or 3 vouchers can be created.

  int alreadyAddedVoucherConfigId = 0;
  cartSummary.selectedVoucherConfigs?.forEach((element) {
    if (alreadyAddedVoucherConfigId != element.id) {
      alreadyAddedVoucherConfigId = element.id ?? 0;
      var baseVoucherConfig = voucherConfigService.getVoucherConfig(element);
      MyLogUtils.logDebug(
          "New Sale Helper selected voucher config: $baseVoucherConfig");

      if (baseVoucherConfig != null) {
        List<SaleVoucherConfigs>? config =
            baseVoucherConfig.getSaleVoucherConfig(cartSummary, element);
        if (config != null) {
          for (var element in config) {
            MyLogUtils.logDebug(
                "New Sale Helper selected voucher element: $element");
            voucherConfigs.add(element);
          }
        }
      }
    }
  });

  cartSummary.voucherConfigs = voucherConfigs;

  MyLogUtils.logDebug(
      "cartSummary voucherConfigs  length  : ${voucherConfigs.length}");

  // This is used mainly because offline sale.
  // In this customer details will be attached along with sale.
  NewMember? newMember;
  if (cartSummary.customers != null && cartSummary.customers?.id == null) {
    newMember = NewMember(
      firstName: cartSummary.customers?.firstName,
      typeId: cartSummary.customers?.typeDetails?.id,
      mobileNumber: cartSummary.customers?.mobileNumber,
      cardNumber: cartSummary.customers?.cardNumber,
    );
  }

  List<String>? extraDetails = getExtraDetailsFromMbb(cartSummary);

  // Manually added card no is added here .
  cartSummary.payments?.forEach((element) {
    if (element.cardNo != null && element.cardNo!.isNotEmpty) {
      extraDetails ??= List.empty(growable: true);
      extraDetails?.add(element.paymentType?.name ?? '');
      extraDetails?.add("No : ${element.cardNo}");
    }
  });

  ///StoreManager
  var layawayStoreManagerId = "";
  var layawayStoreManagerPasscode = "";
  if (mStoreManager != null) {
    layawayStoreManagerId = mStoreManager.id.toString();
    layawayStoreManagerPasscode = mStoreManager.passcode.toString();
  }

  /// Request
  var request = NewSaleRequest(
      offlineSaleId: cartSummary.offlineSaleId,
      memberId: customerId,
      employeeId: employeeId,
      member: newMember,
      items: items,
      returnItems: returnItems,
      changeDue: getRoundedDoubleValue(cartSummary.changeDue),
      layawayPendingAmount: (cartSummary.isLayAwaySale == true)
          ? getRoundedDoubleValue(cartSummary.getDueAmount())
          : null,
      payments: payments,
      extraDetails: extraDetails,
      saleNotes: cartSummary.remarks,
      billReferenceNumber: cartSummary.billReferenceNumber,
      happenedAt: cartSummary.happenedAt ?? dateTimeYmdHis(),
      cashbackAmount: cartSummary.cashBackAmount != null
          ? cartSummary.cashBackAmount!
          : null,
      cashbackId:
          cartSummary.cashbackId != null ? cartSummary.cashbackId! : null,
      voucherDiscountAmount: cartSummary.voucherDiscountAmount != null
          ? cartSummary.voucherDiscountAmount!
          : null,
      voucherNumber: cartSummary.voucherCode,
      vouchers: voucherConfigs.isNotEmpty ? voucherConfigs : null,
      isLayaway: (cartSummary.isLayAwaySale == true) ? 1 : null,
      saleRoundOffAmount: cartSummary.isExchangeOrReturns()
          ? cartSummary.cartPrice?.newSaleRoundOff
          : cartSummary.cartPrice?.roundOff,
      saleReturnRoundOffAmount: cartSummary.cartPrice?.returnRoundOff,
      totalTaxAmount: getRoundedDoubleValue(cartSummary.cartPrice?.tax) > 0
          ? getRoundedDoubleValue(cartSummary.cartPrice?.tax)
          : 0,
      cartPromotionId: cartSummary.promotionData?.cartWideDiscount?.id,
      cartPriceOverrideAmount:
          cartSummary.cartCustomDiscount?.priceOverrideAmount,
      cashierId: cartSummary.cartCustomDiscount?.cashier?.id,
      storeManagerId: cartSummary.cartCustomDiscount?.manager?.id,
      storeManagerPasscode: cartSummary.cartCustomDiscount?.manager?.passcode,
      directorId: cartSummary.cartCustomDiscount?.directors?.id,
      directorPasscode: cartSummary.cartCustomDiscount?.directors?.passcode,
      layawayStoreManagerId: layawayStoreManagerId,
      layawayStoreManagerPasscode: layawayStoreManagerPasscode,
      cartDiscountAmount: cartSummary.cartPrice?.totalCartDiscountAmount);

  return request;
}
