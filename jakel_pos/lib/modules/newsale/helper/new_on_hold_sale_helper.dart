import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/sales/model/NewOnHoldSaleRequest.dart';
import 'package:jakel_base/sale/get_extra_details_from_mbb.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/my_date_utils.dart';
import 'package:jakel_base/utils/num_utils.dart';

Future<NewOnHoldSaleRequest> getOnHoldSaleRequestFromCartSummary(
    CartSummary cartSummary, String offlineSaleId, int typeID) async {
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
      int? isExchange = 0;

      if (element.isNewItemForExchange != null &&
          element.isNewItemForExchange == true) {
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
            complimentaryItemDiscount:
                element.cartItemFocData?.complimentaryItemReasonId != null
                    ? element.getDiscountAmount() > 0
                        ? element.getDiscountAmount()
                        : null
                    : null,
            itemDiscountAmount: element.getDiscountAmount() > 0
                ? element.getDiscountAmount()
                : null));
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

  //Add Voucher Configs
  List<SaleVoucherConfigs> voucherConfigs = List.empty(growable: true);

  MyLogUtils.logDebug(
      "cartSummary selectedVoucherConfigs length  : ${cartSummary.selectedVoucherConfigs?.length}");

  // Make sure configuration id is difference.
  // Here, for multiple already selectedVoucherConfigs is added mulitple times.
  // Now here after iterating if we get voucher config again, it will be double tripple times.
  // Since,again for each configuration 2 or 3 vouchers can be created.

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

  /// Request
  var request = NewOnHoldSaleRequest(
    offlineSaleId: cartSummary.offlineSaleId,
    memberId: customerId,
    typeId: typeID,
    employeeId: employeeId,
    member: newMember,
    items: items,
    returnItems: returnItems,
    changeDue: getRoundedDoubleValue(cartSummary.changeDue),
    payments: payments,
    extraDetails: extraDetails,
    saleNotes: cartSummary.remarks,
    billReferenceNumber: cartSummary.billReferenceNumber,
    happenedAt: cartSummary.happenedAt ?? dateTimeYmdHis(),
    cashbackAmount:
        cartSummary.cashBackAmount != null ? cartSummary.cashBackAmount! : null,
    cashbackId: cartSummary.cashbackId != null ? cartSummary.cashbackId! : null,
    voucherDiscountAmount: cartSummary.voucherDiscountAmount != null
        ? cartSummary.voucherDiscountAmount!
        : null,
    voucherNumber: cartSummary.voucherCode,
    vouchers: voucherConfigs.isNotEmpty ? voucherConfigs : null,
    isLayaway: (cartSummary.isLayAwaySale == true) ? 1 : 0,
    saleRoundOffAmount: cartSummary.cartPrice?.roundOff ?? 0,
    totalTaxAmount: getRoundedDoubleValue(cartSummary.cartPrice?.tax ?? 0) > 0
        ? getRoundedDoubleValue(cartSummary.cartPrice?.tax ?? 0)
        : 0,
    cartPromotionId: cartSummary.promotionData?.cartWideDiscount?.id,
    cartPriceOverrideAmount:
        cartSummary.cartCustomDiscount?.priceOverrideAmount,
    cashierId: cartSummary.cartCustomDiscount?.cashier?.id,
    storeManagerId: cartSummary.cartCustomDiscount?.manager?.id,
    storeManagerPasscode: cartSummary.cartCustomDiscount?.manager?.passcode,
    directorId: cartSummary.cartCustomDiscount?.directors?.id,
    directorPasscode: cartSummary.cartCustomDiscount?.directors?.passcode,
  );

  return request;
}
