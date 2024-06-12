import 'dart:convert';

import 'package:jakel_base/restapi/sales/model/UpdateLoyaltyPointsRequest.dart';
import 'package:jakel_base/utils/num_utils.dart';

/// offline_sale_id : ""
/// member_id : 1
/// items : [{"id":1,"batch_number":"","price":1.05,"quantity":10.50}]
/// vouchers :[{"voucher_configuration_id":1,"discount_type":1,"number":1,"minimum_spend_amount":1,"percentage":"1,"flat_amount":1,"expired_at":null}]
/// payments : [{"type_id":1,"amount":1.05}]
/// sale_notes : ""
/// bill_reference_number :""
/// happened_at : ""
/// is_layaway : 1
/// cart_promotion_id : 1
/// dream_price_id : 1
/// dream_price_amount:10.0
/// cashback_id
/// cashback_amount

NewSaleRequest newSaleRequestFromJson(String str) =>
    NewSaleRequest.fromJson(json.decode(str));

String newSaleRequestToJson(NewSaleRequest data) => json.encode(data.toJson());

class NewSaleRequest {
  NewSaleRequest({
    int? storeManagerId,
    String? storeManagerPasscode,
    int? directorId,
    String? directorPasscode,
    int? cashierId,
    double? cartPriceOverrideAmount,
    String? offlineSaleId,
    int? memberId,
    int? employeeId,
    List<Items>? items,
    List<String>? extraDetails,
    NewMember? member,
    List<SaleVoucherConfigs>? vouchers,
    List<SaleReturnItems>? returnItems,
    List<PaidPayments>? payments,
    String? saleNotes,
    String? billReferenceNumber,
    String? happenedAt,
    int? isLayaway,
    double? layawayPendingAmount,
    int? cartPromotionId,
    String? voucherNumber,
    int? cashbackId,
    double? cashbackAmount,
    double? saleRoundOffAmount,
    double? saleReturnRoundOffAmount,
    double? totalTaxAmount,
    double? changeDue,
    double? voucherDiscountAmount,
    String? layawayStoreManagerId,
    String? layawayStoreManagerPasscode,
    double? cartDiscountAmount,
  }) {
    _storeManagerId = storeManagerId;
    _storeManagerPasscode = storeManagerPasscode;
    _directorId = directorId;
    _directorPasscode = directorPasscode;
    _cashierId = cashierId;
    _cartPriceOverrideAmount = cartPriceOverrideAmount;
    _offlineSaleId = offlineSaleId;
    _memberId = memberId;
    _employeeId = employeeId;
    _items = items;
    _member = member;
    _extraDetails = extraDetails;
    _payments = payments;
    _saleNotes = saleNotes;
    _billReferenceNumber = billReferenceNumber;
    _happenedAt = happenedAt;
    _isLayaway = isLayaway;
    _cartPromotionId = cartPromotionId;
    _returnItems = returnItems;
    _voucherNumber = voucherNumber;
    _voucherDiscountAmount = voucherDiscountAmount;
    _vouchers = vouchers;
    _cashbackId = cashbackId;
    _saleRoundOffAmount = saleRoundOffAmount;
    _saleReturnRoundOffAmount = saleReturnRoundOffAmount;
    _cashbackAmount = cashbackAmount;
    _totalTaxAmount = totalTaxAmount;
    _changeDue = changeDue;
    _layawayPendingAmount = layawayPendingAmount;
    _layawayStoreManagerId = layawayStoreManagerId;
    _layawayStoreManagerPasscode = layawayStoreManagerPasscode;
    _cartDiscountAmount = cartDiscountAmount;
  }

  NewSaleRequest.fromJson(dynamic json) {
    _offlineSaleId = json['offline_sale_id'];
    _cashbackAmount = json['cashback_amount'];
    _totalTaxAmount = getDoubleValue(json['total_tax_amount']);
    _cashbackId = json['cashback_id'];
    _changeDue = getDoubleValue(json['change_due']);
    _layawayPendingAmount = getDoubleValue(json['layaway_pending_amount']);
    _extraDetails = json['extra_details'] != null
        ? json['extra_details'].cast<String>()
        : [];

    _memberId = json['member_id'];
    _employeeId = json['employee_id'];
    _layawayPendingAmount = getDoubleValue(json['layaway_pending_amount']);
    _member =
        json['member'] != null ? NewMember.fromJson(json['member']) : null;

    if (json['items'] != null) {
      _items = [];
      json['items'].forEach((v) {
        _items?.add(Items.fromJson(v));
      });
    }

    if (json['vouchers'] != null) {
      _vouchers = [];
      json['vouchers'].forEach((v) {
        _vouchers?.add(SaleVoucherConfigs.fromJson(v));
      });
    }

    if (json['return_items'] != null) {
      _returnItems = [];
      json['return_items'].forEach((v) {
        _returnItems?.add(SaleReturnItems.fromJson(v));
      });
    }

    if (json['payments'] != null) {
      _payments = [];
      json['payments'].forEach((v) {
        _payments?.add(PaidPayments.fromJson(v));
      });
    }
    _saleNotes = json['sale_notes'];
    _billReferenceNumber = json['bill_eference_umber'];
    _happenedAt = json['happened_at'];
    _isLayaway = json['is_layway'];
    _cartPromotionId = json['cart_promotion_id'];
    _voucherNumber = json['voucher_number'];
    _layawayStoreManagerId = json['layaway_store_manager_id'];
    _layawayStoreManagerPasscode = json['layaway_store_manager_passcode'];
    _saleRoundOffAmount = getDoubleValue(json['sale_round_off_amount']);
    _saleReturnRoundOffAmount =
        getDoubleValue(json['sale_return_round_off_amount']);
    _voucherDiscountAmount = getDoubleValue(json['voucher_discount_amount']);

    if (json['store_manager_id'] != null) {
      _storeManagerId = json['store_manager_id'];
    }
    if (json['store_manager_passcode'] != null) {
      _storeManagerPasscode = json['store_manager_passcode'];
    }
    if (json['director_id'] != null) {
      _directorId = json['director_id'];
    }
    if (json['director_passcode'] != null) {
      _directorPasscode = json['director_passcode'];
    }
    if (json['cashier_id'] != null) {
      _cashierId = json['cashier_id'];
    }
    if (json['cart_price_override_amount'] != null) {
      _cartPriceOverrideAmount =
          getDoubleValue(json['cart_price_override_amount']);
    }
    if (json['cart_discount_amount'] != null) {
      _cartDiscountAmount =
          getDoubleValue(json['cart_discount_amount']);
    }
  }

  int? _storeManagerId;
  String? _storeManagerPasscode;
  int? _directorId;
  String? _directorPasscode;
  int? _cashierId;
  double? _cartPriceOverrideAmount;
  String? _offlineSaleId;
  int? _cashbackId;
  double? _cashbackAmount;
  double? _totalTaxAmount;
  int? _memberId;
  int? _employeeId;
  NewMember? _member;
  List<Items>? _items;
  List<String>? _extraDetails;
  List<PaidPayments>? _payments;
  String? _saleNotes;
  String? _billReferenceNumber;
  String? _happenedAt;
  int? _isLayaway;
  int? _cartPromotionId;
  List<SaleReturnItems>? _returnItems;
  List<SaleVoucherConfigs>? _vouchers;
  String? _voucherNumber;
  double? _voucherDiscountAmount;
  double? _saleRoundOffAmount;
  double? _saleReturnRoundOffAmount;
  double? _changeDue;
  double? _layawayPendingAmount;
  String? _layawayStoreManagerId;
  String? _layawayStoreManagerPasscode;
  double? _cartDiscountAmount;

  String? get offlineSaleId => _offlineSaleId;

  NewMember? get member => _member;

  int? get customerId => _memberId;

  int? get employee_id => _employeeId;

  List<String>? get extraDetails => _extraDetails;

  int? get isLayaway => _isLayaway;

  List<Items>? get items => _items;

  List<PaidPayments>? get payments => _payments;

  String? get saleNotes => _saleNotes;

  String? get happenedAt => _happenedAt;

  int? get cartPromotionId => _cartPromotionId;

  String? get voucherNumber => _voucherNumber;

  String? get layawayStoreManagerId => _layawayStoreManagerId;

  String? get layawayStoreManagerPasscode => _layawayStoreManagerPasscode;

  String? get billReferenceNumber => _billReferenceNumber;

  double? get voucherDiscountAmount => _voucherDiscountAmount;

  double? get cashbackAmount => _cashbackAmount;

  double? get saleRoundOffAmount => _saleRoundOffAmount;

  double? get saleReturnRoundOffAmount => _saleReturnRoundOffAmount;

  double? get totalTaxAmount => _totalTaxAmount;

  double? get changeDue => _changeDue;

  double? get layawayPendingAmount => _layawayPendingAmount;

  int? get cashbackId => _cashbackId;

  List<SaleReturnItems>? get returnItems => _returnItems;

  List<SaleVoucherConfigs>? get vouchers => _vouchers;

  int? get storeManagerId => _storeManagerId;

  String? get storeManagerPasscode => _storeManagerPasscode;

  int? get directorId => _directorId;

  String? get directorPasscode => _directorPasscode;

  double? get cartPriceOverrideAmount => _cartPriceOverrideAmount;

  int? get cashierId => _cashierId;
  double? get cartDiscountAmount => _cartDiscountAmount;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['offline_sale_id'] = _offlineSaleId;

    if (_storeManagerId != null) {
      map['store_manager_id'] = _storeManagerId;
    }

    if (_storeManagerPasscode != null) {
      map['store_manager_passcode'] = _storeManagerPasscode;
    }

    if (_directorId != null) {
      map['director_id'] = _directorId;
    }

    if (_directorPasscode != null) {
      map['director_passcode'] = _directorPasscode;
    }

    // This is for Cart level price override feature.
    //if ((_cartPriceOverrideAmount ?? 0) > 0) {
    map['cart_price_override_amount'] = _cartPriceOverrideAmount;

    if (_cashierId != null) {
      map['cashier_id'] = _cashierId;
    }
    //}

    if (_cashbackId != null) {
      map['cashback_id'] = _cashbackId;
    }

    if (_cashbackAmount != null) {
      map['cashback_amount'] = _cashbackAmount;
    }

    map['member_id'] = _memberId;

    map['employee_id'] = _employeeId;

    if (_extraDetails != null) {
      map['extra_details'] = _extraDetails?.map((v) => v).toList();
    }

    if (_member != null) {
      map['member'] = _member?.toJson();
    }

    if (_items != null) {
      map['items'] = _items?.map((v) => v.toJson()).toList();
    }

    if (_returnItems != null) {
      map['return_items'] = _returnItems?.map((v) => v.toJson()).toList();
    }

    if (_payments != null) {
      map['payments'] = _payments?.map((v) => v.toJson()).toList();
    }

    if (_vouchers != null) {
      map['vouchers'] = _vouchers?.map((v) => v.toJson()).toList();
    }
    map['sale_notes'] = _saleNotes;
    map['bill_reference_number'] = _billReferenceNumber;

    map['happened_at'] = _happenedAt;
    map['is_layaway'] = _isLayaway;
    map['cart_promotion_id'] = _cartPromotionId;
    map['voucher_number'] = _voucherNumber;
    map['layaway_store_manager_id'] = _layawayStoreManagerId;
    map['layaway_store_manager_passcode'] = _layawayStoreManagerPasscode;
    map['voucher_discount_amount'] = _voucherDiscountAmount;
    map['sale_round_off_amount'] = _saleRoundOffAmount;
    map['sale_return_round_off_amount'] = _saleReturnRoundOffAmount;
    map['total_tax_amount'] = _totalTaxAmount;
    map['change_due'] = _changeDue;
    map['layaway_pending_amount'] = _layawayPendingAmount;
    map['cart_discount_amount'] = _cartDiscountAmount;
    return map;
  }
}

NewMember newMemberFromJson(String str) => NewMember.fromJson(json.decode(str));

String newMemberToJson(PaidPayments data) => json.encode(data.toJson());

class NewMember {
  NewMember(
      {int? typeId,
      String? firstName,
      String? mobileNumber,
      String? cardNumber}) {
    _typeId = typeId;
    _firstName = firstName;
    _mobileNumber = mobileNumber;
    _cardNumber = cardNumber;
  }

  NewMember.fromJson(dynamic json) {
    _typeId = json['type_id'];
    _firstName = json['first_name'];
    _mobileNumber = json['mobile_number'];
    _cardNumber = json['card_number'];
  }

  int? _typeId;
  String? _firstName;
  String? _mobileNumber;
  String? _cardNumber;

  int? get typeId => _typeId;

  String? get firstName => _firstName;

  String? get mobileNumber => _mobileNumber;

  String? get cardNumber => _cardNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type_id'] = _typeId;
    map['first_name'] = _firstName;
    map['mobile_number'] = _mobileNumber;
    map['card_number'] = _cardNumber;
    return map;
  }
}

/// type_id : 1
/// amount : 1.05

PaidPayments paymentsFromJson(String str) =>
    PaidPayments.fromJson(json.decode(str));

String paymentsToJson(PaidPayments data) => json.encode(data.toJson());

class PaidPayments {
  PaidPayments(
      {int? typeId,
      int? bookingPaymentId,
      int? creditNoteId,
      int? giftCardId,
      double? amount,
      int? loyaltyPoints}) {
    _typeId = typeId;
    _amount = amount;
    _giftCardId = giftCardId;
    _creditNoteId = creditNoteId;
    _loyaltyPoints = loyaltyPoints;
    _bookingPaymentId = bookingPaymentId;
  }

  PaidPayments.fromJson(dynamic json) {
    _typeId = json['type_id'];
    _giftCardId = json['gift_card_id'];
    _creditNoteId = json['credit_note_id'];
    _bookingPaymentId = json['booking_payment_id'];
    _loyaltyPoints = json['loyalty_points'];
    _amount = getDoubleValue(json['amount']);
  }

  int? _typeId;
  int? _bookingPaymentId;
  int? _giftCardId;
  int? _creditNoteId;
  double? _amount;
  int? _loyaltyPoints;

  int? get typeId => _typeId;

  int? get giftCardId => _giftCardId;

  int? get creditNoteId => _creditNoteId;

  int? get bookingPaymentId => _bookingPaymentId;

  int? get loyaltyPoints => _loyaltyPoints;

  double? get amount => _amount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type_id'] = _typeId;
    map['amount'] = _amount;
    map['credit_note_id'] = _creditNoteId;
    map['gift_card_id'] = _giftCardId;
    map['loyalty_points'] = _loyaltyPoints;
    map['booking_payment_id'] = _bookingPaymentId;
    return map;
  }
}

class SaleVoucherConfigs {
  SaleVoucherConfigs(
      {int? voucherConfigurationId,
      int? discountType,
      String? number,
      double? minimumSpendAmount,
      double? percentage,
      double? flatAmount,
      String? expiredAt}) {
    _voucherConfigurationId = voucherConfigurationId;
    _discountType = discountType;
    _number = number;
    _minimumSpendAmount = minimumSpendAmount;
    _percentage = percentage;
    _flatAmount = flatAmount;
    _expiredAt = expiredAt;
  }

  SaleVoucherConfigs.fromJson(dynamic json) {
    _voucherConfigurationId = json['voucher_configuration_id'];
    _discountType = json['discount_type'];
    _number = json['number'];
    _minimumSpendAmount = getDoubleValue(json['minimum_spend_amount']);
    _percentage = getDoubleValue(json['percentage']);
    _flatAmount = getDoubleValue(json['flat_amount']);
    _expiredAt = json['expired_at'];
  }

  int? _voucherConfigurationId;
  int? _discountType;
  String? _number;
  double? _minimumSpendAmount;
  double? _percentage;
  double? _flatAmount;
  String? _expiredAt;

  int? get voucherConfigurationId => _voucherConfigurationId;

  int? get discountType => _discountType;

  String? get number => _number;

  double? get minimumSpendAmount => _minimumSpendAmount;

  double? get percentage => _percentage;

  double? get flatAmount => _flatAmount;

  String? get expiredAt => _expiredAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['voucher_configuration_id'] = _voucherConfigurationId;
    map['discount_type'] = _discountType;
    map['number'] = _number;
    map['minimum_spend_amount'] = _minimumSpendAmount;
    map['percentage'] = _percentage;
    map['flat_amount'] = _flatAmount;
    map['expired_at'] = _expiredAt;
    return map;
  }
}

/// id : 1
/// batch_number : ""
/// price : 1.05
/// quantity : 10.50
/// promoter_ids:[1,2]
/// is_gift_with_purchase : true or false;
/// promotion_id:1
/// group_id
/// item_discount_amount
/// complimentary_item_discount
/// dream_price_id
/// dream_price_amount
/// price_override_amount
/// cashier_id
/// store_manager_id
/// director_id
/// store_manager_passcode
/// director_passcode
/// complimentary_item_reason_id

Items itemsFromJson(String str) => Items.fromJson(json.decode(str));

String itemsToJson(Items data) => json.encode(data.toJson());

class Items {
  Items(
      {int? id,
      String? batchNumber,
      List<BatchDetails>? batchDetails,
      double? price,
      double? totalPricePaid,
      int? isExchange,
      double? quantity,
      int? derivativeId,
      List<int>? promoterIds,
      bool? isGiftWithPurchase,
      int? promotionId,
      int? groupId,
      double? itemDiscountAmount,
      int? dreamPriceId,
      double? dreamPriceAmount,
      double? priceOverrideAmount,
      double? openPrice,
      int? cashierId,
      int? storeManagerId,
      int? directorId,
      int? complimentaryItemReasonId,
      String? storeManagerPasscode,
      double? complimentaryItemDiscount,
      String? directorPasscode}) {
    _id = id;
    _complimentaryItemReasonId = complimentaryItemReasonId;
    _batchNumber = batchNumber;
    _batchDetails = batchDetails;
    _totalPricePaid = totalPricePaid;
    _price = price;
    _openPrice = openPrice;
    _quantity = quantity;
    _promoterIds = promoterIds;
    _isGiftWithPurchase = isGiftWithPurchase;
    _promotionId = promotionId;
    _groupId = groupId;
    _itemDiscountAmount = itemDiscountAmount;
    _dreamPriceAmount = dreamPriceAmount;
    _dreamPriceId = dreamPriceId;
    _priceOverrideAmount = priceOverrideAmount;
    _cashierId = cashierId;
    _storeManagerId = storeManagerId;
    _directorId = directorId;
    _storeManagerPasscode = storeManagerPasscode;
    _directorPasscode = directorPasscode;
    _complimentaryItemDiscount = complimentaryItemDiscount;
    _isExchange = isExchange;
  }

  Items.fromJson(dynamic json) {
    _id = json['id'];
    _complimentaryItemReasonId = json['complimentary_item_reason_id'];
    _batchNumber = json['batch_number'];
    if (json['batch_details'] != null) {
      _batchDetails = [];
      json['batch_details'].forEach((v) {
        _batchDetails?.add(BatchDetails.fromJson(v));
      });
    }
    _price = getDoubleValue(json['price']);
    _totalPricePaid = getDoubleValue(json['total_price_paid']);
    _complimentaryItemDiscount =
        getDoubleValue(json['complimentary_item_discount']);
    _quantity = getDoubleValue(json['quantity']);
    _derivativeId = json['derivative_id'];
    _isGiftWithPurchase = json['is_gift_with_purchase'];
    _promoterIds =
        json['promoterIds'] != null ? json['promoter_ids'].cast<int>() : [];
    _promotionId = json['promotion_id'];
    _groupId = json['group_id'];
    _promotionId = json['promotion_id'];
    _itemDiscountAmount = json['item_discount_amount'];
    _dreamPriceAmount = getDoubleValue(json['dream_price_amount']);
    _dreamPriceId = json['dream_price_id'];
    _priceOverrideAmount = getDoubleValue(json['price_override_amount']);
    _openPrice = getDoubleValue(json['open_price']);
    _cashierId = json['cashier_id'];
    _storeManagerId = json['store_manager_id'];
    _directorId = json['director_id'];
    _storeManagerPasscode = json['store_manager_passcode'];
    _directorPasscode = json['director_passcode'];
    _isExchange = json['is_exchange'];
  }

  int? _id;
  List<BatchDetails>? _batchDetails;
  String? _batchNumber;
  double? _price;
  double? _totalPricePaid;
  double? _quantity;
  double? _complimentaryItemDiscount;
  int? _derivativeId;
  List<int>? _promoterIds;
  bool? _isGiftWithPurchase;
  int? _promotionId;
  int? _groupId;
  double? _itemDiscountAmount;
  int? _dreamPriceId;
  double? _dreamPriceAmount;
  double? _priceOverrideAmount;
  double? _openPrice;
  int? _cashierId;
  int? _storeManagerId;
  int? _directorId;
  String? _storeManagerPasscode;
  String? _directorPasscode;
  int? _complimentaryItemReasonId;
  int? _isExchange;

  int? get isExchange => _isExchange;

  int? get id => _id;

  int? get complimentaryItemReasonId => _complimentaryItemReasonId;

  List<BatchDetails>? get batchDetails => _batchDetails;

  String? get batchNumber => _batchNumber;

  double? get price => _price;

  double? get totalPricePaid => _totalPricePaid;

  double? get quantity => _quantity;

  int? get derivativeId => _derivativeId;

  bool? get isGiftWithPurchase => _isGiftWithPurchase;

  List<int>? get promoterIds => _promoterIds;

  int? get promotionId => _promotionId;

  int? get groupId => _groupId;

  double? get itemDiscountAmount => _itemDiscountAmount;

  int? get dreamPriceId => _dreamPriceId;

  double? get dreamPriceAmount => _dreamPriceAmount;

  double? get openPrice => _openPrice;

  double? get complimentaryItemDiscount => _complimentaryItemDiscount;

  double? get priceOverrideAmount => _priceOverrideAmount;

  int? get cashierId => _cashierId;

  int? get storeManagerId => _storeManagerId;

  int? get directorId => _directorId;

  String? get storeManagerPasscode => _storeManagerPasscode;

  String? get directorPasscode => _directorPasscode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['batch_number'] = _batchNumber;
    map['is_exchange'] = _isExchange;
    if (_batchDetails != null && _batchDetails!.isNotEmpty) {
      map['batch_details'] = _batchDetails?.map((v) => v.toJson()).toList();
    }
    map['price'] = _price;
    map['quantity'] = _quantity;
    map['total_price_paid'] = _totalPricePaid;

    if (complimentaryItemReasonId != null && complimentaryItemReasonId! > 0) {
      map['complimentary_item_reason_id'] = _complimentaryItemReasonId;
    }

    if (_derivativeId != null) {
      map['derivative_id'] = _derivativeId;
    }

    if (_promoterIds != null) {
      map['promoter_ids'] = _promoterIds?.map((v) => v).toList();
    }

    if (_isGiftWithPurchase != null) {
      if (_isGiftWithPurchase == true) {
        map['is_gift_with_purchase'] = 1;
      }
    }

    if (_promotionId != null) {
      map['promotion_id'] = _promotionId;
    }

    if (_groupId != null) {
      map['group_id'] = _groupId;
    }

    if (_itemDiscountAmount != null) {
      map['item_discount_amount'] = _itemDiscountAmount;
    }

    if (_complimentaryItemDiscount != null) {
      map['complimentary_item_discount'] = _complimentaryItemDiscount;
    }

    if (_dreamPriceId != null) {
      map['dream_price_id'] = _dreamPriceId;
    }

    if (_dreamPriceAmount != null && _dreamPriceAmount! > 0) {
      map['dream_price_amount'] = _dreamPriceAmount;
    }

    if (_priceOverrideAmount != null && _priceOverrideAmount! > 0) {
      map['price_override_amount'] = _priceOverrideAmount;
    }

    if (_openPrice != null && _openPrice! > 0) {
      map['open_price'] = _openPrice;
    }

    if (_cashierId != null) {
      map['cashier_id'] = _cashierId;
    }

    if (_storeManagerId != null) {
      map['store_manager_id'] = _storeManagerId;
    }

    if (_directorId != null) {
      map['director_id'] = _directorId;
    }

    if (_storeManagerPasscode != null) {
      map['store_manager_passcode'] = _storeManagerPasscode;
    }

    if (_directorPasscode != null) {
      map['director_passcode'] = _directorPasscode;
    }

    return map;
  }
}

class SaleReturnItems {
  int? quantity;
  double? pricePaidPerUnit;
  int? saleItemId;
  List<SaleReturnDetails>? saleReturnDetails;

  SaleReturnItems(
      {this.quantity,
      this.pricePaidPerUnit,
      this.saleItemId,
      this.saleReturnDetails});

  factory SaleReturnItems.fromJson(dynamic json) {
    return SaleReturnItems(
        quantity: getInValue(json['quantity']),
        pricePaidPerUnit: getDoubleValue(json['price_paid_per_unit']),
        saleReturnDetails: json['sale_return_details'] != null
            ? (json['sale_return_details'] as List)
                .map((i) => SaleReturnDetails.fromJson(i))
                .toList()
            : [],
        saleItemId: json['sale_item_id']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (saleReturnDetails != null) {
      data['sale_return_details'] =
          saleReturnDetails?.map((v) => v.toJson()).toList();
    }

    if (quantity != null) {
      data['quantity'] = quantity;
    }

    if (pricePaidPerUnit != null) {
      data['price_paid_per_unit'] = pricePaidPerUnit;
    }

    if (saleItemId != null) {
      data['sale_item_id'] = saleItemId;
    }

    return data;
  }
}

class SaleReturnDetails {
  int? quantity;
  int? saleReturnReasonId;
  String? batchNumber;

  SaleReturnDetails({
    this.quantity,
    this.saleReturnReasonId,
    this.batchNumber,
  });

  factory SaleReturnDetails.fromJson(dynamic json) {
    return SaleReturnDetails(
        quantity: getInValue(json['quantity']),
        saleReturnReasonId: getInValue(json['sale_return_reason_id']),
        batchNumber: json['batch_number']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (quantity != null) {
      data['quantity'] = quantity;
    }

    if (saleReturnReasonId != null) {
      data['sale_return_reason_id'] = saleReturnReasonId;
    }

    if (batchNumber != null) {
      data['batch_number'] = batchNumber;
    }

    return data;
  }
}

class BatchDetails {
  BatchDetails({
    int? quantity,
    String? batchNumber,
    String? batchExpiryDate,
  }) {
    _quantity = quantity;
    _batchNumber = batchNumber;
    _batchExpiryDate = batchExpiryDate;
  }

  BatchDetails.fromJson(dynamic json) {
    _quantity = json['quantity'];
    _batchNumber = json['batch_number'];
    _batchExpiryDate = json['batch_expiry_date'];
  }

  int? _quantity;
  String? _batchNumber;
  String? _batchExpiryDate;

  BatchDetails copyWith({
    int? quantity,
    String? batchNumber,
    String? batchExpiryDate,
  }) =>
      BatchDetails(
        quantity: quantity ?? _quantity,
        batchNumber: batchNumber ?? _batchNumber,
        batchExpiryDate: batchExpiryDate ?? _batchExpiryDate,
      );

  int? get quantity => _quantity;

  String? get batchNumber => _batchNumber;

  String? get batchExpiryDate => _batchExpiryDate;

  setQuantity(int quantity) {
    _quantity = quantity;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['quantity'] = _quantity;
    map['batch_number'] = _batchNumber;
    map['batch_expiry_date'] = _batchExpiryDate;
    return map;
  }
}
