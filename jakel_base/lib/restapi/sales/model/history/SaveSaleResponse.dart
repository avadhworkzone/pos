import 'dart:convert';

import 'package:jakel_base/restapi/creditnotes/model/CreditNotesResponse.dart';
import 'package:jakel_base/utils/num_utils.dart';

import '../../../promoters/model/PromotersResponse.dart';
import '../../../vouchers/model/VouchersListResponse.dart';
import 'SalesResponse.dart';

/// sale : {"id":28,"offline_sale_id":"1660113582322","user_type":"Customer","user_details":{"first_name":"Test","last_name":"Test","email":"te.st@gmail.com","mobile_number":"123456789"},"user_id":1,"total_tax_amount":27.52,"total_amount_paid":73.85,"layaway_pending_amount":0,"sale_items":[{"id":30,"product_id":6,"product":{"id":6,"name":"product 6189minus name 819817856","upc":"15749665238","has_batch":true},"quantity":1,"returned_quantity":0.1,"cart_discount_amount":0.1,"item_discount_amount":0.1,"total_discount_amount":0.1,"total_tax_amount":27.52,"original_price_per_unit":46.33,"price_paid_per_unit":73.85,"total_price_paid":73.85,"promoters":[{"id":1,"first_name":"Shanel Kessler","last_name":"Kristin Sporer"}]}],"payments":[{"id":28,"payment_type":{"id":1,"name":"Cash"},"amount":73.85}],"status":"Regular Sale","sale_notes":"Sales notes goes here","happened_at":"2022-06-24 05:20:50","has_mismatch":false,"sale_mismatches":["",""]}
/// total_records : 28
/// last_page : 28
/// current_page : 1
/// per_page : 1

SaveSaleResponse saveSaleResponseFromJson(String str) =>
    SaveSaleResponse.fromJson(json.decode(str));

String saveSaleResponseToJson(SaveSaleResponse data) =>
    json.encode(data.toJson());

class SaveSaleResponse {
  SaveSaleResponse(
      {Sale? sale,
      Sale? saleReturn,
      int? totalRecords,
      int? lastPage,
      int? currentPage,
      int? perPage,
      String? message,
      v}) {
    _sale = sale;
    _saleReturn = saleReturn;
    _totalRecords = totalRecords;
    _lastPage = lastPage;
    _currentPage = currentPage;
    _perPage = perPage;
    _message = message;
  }

  SaveSaleResponse.fromJson(dynamic json) {
    _sale = json['sale'] != null ? Sale.fromJson(json['sale']) : null;
    _saleReturn =
        json['sale_return'] != null ? Sale.fromJson(json['sale_return']) : null;
    _totalRecords = json['total_records'];
    _lastPage = json['last_page'];
    _currentPage = json['current_page'];
    _perPage = json['per_page'];
    _message = json['message'];
  }

  Sale? _sale;
  Sale? _saleReturn;
  int? _totalRecords;
  int? _lastPage;
  int? _currentPage;
  int? _perPage;
  String? _message;

  Sale? get sale => _sale;

  Sale? get saleReturn => _saleReturn;

  int? get totalRecords => _totalRecords;

  String? get message => _message;

  int? get lastPage => _lastPage;

  int? get currentPage => _currentPage;

  int? get perPage => _perPage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_sale != null) {
      map['sale'] = _sale?.toJson();
    }
    if (_saleReturn != null) {
      map['sale_return'] = _saleReturn?.toJson();
    }
    map['total_records'] = _totalRecords;
    map['last_page'] = _lastPage;
    map['current_page'] = _currentPage;
    map['per_page'] = _perPage;
    map['message'] = _message;
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
/// layaway_pending_amount : 0
/// sale_items : [{"id":30,"product_id":6,"product":{"id":6,"name":"product 6189minus name 819817856","upc":"15749665238","has_batch":true},"quantity":1,"returned_quantity":0.1,"cart_discount_amount":0.1,"item_discount_amount":0.1,"total_discount_amount":0.1,"total_tax_amount":27.52,"original_price_per_unit":46.33,"price_paid_per_unit":73.85,"total_price_paid":73.85,"promoters":[{"id":1,"first_name":"Shanel Kessler","last_name":"Kristin Sporer"}]}]
/// payments : [{"id":28,"payment_type":{"id":1,"name":"Cash"},"amount":73.85}]
/// status : "Regular Sale"
/// sale_notes : "Sales notes goes here"
/// happened_at : "2022-06-24 05:20:50"
/// has_mismatch : false
/// sale_mismatches : ["",""]

Sale saleFromJson(String str) => Sale.fromJson(json.decode(str));

String saleToJson(Sale data) => json.encode(data.toJson());

class Sale {
  Sale({
    int? id,
    String? offlineSaleId,
    String? counterOpenedAt,
    String? userType,
    String? offlineSaleReturnId,
    UserDetails? userDetails,
    CashierDetails? cashierDetails,
    CounterDetails? counterDetails,
    int? userId,
    UsedVoucherInSale? usedVoucher,
    SaleComplimentary? complimentary,
    CreditNotes? creditNote,
    double? totalTaxAmount,
    double? totalDiscountAmount,
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
    String? happenedAt,
    String? voidReason,
    String? billReferenceNumber,
    bool? hasMismatch,
    List<String>? saleMismatches,
    List<String>? extraDetails,
  }) {
    _id = id;
    _counterOpenedAt = counterOpenedAt; // Used Locally For Offline
    _offlineSaleReturnId = offlineSaleReturnId;
    _saleRoundOffAmount = saleRoundOffAmount;
    _complimentary = complimentary;
    _offlineSaleId = offlineSaleId;
    _usedVoucher = usedVoucher;
    _userType = userType;
    _userDetails = userDetails;
    _creditNote = creditNote;
    _cashierDetails = cashierDetails;
    _counterDetails = counterDetails;
    _changeDue = changeDue;
    _extraDetails = extraDetails;
    _billReferenceNumber = billReferenceNumber;
    _userId = userId;
    _vouchers = vouchers;
    _cashback = cashback;
    _totalTaxAmount = totalTaxAmount;
    _totalAmountPaid = totalAmountPaid;
    _layawayPendingAmount = layawayPendingAmount;
    _saleItems = saleItems;
    _saleReturnItems = saleReturnItems;
    _payments = payments;
    _creditNotes = creditNotes;
    _status = status;
    _saleNotes = saleNotes;
    _happenedAt = happenedAt;
    _hasMismatch = hasMismatch;
    _voidReason = voidReason;
    _saleMismatches = saleMismatches;
    _totalDiscountAmount = totalDiscountAmount;
  }

  Sale.fromJson(dynamic json) {
    _id = json['id'];
    _counterOpenedAt = json['counterOpenedAt']; // Used Locally
    _offlineSaleId = json['offline_sale_id'];
    _offlineSaleReturnId = json['offline_sale_return_id'];
    _userType = json['user_type'];
    _userDetails = json['user_details'] != null
        ? UserDetails.fromJson(json['user_details'])
        : null;
    _usedVoucher = json['used_voucher'] != null
        ? UsedVoucherInSale.fromJson(json['used_voucher'])
        : null;
    _creditNote = json['credit_note'] != null
        ? CreditNotes.fromJson(json['credit_note'])
        : null;
    _cashierDetails = json['cashier'] != null
        ? CashierDetails.fromJson(json['cashier'])
        : null;
    _counterDetails = json['counter'] != null
        ? CounterDetails.fromJson(json['counter'])
        : null;
    _complimentary = json['complimentary'] != null
        ? SaleComplimentary.fromJson(json['complimentary'])
        : null;
    _userId = json['user_id'];
    _totalTaxAmount = getDoubleValue(json['total_tax_amount']);
    _totalDiscountAmount = getDoubleValue(json['total_discount_amount']);
    _totalAmountPaid = getDoubleValue(json['total_amount_paid']);
    _layawayPendingAmount = getDoubleValue(json['layaway_pending_amount']);
    _changeDue = getDoubleValue(json['change_due']);
    _saleRoundOffAmount = getDoubleValue(json['round_off_amount']);
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

    _billReferenceNumber = json['bill_reference_number'];
    _status = json['status'];
    _saleNotes = json['sale_notes'];
    _voidReason = json['void_reason'] ?? json['reason'];
    _happenedAt = json['happened_at'];
    _hasMismatch = getBoolValue(json['has_mismatch']);
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
  String? _voidReason;
  String? _billReferenceNumber;
  UserDetails? _userDetails;
  UsedVoucherInSale? _usedVoucher;
  SaleComplimentary? _complimentary;
  CreditNotes? _creditNote;
  CashierDetails? _cashierDetails;
  CounterDetails? _counterDetails;
  int? _userId;
  double? _totalTaxAmount;
  double? _totalDiscountAmount;
  double? _totalAmountPaid;
  double? _layawayPendingAmount;
  double? _changeDue;
  double? _saleRoundOffAmount;
  List<SaleItems>? _saleItems;
  List<SaleItems>? _saleReturnItems;
  List<Payments>? _payments;
  List<CreditNotes>? _creditNotes;
  List<Vouchers>? _vouchers;
  List<Cashback>? _cashback;
  String? _status;
  String? _saleNotes;
  String? _happenedAt;
  bool? _hasMismatch;
  List<String>? _saleMismatches;
  List<String>? _extraDetails;

  int? get id => _id;

  // Used locally for offline sale support
  String? get counterOpenedAt => _counterOpenedAt;

  setCounterOpenedAt(String openedAt) {
    _counterOpenedAt = openedAt;
  }

  String? get offlineSaleId => _offlineSaleId;

  SaleComplimentary? get complimentary => _complimentary;

  String? get offlineSaleReturnId => _offlineSaleReturnId;

  String? get userType => _userType;

  String? get voidReason => _voidReason;

  String? get billReferenceNumber => _billReferenceNumber;

  void setBillReferenceNumber(String? value) {
    _billReferenceNumber = value;
  }

  UserDetails? get userDetails => _userDetails;

  UsedVoucherInSale? get usedVoucher => _usedVoucher;

  CreditNotes? get creditNote => _creditNote;

  CashierDetails? get cashierDetails => _cashierDetails;

  CounterDetails? get counterDetails => _counterDetails;

  int? get userId => _userId;

  double? get totalTaxAmount => _totalTaxAmount;

  double? get totalDiscountAmount => _totalDiscountAmount;

  double? get changeDue => _changeDue;

  double? get saleRoundOffAmount => _saleRoundOffAmount;

  double? get totalAmountPaid => _totalAmountPaid;

  double? get layawayPendingAmount => _layawayPendingAmount;

  List<SaleItems>? get saleItems => _saleItems;

  void setSaleItems(List<SaleItems> saleItems) {
    _saleItems = saleItems;
  }

  List<SaleItems>? get saleReturnItems => _saleReturnItems;

  List<Payments>? get payments => _payments;

  void setPayments(List<Payments> payments) {
    _payments = payments;
  }

  List<CreditNotes>? get creditNotes => _creditNotes;

  List<Vouchers>? get vouchers => _vouchers;

  List<Cashback>? get cashback => _cashback;

  String? get status => _status;

  String? get saleNotes => _saleNotes;

  void setSaleNotes(String? notes) {
    _saleNotes = notes;
  }

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
    map['bill_reference_number'] = _billReferenceNumber;
    map['void_reason'] = _voidReason;
    map['user_type'] = _userType;

    if (_complimentary != null) {
      map['complimentary'] = _complimentary?.toJson();
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

    if (_usedVoucher != null) {
      map['used_voucher'] = _usedVoucher?.toJson();
    }

    if (_creditNote != null) {
      map['credit_note'] = _creditNote?.toJson();
    }

    map['user_id'] = _userId;
    map['total_tax_amount'] = _totalTaxAmount;
    map['total_discount_amount'] = _totalDiscountAmount;
    map['change_due'] = _changeDue;
    map['total_amount_paid'] = _totalAmountPaid;
    map['round_off_amount'] = _saleRoundOffAmount;

    map['layaway_pending_amount'] = _layawayPendingAmount;
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

    if (_creditNotes != null) {
      map['credit_notes'] = _creditNotes?.map((v) => v.toJson()).toList();
    }

    if (_vouchers != null) {
      map['vouchers'] = _vouchers?.map((v) => v.toJson()).toList();
    }

    if (_cashback != null) {
      map['cashback'] = _cashback?.map((v) => v.toJson()).toList();
    }

    map['status'] = _status;
    map['sale_notes'] = _saleNotes;
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

/// id : 1
/// name : "Cash"

PaymentType paymentTypeFromJson(String str) =>
    PaymentType.fromJson(json.decode(str));

String paymentTypeToJson(PaymentType data) => json.encode(data.toJson());

class PaymentType {
  PaymentType({
    int? id,
    String? name,
  }) {
    _id = id;
    _name = name;
  }

  PaymentType.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }

  int? _id;
  String? _name;

  PaymentType copyWith({
    int? id,
    String? name,
  }) =>
      PaymentType(
        id: id ?? _id,
        name: name ?? _name,
      );

  int? get id => _id;

  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }
}

/// id : 30
/// product_id : 6
/// product : {"id":6,"name":"product 6189minus name 819817856","upc":"15749665238","has_batch":true}
/// quantity : 1
/// returned_quantity : 0.1
/// cart_discount_amount : 0.1
/// item_discount_amount : 0.1
/// total_discount_amount : 0.1
/// total_tax_amount : 27.52
/// original_price_per_unit : 46.33
/// price_paid_per_unit : 73.85
/// total_price_paid : 73.85
/// promoters : [{"id":1,"first_name":"Shanel Kessler","last_name":"Kristin Sporer"}]

SaleItems saleItemsFromJson(String str) => SaleItems.fromJson(json.decode(str));

String saleItemsToJson(SaleItems data) => json.encode(data.toJson());

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

UserDetails userDetailsFromJson(String str) =>
    UserDetails.fromJson(json.decode(str));

String userDetailsToJson(UserDetails data) => json.encode(data.toJson());
