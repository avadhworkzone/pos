import 'dart:convert';

import 'package:jakel_base/restapi/promoters/model/PromotersResponse.dart';
import 'package:jakel_base/restapi/sales/model/SaleReturnsResponse.dart';
import 'package:jakel_base/utils/num_utils.dart';

import '../../../creditnotes/model/CreditNotesResponse.dart';
import '../../../products/model/ProductsResponse.dart';
import '../../../vouchers/model/VouchersListResponse.dart';
import 'SaveSaleResponse.dart';

/// sales : [{"id":28,"offline_sale_id":"1660113582322","user_type":"Customer","user_details":{"first_name":"Test","last_name":"Test","email":"te.st@gmail.com","mobile_number":"123456789"},"user_id":1,"total_tax_amount":27.52,"total_amount_paid":73.85,"layaway_pending_amount":0.5,"sale_items":[{"id":30,"product_id":6,"product":{"id":6,"name":"product 6189minus name 819817856","upc":"15749665238","has_batch":true},"quantity":1,"returned_quantity":0,"cart_discount_amount":0,"item_discount_amount":0,"total_discount_amount":0,"total_tax_amount":27.52,"original_price_per_unit":46.33,"price_paid_per_unit":73.85,"total_price_paid":73.85,"promoters":[{"id":1,"first_name":"Shanel Kessler","last_name":"Kristin Sporer"}]}],"payments":[{"id":28,"payment_type":{"id":1,"name":"Cash"},"amount":73.85}],"status":"Regular Sale","sale_notes":"Sales notes goes here","happened_at":"2022-06-24 05:20:50","has_mismatch":false,"sale_mismatches":["","",""]}]
/// total_records : 28
/// last_page : 28
/// current_page : 1
/// per_page : 1
/// Sale? sale,

SalesResponse regularSalesResponseFromJson(String str) =>
    SalesResponse.fromJson(json.decode(str));

String regularSalesResponseToJson(SalesResponse data) =>
    json.encode(data.toJson());

class SalesResponse {
  SalesResponse({
    Sales? sale,
    List<Sales>? sales,
    List<Sales>? saleReturns,
    List<Sales>? pendingLayawaySales,
    int? totalRecords,
    int? lastPage,
    int? currentPage,
    int? perPage,
  }) {
    _sale = sale;
    _sales = sales;
    _saleReturns = saleReturns;
    _pendingLayawaySales = pendingLayawaySales;
    _totalRecords = totalRecords;
    _lastPage = lastPage;
    _currentPage = currentPage;
    _perPage = perPage;
  }

  SalesResponse.fromJson(dynamic json) {
    _sale = json['sale'] != null ? Sales.fromJson(json['sale']) : null;
    if (json['sales'] != null) {
      _sales = [];
      json['sales'].forEach((v) {
        _sales?.add(Sales.fromJson(v));
      });
    }

    if (json['sale_returns'] != null) {
      _saleReturns = [];
      json['sale_returns'].forEach((v) {
        _saleReturns?.add(Sales.fromJson(v));
      });
    }

    if (json['pending_layaway_sales'] != null) {
      _pendingLayawaySales = [];
      json['pending_layaway_sales'].forEach((v) {
        _pendingLayawaySales?.add(Sales.fromJson(v));
      });
    }
    _totalRecords = json['total_records'];
    _lastPage = json['last_page'];
    _currentPage = json['current_page'];
    _perPage = json['per_page'];
  }

  Sales? _sale;
  List<Sales>? _sales;
  List<Sales>? _saleReturns;
  List<Sales>? _pendingLayawaySales;
  int? _totalRecords;
  int? _lastPage;
  int? _currentPage;
  int? _perPage;

  Sales? get sale => _sale;

  List<Sales>? get sales => _sales;

  List<Sales>? get saleReturns => _saleReturns;

  List<Sales>? get pendingLayawaySales => _pendingLayawaySales;

  int? get totalRecords => _totalRecords;

  int? get lastPage => _lastPage;

  int? get currentPage => _currentPage;

  int? get perPage => _perPage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (_sale != null) {
      map['sale'] = _sale?.toJson();
    }

    if (_sales != null) {
      map['sales'] = _sales?.map((v) => v.toJson()).toList();
    }
    if (_saleReturns != null) {
      map['sale_returns'] = _saleReturns?.map((v) => v.toJson()).toList();
    }

    if (_pendingLayawaySales != null) {
      map['pending_layaway_sales'] =
          _pendingLayawaySales?.map((v) => v.toJson()).toList();
    }
    map['total_records'] = _totalRecords;
    map['last_page'] = _lastPage;
    map['current_page'] = _currentPage;
    map['per_page'] = _perPage;
    return map;
  }
}

/// id : 28
/// offline_sale_id : "1660113582322"
/// user_type : "Customer"
/// user_details : {"first_name":"Test","last_name":"Test","email":"te.st@gmail.com","mobile_number":"123456789"}
/// user_id : 1
/// total_tax_amount : 27.52
/// total_amount_paid : 73.85
/// layaway_pending_amount : 0.5
/// sale_items : [{"id":30,"product_id":6,"product":{"id":6,"name":"product 6189minus name 819817856","upc":"15749665238","has_batch":true},"quantity":1,"returned_quantity":0,"cart_discount_amount":0,"item_discount_amount":0,"total_discount_amount":0,"total_tax_amount":27.52,"original_price_per_unit":46.33,"price_paid_per_unit":73.85,"total_price_paid":73.85,"promoters":[{"id":1,"first_name":"Shanel Kessler","last_name":"Kristin Sporer"}]}]
/// payments : [{"id":28,"payment_type":{"id":1,"name":"Cash"},"amount":73.85}]
/// status : "Regular Sale"
/// sale_notes : "Sales notes goes here"
/// bill_reference_number  : ""
/// happened_at : "2022-06-24 05:20:50"
/// has_mismatch : false
/// sale_mismatches : ["","",""]

Sales salesFromJson(String str) => Sales.fromJson(json.decode(str));

String salesToJson(Sales data) => json.encode(data.toJson());

class Sales {
  Sales({
    int? id,
    String? counterOpenedAt,
    String? offlineSaleId,
    String? offlineSaleReturnId,
    String? userType,
    UserDetails? userDetails,
    UsedVoucherInSale? usedVoucher,
    CreditNotes? creditNote,
    CashierDetails? cashierDetails,
    CounterDetails? counterDetails,
    int? userId,
    double? totalDiscountAmount,
    double? totalTaxAmount,
    double? totalAmountPaid,
    double? layawayPendingAmount,
    double? changeDue,
    double? saleRoundOffAmount,
    List<SaleItems>? saleItems,
    List<SaleItems>? saleReturnItems,
    List<Payments>? payments,
    List<Vouchers>? vouchers,
    List<Cashback>? cashback,
    List<CreditNotes>? creditNotes,
    String? status,
    String? saleNotes,
    String? billReferenceNumber,
    String? happenedAt,
    bool? hasMismatch,
    List<String>? saleMismatches,
    String? voidReason,
    List<String>? extraDetails,
  }) {
    _id = id;
    _counterOpenedAt = counterOpenedAt; // Used Locally For Offline
    _offlineSaleId = offlineSaleId;
    _offlineSaleReturnId = offlineSaleReturnId;
    _userType = userType;
    _usedVoucher = usedVoucher;
    _userDetails = userDetails;
    _creditNote = creditNote;
    _cashierDetails = cashierDetails;
    _counterDetails = counterDetails;
    _userId = userId;
    _totalTaxAmount = totalTaxAmount;
    _totalAmountPaid = totalAmountPaid;
    _saleRoundOffAmount = saleRoundOffAmount;
    _totalDiscountAmount = totalDiscountAmount;
    _layawayPendingAmount = layawayPendingAmount;
    _saleItems = saleItems;
    _saleReturnItems = saleReturnItems;
    _payments = payments;
    _vouchers = vouchers;
    _cashback = cashback;
    _status = status;
    _saleNotes = saleNotes;
    _billReferenceNumber = billReferenceNumber;
    _happenedAt = happenedAt;
    _hasMismatch = hasMismatch;
    _saleMismatches = saleMismatches;
    _voidReason = voidReason;
    _creditNotes = creditNotes;
    _extraDetails = extraDetails;
  }

  Sales.fromJson(dynamic json) {
    _id = json['id'];
    _counterOpenedAt = json['counterOpenedAt']; // Used Locally

    _offlineSaleId = json['offline_sale_id'];
    _offlineSaleReturnId = json['offline_sale_return_id'];
    _userType = json['user_type'];
    _creditNote = json['credit_note'] != null
        ? CreditNotes.fromJson(json['credit_note'])
        : null;
    _userDetails = json['user_details'] != null
        ? UserDetails.fromJson(json['user_details'])
        : null;
    _usedVoucher = json['used_voucher'] != null
        ? UsedVoucherInSale.fromJson(json['used_voucher'])
        : null;
    _cashierDetails = json['cashier'] != null
        ? CashierDetails.fromJson(json['cashier'])
        : null;
    _counterDetails = json['counter'] != null
        ? CounterDetails.fromJson(json['counter'])
        : null;
    _userId = json['user_id'];
    _totalTaxAmount = getDoubleValue(json['total_tax_amount']);
    _totalAmountPaid = getDoubleValue(json['total_amount_paid']);
    _layawayPendingAmount = getDoubleValue(json['layaway_pending_amount']);
    _totalDiscountAmount = getDoubleValue(json['total_discount_amount']);
    _changeDue = getDoubleValue(json['change_due']);
    _saleRoundOffAmount = getDoubleValue(json['round_off_amount'])??getDoubleValue(json['round_off']);
    if (json['sale_items'] != null) {
      _saleItems = [];
      json['sale_items'].forEach((v) {
        _saleItems?.add(SaleItems.fromJson(v));
      });
    }
    if (json['sale_return_items'] != null) {
      _saleReturnItems = [];
      json['sale_return_items'].forEach((v) {
        _saleReturnItems?.add(SaleItems.fromJson(v));
      });
    }

    if (json['payments'] != null) {
      _payments = [];
      json['payments'].forEach((v) {
        _payments?.add(Payments.fromJson(v));
      });
    }

    if (json['credit_notes'] != null) {
      _creditNotes = [];
      json['credit_notes'].forEach((v) {
        _creditNotes?.add(CreditNotes.fromJson(v));
      });
    }

    if (json['vouchers'] != null) {
      _vouchers = [];
      json['vouchers'].forEach((v) {
        _vouchers?.add(Vouchers.fromJson(v));
      });
    }

    if (json['cashback'] != null) {
      _cashback = [];
      json['cashback'].forEach((v) {
        _cashback?.add(Cashback.fromJson(v));
      });
    }

    _status = json['status'];
    _saleNotes = json['sale_notes'];
    _billReferenceNumber = json['bill_reference_number'];
    _happenedAt = json['happened_at'];
    _hasMismatch = getBoolValue(json['has_mismatch']);
    _voidReason = json['void_reason'];
    _saleMismatches = json['sale_mismatches'] != null
        ? json['sale_mismatches'].cast<String>()
        : [];
    _extraDetails = json['extra_details'] != null
        ? json['extra_details'].cast<String>()
        : [];
  }

  int? _id;
  String? _counterOpenedAt; // Used locally for syncing offline sale
  String? _offlineSaleId;
  String? _offlineSaleReturnId;
  String? _userType;
  UserDetails? _userDetails;
  UsedVoucherInSale? _usedVoucher;
  CreditNotes? _creditNote;
  CashierDetails? _cashierDetails;
  CounterDetails? _counterDetails;
  int? _userId;
  double? _totalTaxAmount;
  double? _totalAmountPaid;
  double? _layawayPendingAmount;
  double? _totalDiscountAmount;
  double? _changeDue;
  double? _saleRoundOffAmount;
  List<SaleItems>? _saleItems;
  List<SaleItems>? _saleReturnItems;
  List<Payments>? _payments;
  List<Vouchers>? _vouchers;
  List<Cashback>? _cashback;
  String? _status;
  String? _saleNotes;
  String? _billReferenceNumber;
  String? _happenedAt;
  bool? _hasMismatch;
  List<String>? _saleMismatches;
  String? _voidReason;
  List<String>? _extraDetails;
  List<CreditNotes>? _creditNotes;

  int? get id => _id;

  String? get offlineSaleId => _offlineSaleId;

  // Used locally for offline sale support
  String? get counterOpenedAt => _counterOpenedAt;

  setCounterOpenedAt(String openedAt) {
    _counterOpenedAt = openedAt;
  }

  String? get offlineSaleReturnId => _offlineSaleReturnId;

  CreditNotes? get creditNote => _creditNote;

  String? get userType => _userType;

  String? get voidReason => _voidReason;

  UserDetails? get userDetails => _userDetails;

  UsedVoucherInSale? get usedVoucher => _usedVoucher;

  CashierDetails? get cashierDetails => _cashierDetails;

  CounterDetails? get counterDetails => _counterDetails;

  int? get userId => _userId;

  double? get totalTaxAmount => _totalTaxAmount;

  double? get totalAmountPaid => _totalAmountPaid;

  double? get layawayPendingAmount => _layawayPendingAmount;

  double? get totalDiscountAmount => _totalDiscountAmount;

  double? get changeDue => _changeDue;

  double? get saleRoundOffAmount => _saleRoundOffAmount;

  List<SaleItems>? get saleItems => _saleItems;

  List<SaleItems>? get saleReturnItems => _saleReturnItems;

  List<Payments>? get payments => _payments;

  List<CreditNotes>? get creditNotes => _creditNotes;

  List<Vouchers>? get vouchers => _vouchers;

  List<Cashback>? get cashback => _cashback;

  String? get status => _status;

  String? get saleNotes => _saleNotes;

  String? get billReferenceNumber => _billReferenceNumber;

  String? get happenedAt => _happenedAt;

  bool? get hasMismatch => _hasMismatch;

  List<String>? get saleMismatches => _saleMismatches;

  List<String>? get extraDetails => _extraDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;

    // Used locally for offline support
    map['counterOpenedAt'] = _counterOpenedAt;

    map['offline_sale_id'] = _offlineSaleId;
    map['offline_sale_return_id'] = _offlineSaleReturnId;

    map['user_type'] = _userType;

    if (_creditNote != null) {
      map['credit_note'] = _creditNote?.toJson();
    }

    if (_usedVoucher != null) {
      map['used_voucher'] = _usedVoucher?.toJson();
    }

    if (_userDetails != null) {
      map['user_details'] = _userDetails?.toJson();
    }
    if (_cashierDetails != null) {
      map['cashier'] = _cashierDetails?.toJson();
    }
    if (_counterDetails != null) {
      map['counter'] = _counterDetails?.toJson();
    }
    map['user_id'] = _userId;
    map['void_reason'] = _voidReason;
    map['total_tax_amount'] = _totalTaxAmount;
    map['total_amount_paid'] = _totalAmountPaid;
    map['layaway_pending_amount'] = _layawayPendingAmount;
    map['total_discount_amount'] = _totalDiscountAmount;
    map['round_off_amount'] = _saleRoundOffAmount;
    map['change_due'] = _changeDue;

    if (_saleItems != null) {
      map['sale_items'] = _saleItems?.map((v) => v.toJson()).toList();
    }

    if (_saleReturnItems != null) {
      map['sale_return_items'] =
          _saleReturnItems?.map((v) => v.toJson()).toList();
    }

    if (_payments != null) {
      map['payments'] = _payments?.map((v) => v.toJson()).toList();
    }

    if (_vouchers != null) {
      map['vouchers'] = _vouchers?.map((v) => v.toJson()).toList();
    }

    if (_cashback != null) {
      map['cashback'] = _cashback?.map((v) => v.toJson()).toList();
    }

    if (_creditNotes != null) {
      map['credit_notes'] = _creditNotes?.map((v) => v.toJson()).toList();
    }

    map['status'] = _status;
    map['sale_notes'] = _saleNotes;
    map['bill_reference_number'] = _billReferenceNumber;
    map['happened_at'] = _happenedAt;
    map['has_mismatch'] = _hasMismatch;
    map['sale_mismatches'] = _saleMismatches;
    map['extra_details'] = _extraDetails;
    return map;
  }
}

/// id : 28
/// payment_type : {"id":1,"name":"Cash"}
/// amount : 73.85

Payments paymentsFromJson(String str) => Payments.fromJson(json.decode(str));

String paymentsToJson(Payments data) => json.encode(data.toJson());

class Payments {
  Payments(
      {int? id, PaymentType? paymentType, double? amount, String? happenedAt}) {
    _id = id;
    _paymentType = paymentType;
    _amount = amount;
    _happenedAt = happenedAt;
  }

  Payments.fromJson(dynamic json) {
    _id = json['id'];
    try {
      _paymentType = json['payment_type'] != null
          ? PaymentType.fromJson(json['payment_type'])
          : null;
    } catch (e) {
      _paymentType = json['payment_type'] != null
          ? PaymentType(name: json['payment_type'])
          : null;
    }
    _amount = getDoubleValue(json['amount']);
    _happenedAt = json['happened_at'];
  }

  int? _id;
  PaymentType? _paymentType;
  double? _amount;
  String? _happenedAt;

  Payments copyWith({
    int? id,
    PaymentType? paymentType,
    double? amount,
    String? happenedAt,
  }) =>
      Payments(
        id: id ?? _id,
        paymentType: paymentType ?? _paymentType,
        amount: amount ?? _amount,
        happenedAt: happenedAt ?? _happenedAt,
      );

  int? get id => _id;

  PaymentType? get paymentType => _paymentType;

  double? get amount => _amount;

  String? get happenedAt => _happenedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    if (_paymentType != null) {
      map['payment_type'] = _paymentType?.toJson();
    }
    map['amount'] = _amount;
    map['happened_at'] = _happenedAt;
    return map;
  }
}

/// id : 1
/// name : "Cash"

PaymentType paymentTypeFromJson(String str) =>
    PaymentType.fromJson(json.decode(str));

String paymentTypeToJson(PaymentType data) => json.encode(data.toJson());

/// id : 30
/// product_id : 6
/// product : {"id":6,"name":"product 6189minus name 819817856","upc":"15749665238","has_batch":true}
/// quantity : 1
/// returned_quantity : 0
/// cart_discount_amount : 0
/// item_discount_amount : 0
/// total_discount_amount : 0
/// total_tax_amount : 27.52
/// original_price_per_unit : 46.33
/// price_paid_per_unit : 73.85
/// total_price_paid : 73.85
/// promoters : [{"id":1,"first_name":"Shanel Kessler","last_name":"Kristin Sporer"}]

SaleItems saleItemsFromJson(String str) => SaleItems.fromJson(json.decode(str));

String saleItemsToJson(SaleItems data) => json.encode(data.toJson());

class Cashback {
  Cashback({
    int? id,
    String? name,
    double? amount,
  }) {
    _id = id;
    _name = name;
    _amount = amount;
  }

  Cashback.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _amount = getDoubleValue(json['amount']);
  }

  int? _id;
  String? _name;
  double? _amount;

  int? get id => _id;

  String? get name => _name;

  double? get amount => _amount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['amount'] = _amount;
    return map;
  }
}

class SaleItems {
  SaleItems({
    int? id,
    int? productId,
    Product? product,
    SaleReturnReasons? saleReturnReason,
    SaleComplimentary? complimentary,
    double? quantity,
    double? returnedQuantity,
    double? cartDiscountAmount,
    double? itemDiscountAmount,
    double? totalDiscountAmount,
    double? totalTaxAmount,
    double? originalPricePerUnit,
    double? pricePaidPerUnit,
    double? totalPricePaid,
    List<Promoters>? promoters,
  }) {
    _id = id;
    _productId = productId;
    _saleReturnReason = saleReturnReason;
    _complimentary = complimentary;
    _product = product;
    _quantity = quantity;
    _returnedQuantity = returnedQuantity;
    _cartDiscountAmount = cartDiscountAmount;
    _itemDiscountAmount = itemDiscountAmount;
    _totalDiscountAmount = totalDiscountAmount;
    _totalTaxAmount = totalTaxAmount;
    _originalPricePerUnit = originalPricePerUnit;
    _pricePaidPerUnit = pricePaidPerUnit;
    _totalPricePaid = totalPricePaid;
    _promoters = promoters;
  }

  SaleItems.fromJson(dynamic json) {
    _id = json['id'];
    _productId = json['product_id'];
    _product =
    json['product'] != null ? Product.fromJson(json['product']) : null;
    _saleReturnReason = json['sale_return_reason'] != null
        ? SaleReturnReasons.fromJson(json['sale_return_reason'])
        : null;
    _complimentary = json['complimentary'] != null
        ? SaleComplimentary.fromJson(json['complimentary'])
        : null;
    _quantity = getDoubleValue(json['quantity']);
    _returnedQuantity = getDoubleValue(json['returned_quantity']);
    _cartDiscountAmount = getDoubleValue(json['cart_discount_amount']);
    _itemDiscountAmount = getDoubleValue(json['item_discount_amount']);
    _totalDiscountAmount = getDoubleValue(json['total_discount_amount']);
    _totalTaxAmount = getDoubleValue(json['total_tax_amount']);
    _originalPricePerUnit = getDoubleValue(json['original_price_per_unit']);
    _pricePaidPerUnit = getDoubleValue(json['price_paid_per_unit']);
    _totalPricePaid = getDoubleValue(json['total_price_paid']);
    if (json['promoters'] != null) {
      _promoters = [];
      json['promoters'].forEach((v) {
        _promoters?.add(Promoters.fromJson(v));
      });
    }
  }

  int? _id;
  int? _productId;
  Product? _product;
  SaleReturnReasons? _saleReturnReason;
  SaleComplimentary? _complimentary;
  double? _quantity;
  double? _returnedQuantity;
  double? _cartDiscountAmount;
  double? _itemDiscountAmount;
  double? _totalDiscountAmount;
  double? _totalTaxAmount;
  double? _originalPricePerUnit;
  double? _pricePaidPerUnit;
  double? _totalPricePaid;
  List<Promoters>? _promoters;

  int? get id => _id;

  int? get productId => _productId;

  Product? get product => _product;

  SaleReturnReasons? get saleReturnReason => _saleReturnReason;

  SaleComplimentary? get complimentary => _complimentary;

  double? get quantity => _quantity;

  double? get returnedQuantity => _returnedQuantity;

  double? get cartDiscountAmount => _cartDiscountAmount;

  double? get itemDiscountAmount => _itemDiscountAmount;

  double? get totalDiscountAmount => _totalDiscountAmount;

  double? get totalTaxAmount => _totalTaxAmount;

  double? get originalPricePerUnit => _originalPricePerUnit;

  double? get pricePaidPerUnit => _pricePaidPerUnit;

  double? get totalPricePaid => _totalPricePaid;

  List<Promoters>? get promoters => _promoters;

  void setPromoters(List<Promoters> promoters) {
    _promoters = promoters;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['product_id'] = _productId;
    if (_product != null) {
      map['product'] = _product?.toJson();
    }

    if (_saleReturnReason != null) {
      map['sale_return_reason'] = _saleReturnReason?.toJson();
    }

    if (_complimentary != null) {
      map['complimentary'] = _complimentary?.toJson();
    }

    map['quantity'] = _quantity;
    map['returned_quantity'] = _returnedQuantity;
    map['cart_discount_amount'] = _cartDiscountAmount;
    map['item_discount_amount'] = _itemDiscountAmount;
    map['total_discount_amount'] = _totalDiscountAmount;
    map['total_tax_amount'] = _totalTaxAmount;
    map['original_price_per_unit'] = _originalPricePerUnit;
    map['price_paid_per_unit'] = _pricePaidPerUnit;
    map['total_price_paid'] = _totalPricePaid;
    if (_promoters != null) {
      map['promoters'] = _promoters?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 1
/// first_name : "Shanel Kessler"
/// last_name : "Kristin Sporer"

Promoters promotersFromJson(String str) => Promoters.fromJson(json.decode(str));

String promotersToJson(Promoters data) => json.encode(data.toJson());

/// id : 6
/// name : "product 6189minus name 819817856"
/// upc : "15749665238"
/// has_batch : true

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    int? id,
    String? name,
    String? upc,
    bool? hasBatch,
    String? articleNumber,
    ProductColor? color,
    Size? size,
    ProductType? productType,
    List<Size>? groupedSize, // used locally
    List<ProductColor>? groupedColor, // used locally
  }) {
    _id = id;
    _name = name;
    _upc = upc;
    _hasBatch = hasBatch;
    _articleNumber = articleNumber;
    _productType = productType;
    _color = color;
    _size = size;
  }

  Product.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _upc = json['upc'];
    _hasBatch = json['has_batch'];
    _articleNumber = json['article_number'];
    _color =
    json['color'] != null ? ProductColor.fromJson(json['color']) : null;
    _size = json['size'] != null ? Size.fromJson(json['size']) : null;
    _productType =
    json['type_id'] != null ? ProductType.fromJson(json['type_id']) : null;
    // Used local only
    if (json['groupedColorSize'] != null) {
      _groupedColorSize = [];
      json['groupedColorSize'].forEach((v) {
        _groupedColorSize?.add(v);
      });
    }
  }

  int? _id;
  String? _name;
  String? _upc;
  bool? _hasBatch;
  String? _articleNumber;
  ProductColor? _color;
  Size? _size;
  List<String>? _groupedColorSize;
  ProductType? _productType;// Used local only

  int? get id => _id;

  String? get name => _name;

  String? get upc => _upc;

  bool? get hasBatch => _hasBatch;

  String? get articleNumber => _articleNumber;

  ProductColor? get color => _color;

  Size? get size => _size;

  ProductType? get productType => _productType;

  // Used local only for printing
  List<String?>? get groupedColorSize => _groupedColorSize;

  void setGroupedColorSize(List<String> groupedColorSize) {
    _groupedColorSize = groupedColorSize;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['upc'] = _upc;
    map['has_batch'] = _hasBatch;
    map['article_number'] = _articleNumber;
    if (_productType != null) {
      map['type_id'] = _productType?.toJson();
    }
    if (_color != null) {
      map['color'] = _color?.toJson();
    }
    if (_size != null) {
      map['size'] = _size?.toJson();
    }

    // Used local only
    if (_groupedColorSize != null) {
      map['groupedColor'] = _groupedColorSize?.map((v) => v).toList();
    }
    return map;
  }
}

/// first_name : "Test"
/// last_name : "Test"
/// email : "te.st@gmail.com"
/// mobile_number : "123456789"

UserDetails userDetailsFromJson(String str) =>
    UserDetails.fromJson(json.decode(str));

String userDetailsToJson(UserDetails data) => json.encode(data.toJson());

class UserDetails {
  UserDetails({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? mobileNumber,
    double? previousPoints,
    double? currentSalePoints,
    double? accumulatedPoints,
  }) {
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _mobileNumber = mobileNumber;
    _previousPoints = previousPoints;
    _currentSalePoints = currentSalePoints;
    _accumulatedPoints = accumulatedPoints;
  }

  UserDetails.fromJson(dynamic json) {
    _id = json['id'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _email = json['email'];
    _mobileNumber = json['mobile_number'];
    _previousPoints = getDoubleValue(json['previous_points']);
    _currentSalePoints = getDoubleValue(json['current_sale_points']);
    _accumulatedPoints = getDoubleValue(json['accumulated_points']);
  }
  int? _id;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _mobileNumber;
  double? _previousPoints;
  double? _currentSalePoints;
  double? _accumulatedPoints;

  int? get id => _id;

  String? get firstName => _firstName;

  String? get lastName => _lastName;

  String? get email => _email;

  set currentSalePoints(double? value) {
    _currentSalePoints = value;
  }

  String? get mobileNumber => _mobileNumber;

  double? get previousPoints => _previousPoints;

  double? get currentSalePoints => _currentSalePoints;

  double? get accumulatedPoints => _accumulatedPoints;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['email'] = _email;
    map['mobile_number'] = _mobileNumber;
    map['previous_points'] = _previousPoints;
    map['current_sale_points'] = _currentSalePoints;
    map['accumulated_points'] = _accumulatedPoints;

    return map;
  }
}

// "used_voucher": {
// "id": 4,
// "amount": "30.72"
// },

UsedVoucherInSale usedVoucherInSaleFromJson(String str) =>
    UsedVoucherInSale.fromJson(json.decode(str));

String usedVoucherInSaleToJson(UserDetails data) => json.encode(data.toJson());

class UsedVoucherInSale {
  UsedVoucherInSale(
      {double? amount, int? id, String? voucherType, String? number}) {
    _amount = amount;
    _id = id;
    _voucherType = voucherType;
    _number = number;
  }

  UsedVoucherInSale.fromJson(dynamic json) {
    _amount = getDoubleValue(json['amount']);
    _voucherType = json['voucher_type'];
    _id = json['id'];
    _number = json['number'];
  }

  double? _amount;

  int? _id;

  String? _voucherType;

  String? _number;

  double? get amount => _amount;

  int? get id => _id;

  String? get voucherType => _voucherType;

  String? get number => _number;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['amount'] = _amount;
    map['id'] = _id;
    map['voucher_type'] = _voucherType;
    map['number'] = _number;

    return map;
  }
}

// "cashier": {
// "id": 1,
// "first_name": "Hettie Olson",
// "last_name": "Erik Walter"
// },

CashierDetails cashierDetailsFromJson(String str) =>
    CashierDetails.fromJson(json.decode(str));

String cashierDetailsToJson(UserDetails data) => json.encode(data.toJson());

class CashierDetails {
  CashierDetails({
    String? firstName,
    String? lastName,
    int? id,
  }) {
    _firstName = firstName;
    _lastName = lastName;
    _id = id;
  }

  CashierDetails.fromJson(dynamic json) {
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _id = json['id'];
  }

  String? _firstName;
  String? _lastName;
  int? _id;

  CashierDetails copyWith({
    String? firstName,
    String? lastName,
    int? id,
  }) =>
      CashierDetails(
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
        id: id ?? _id,
      );

  String? get firstName => _firstName;

  String? get lastName => _lastName;

  int? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['id'] = _id;
    return map;
  }
}

// "cashier": {
// "id": 1,
// "name": "Hettie Olson",
// },

CounterDetails counterDetailsFromJson(String str) =>
    CounterDetails.fromJson(json.decode(str));

String counterDetailsToJson(UserDetails data) => json.encode(data.toJson());

class CounterDetails {
  CounterDetails({
    String? name,
    int? id,
  }) {
    _name = name;
    _id = id;
  }

  CounterDetails.fromJson(dynamic json) {
    _name = json['name'];
    _id = json['id'];
  }

  String? _name;
  int? _id;

  CounterDetails copyWith({
    String? name,
    int? id,
  }) =>
      CounterDetails(
        name: name ?? _name,
        id: id ?? _id,
      );

  String? get name => _name;

  int? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['id'] = _id;
    return map;
  }
}

SaleComplimentary saleComplimentaryFromJson(String str) =>
    SaleComplimentary.fromJson(json.decode(str));

String saleComplimentaryToJson(SaleComplimentary data) =>
    json.encode(data.toJson());

class SaleComplimentary {
  SaleComplimentary({
    this.authorizer,
    this.amount,
  });

  SaleComplimentary.fromJson(dynamic json) {
    authorizer = json['authorizer'];
    amount = getDoubleValue(json['amount']);
  }

  String? authorizer;
  double? amount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['authorizer'] = authorizer;
    map['amount'] = amount;
    return map;
  }
}
