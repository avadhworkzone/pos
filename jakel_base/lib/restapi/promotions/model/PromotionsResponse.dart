import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

/// promotions : [{"id":1,"name":"CART WIDE AUTOMATIC PERCENTAGE","promotion_type":"CART_WIDE_AUTOMATIC_PERCENTAGE","timeframe_type":"NO_LIMIT","percentage":0.5,"flat_amount":0.5,"promotion_tiers":[{"minimum_spend_amount":500.4,"percentage":10.1,"flat_amount":1.0,"free_quantity":1,"buy_quantity":1,"get_quantity":1,"amount":30.05}],"products":[10001],"buy_products":[10002,10003,10004,10005],"get_products":[10006,10007,10008],"categories":[1],"start_date":"2022-08-10","end_date":"2022-08-10","start_time":"04:09:00","end_time":"23:30:00","month_dates":[1,2,3,4,5,7,6,17,16,15,14,13,8,9,10,11,12,18,19,20,21,22,23,24,25,26,27,28],"week_days":[3,4],"is_member_required":true,"only_for_employees":false}]

PromotionsResponse promotionsResponseFromJson(String str) =>
    PromotionsResponse.fromJson(json.decode(str));

String promotionsResponseToJson(PromotionsResponse data) =>
    json.encode(data.toJson());

class PromotionsResponse {
  PromotionsResponse({
    List<Promotions>? promotions,
  }) {
    _promotions = promotions;
  }

  PromotionsResponse.fromJson(dynamic json) {
    if (json['promotions'] != null) {
      _promotions = [];
      json['promotions'].forEach((v) {
        _promotions?.add(Promotions.fromJson(v));
      });
    }
  }

  List<Promotions>? _promotions;

  PromotionsResponse copyWith({
    List<Promotions>? promotions,
  }) =>
      PromotionsResponse(
        promotions: promotions ?? _promotions,
      );

  List<Promotions>? get promotions => _promotions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_promotions != null) {
      map['promotions'] = _promotions?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 1
/// name : "CART WIDE AUTOMATIC PERCENTAGE"
/// promotion_type : "CART_WIDE_AUTOMATIC_PERCENTAGE"
/// timeframe_type : "NO_LIMIT"
/// percentage : 0.5
/// flat_amount : 0.5
/// promotion_tiers : [{"minimum_spend_amount":500.4,"percentage":10.1,"flat_amount":1.0,"free_quantity":1,"buy_quantity":1,"get_quantity":1,"amount":30.05}]
/// products : [10001]
/// buy_products : [10002,10003,10004,10005]
/// get_products : [10006,10007,10008]
/// categories : [1]
/// start_date : "2022-08-10"
/// end_date : "2022-08-10"
/// start_time : "04:09:00"
/// end_time : "23:30:00"
/// month_dates : [1,2,3,4,5,7,6,17,16,15,14,13,8,9,10,11,12,18,19,20,21,22,23,24,25,26,27,28]
/// week_days : [3,4]
/// is_member_required : true
/// only_for_employees : false

Promotions promotionsFromJson(String str) =>
    Promotions.fromJson(json.decode(str));

String promotionsToJson(Promotions data) => json.encode(data.toJson());

class Promotions {
  Promotions({
    int? id,
    String? name,
    String? promotionType,
    String? timeframeType,
    double? percentage,
    double? flatAmount,
    List<PromotionTiers>? promotionTiers,
    List<int>? products,
    List<int>? buyProducts,
    List<int>? getProducts,
    List<int>? categories,
    List<PromotionTags>? tags,
    List<int>? brands,
    List<int>? memberGroups,
    List<int>? employeeGroups,
    String? startDate,
    String? endDate,
    String? startTime,
    String? endTime,
    List<int>? monthDates,
    List<int>? weekDays,
    bool? isCustomerRequired,
    bool? onlyForEmployees,
    bool? allowWalkInMember,
    bool? allowRegisteredMember,
    bool? allowEmployee,
    bool? dreamPriceApplicable
  }) {
    _id = id;
    _name = name;
    _promotionType = promotionType;
    _timeframeType = timeframeType;
    _percentage = percentage;
    _flatAmount = flatAmount;
    _promotionTiers = promotionTiers;
    _products = products;
    _brands = brands;
    _memberGroups = memberGroups;
    _employeeGroups = employeeGroups;
    _buyProducts = buyProducts;
    _getProducts = getProducts;
    _categories = categories;
    _tags = tags;
    _startDate = startDate;
    _endDate = endDate;
    _startTime = startTime;
    _endTime = endTime;
    _monthDates = monthDates;
    _weekDays = weekDays;
    _isCustomerRequired = isCustomerRequired;
    _onlyForEmployees = onlyForEmployees;
    _allowWalkInMember = allowWalkInMember;
    _allowRegisteredMember = allowRegisteredMember;
    _allowEmployee = allowEmployee;
    _dreamPriceApplicable = dreamPriceApplicable;
  }

  Promotions.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _promotionType = json['promotion_type'];
    _timeframeType = json['timeframe_type'];
    _percentage = getDoubleValue(json['percentage']);
    _flatAmount = getDoubleValue(json['flat_amount']);
    if (json['promotion_tiers'] != null) {
      _promotionTiers = [];
      json['promotion_tiers'].forEach((v) {
        _promotionTiers?.add(PromotionTiers.fromJson(v));
      });
    }
    _products = json['products'] != null ? json['products'].cast<int>() : [];
    _buyProducts =
    json['buy_products'] != null ? json['buy_products'].cast<int>() : [];
    _brands = json['brands'] != null ? json['brands'].cast<int>() : [];
    _memberGroups =
    json['member_groups'] != null ? json['member_groups'].cast<int>() : [];

    _employeeGroups =
    json['employee_groups'] != null ? json['employee_groups'].cast<int>() : [];

    _getProducts =
    json['get_products'] != null ? json['get_products'].cast<int>() : [];
    _categories =
    json['categories'] != null ? json['categories'].cast<int>() : [];
    if (json['tags'] != null) {
      _tags = [];
      json['tags'].forEach((v) {
        _tags?.add(PromotionTags.fromJson(v));
      });
    }
    _startDate = json['start_date'];
    _endDate = json['end_date'];
    _startTime = json['start_time'];
    _endTime = json['end_time'];
    _monthDates =
    json['month_dates'] != null ? json['month_dates'].cast<int>() : [];
    _weekDays = json['week_days'] != null ? json['week_days'].cast<int>() : [];
    _isCustomerRequired = json['is_member_required'];
    _onlyForEmployees = json['only_for_employees'];
    _allowWalkInMember = json['allow_walk_in_member'];
    _allowRegisteredMember = json['allow_registered_member'];
    _allowEmployee = json['allow_employee'];
    _dreamPriceApplicable = json['dream_price_applicable'];
  }

  int? _id;
  String? _name;
  String? _promotionType;
  String? _timeframeType;
  double? _percentage;
  double? _flatAmount;
  List<PromotionTiers>? _promotionTiers;
  List<int>? _products;
  List<int>? _buyProducts;
  List<int>? _getProducts;
  List<int>? _categories;
  List<PromotionTags>? _tags;
  List<int>? _brands;
  List<int>? _memberGroups;
  List<int>? _employeeGroups;
  String? _startDate;
  String? _endDate;
  String? _startTime;
  String? _endTime;
  List<int>? _monthDates;
  List<int>? _weekDays;
  bool? _isCustomerRequired;
  bool? _onlyForEmployees;

  bool? _allowWalkInMember;
  bool? _allowRegisteredMember;
  bool? _allowEmployee;
  bool? _dreamPriceApplicable;

  int? get id => _id;

  String? get name => _name;

  String? get promotionType => _promotionType;

  String? get timeframeType => _timeframeType;

  double? get percentage => _percentage;

  double? get flatAmount => _flatAmount;

  List<PromotionTiers>? get promotionTiers => _promotionTiers;

  List<int>? get products => _products;

  List<int>? get memberGroups => _memberGroups;

  List<int>? get employeeGroups => _employeeGroups;

  List<int>? get brands => _brands;

  List<int>? get buyProducts => _buyProducts;

  List<int>? get getProducts => _getProducts;

  List<int>? get categories => _categories;

  List<PromotionTags>? get tags => _tags;

  String? get startDate => _startDate;

  String? get endDate => _endDate;

  String? get startTime => _startTime;

  String? get endTime => _endTime;

  List<int>? get monthDates => _monthDates;

  List<int>? get weekDays => _weekDays;

  bool? get isCustomerRequired => _isCustomerRequired;

  bool? get onlyForEmployees => _onlyForEmployees;

  bool? get allowWalkInMember => _allowWalkInMember;

  bool? get allowRegisteredMember => _allowRegisteredMember;

  bool? get allowEmployee => _allowEmployee;

  bool? get dreamPriceApplicable => _dreamPriceApplicable;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['promotion_type'] = _promotionType;
    map['timeframe_type'] = _timeframeType;
    map['percentage'] = _percentage;
    map['flat_amount'] = _flatAmount;
    if (_promotionTiers != null) {
      map['promotion_tiers'] = _promotionTiers?.map((v) => v.toJson()).toList();
    }
    map['products'] = _products;
    map['brands'] = _brands;
    map['member_groups'] = _memberGroups;
    map['employee_groups'] = _employeeGroups;
    map['buy_products'] = _buyProducts;
    map['get_products'] = _getProducts;
    map['categories'] = _categories;
    if (_tags != null) {
      map['tags'] = _tags?.map((v) => v.toJson()).toList();
    }
    map['start_date'] = _startDate;
    map['end_date'] = _endDate;
    map['start_time'] = _startTime;
    map['end_time'] = _endTime;
    map['month_dates'] = _monthDates;
    map['week_days'] = _weekDays;
    map['is_member_required'] = _isCustomerRequired;
    map['only_for_employees'] = _onlyForEmployees;

    map['allow_walk_in_member'] = _allowWalkInMember;
    map['allow_registered_member'] = _allowRegisteredMember;
    map['allow_employee'] = _allowEmployee;
    map['dream_price_applicable'] = _dreamPriceApplicable;
    return map;
  }
}

/// minimum_spend_amount : 500.4
/// percentage : 10.1
/// flat_amount : 1.0
/// free_quantity : 1
/// buy_quantity : 1
/// get_quantity : 1
/// amount : 30.05

PromotionTiers promotionTiersFromJson(String str) =>
    PromotionTiers.fromJson(json.decode(str));

String promotionTiersToJson(PromotionTiers data) => json.encode(data.toJson());

class PromotionTiers {
  PromotionTiers({
    double? minimumSpendAmount,
    double? maximumSpendAmount,
    double? minimumProductPrice,
    double? maximumProductPrice,
    double? percentage,
    double? flatAmount,
    int? freeQuantity,
    int? buyQuantity,
    int? getQuantity,
    double? amount,
  }) {
    _minimumSpendAmount = minimumSpendAmount;
    _maximumSpendAmount = maximumSpendAmount;
    _minimumProductPrice = minimumProductPrice;
    _maximumProductPrice = maximumProductPrice;
    _percentage = percentage;
    _flatAmount = flatAmount;
    _freeQuantity = freeQuantity;
    _buyQuantity = buyQuantity;
    _getQuantity = getQuantity;
    _amount = amount;
  }

  PromotionTiers.fromJson(dynamic json) {
    _minimumSpendAmount = getDoubleValue(json['minimum_spend_amount']);
    _maximumSpendAmount = getDoubleValue(json['maximum_spend_amount']);
    _minimumProductPrice = getDoubleValue(json['minimum_product_price']);
    _maximumProductPrice = getDoubleValue(json['maximum_product_price']);
    _percentage = getDoubleValue(json['percentage']);
    _flatAmount = getDoubleValue(json['flat_amount']);
    _freeQuantity = json['free_quantity'];
    _buyQuantity = json['buy_quantity'];
    _getQuantity = json['get_quantity'];
    _amount = getDoubleValue(json['amount']);
  }

  double? _minimumSpendAmount;
  double? _maximumSpendAmount;
  double? _minimumProductPrice;
  double? _maximumProductPrice;
  double? _percentage;
  double? _flatAmount;
  int? _freeQuantity;
  int? _buyQuantity;
  int? _getQuantity;
  double? _amount;

  PromotionTiers copyWith({
    double? minimumSpendAmount,
    double? maximumSpendAmount,
    double? minimumProductPrice,
    double? maximumProductPrice,
    double? percentage,
    double? flatAmount,
    int? freeQuantity,
    int? buyQuantity,
    int? getQuantity,
    double? amount,
  }) =>
      PromotionTiers(
        minimumSpendAmount: minimumSpendAmount ?? _minimumSpendAmount,
        maximumSpendAmount: maximumSpendAmount ?? _maximumSpendAmount,
        minimumProductPrice: minimumProductPrice ?? _minimumProductPrice,
        maximumProductPrice: maximumProductPrice ?? _maximumProductPrice,
        percentage: percentage ?? _percentage,
        flatAmount: flatAmount ?? _flatAmount,
        freeQuantity: freeQuantity ?? _freeQuantity,
        buyQuantity: buyQuantity ?? _buyQuantity,
        getQuantity: getQuantity ?? _getQuantity,
        amount: amount ?? _amount,
      );

  double? get minimumSpendAmount => _minimumSpendAmount;

  double? get maximumSpendAmount => _maximumSpendAmount;

  double? get minimumProductPrice => _minimumProductPrice;

  double? get maximumProductPrice => _maximumProductPrice;

  double? get percentage => _percentage;

  double? get flatAmount => _flatAmount;

  int? get freeQuantity => _freeQuantity;

  int? get buyQuantity => _buyQuantity;

  int? get getQuantity => _getQuantity;

  double? get amount => _amount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['minimum_spend_amount'] = _minimumSpendAmount;
    map['maximum_spend_amount'] = _maximumSpendAmount;
    map['minimum_product_price'] = _minimumProductPrice;
    map['maximum_product_price'] = _maximumProductPrice;
    map['percentage'] = _percentage;
    map['flat_amount'] = _flatAmount;
    map['free_quantity'] = _freeQuantity;
    map['buy_quantity'] = _buyQuantity;
    map['get_quantity'] = _getQuantity;
    map['amount'] = _amount;
    return map;
  }
}

/// id : 1
/// name : "Test-00"
PromotionTags tagsFromJson(String str) =>
    PromotionTags.fromJson(json.decode(str));

String tagsToJson(PromotionTags data) => json.encode(data.toJson());

class PromotionTags {
  PromotionTags({
    int? id,
    String? name
  }) {
    _id = id;
    _name = name;
  }

  PromotionTags.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }

  int? _id;
  String? _name;

  PromotionTags copyWith({
    int? id,
    String? name,
  }) =>
      PromotionTags(
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
