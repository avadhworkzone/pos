/// details : {"product_name":"ORKED BAJU KURUNG","product_upc":"BK092204M33104","product_size":"L","product_color":"WINDSOR WINE","product_department":"ARIANI RTW","product_brand":"ARIANI RTW","quantity":"1.00","amount":"0.00","commission":"0.00","other_promoters":[{"name":"ARIANI ","code":"AAAA"}]}

class GetPromoterCommissionDetailsResponse {
  GetPromoterCommissionDetailsResponse({
    this.details,
  });

  GetPromoterCommissionDetailsResponse.fromJson(dynamic json) {
    details =
        json['details'] != null ? Details.fromJson(json['details']) : null;
  }
  Details? details;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (details != null) {
      map['details'] = details?.toJson();
    }
    return map;
  }
}

/// product_name : "ORKED BAJU KURUNG"
/// product_upc : "BK092204M33104"
/// product_size : "L"
/// product_color : "WINDSOR WINE"
/// product_department : "ARIANI RTW"
/// product_brand : "ARIANI RTW"
/// quantity : "1.00"
/// amount : "0.00"
/// commission : "0.00"
/// other_promoters : [{"name":"ARIANI ","code":"AAAA"}]

class Details {
  Details({
    this.productName,
    this.productUpc,
    this.productSize,
    this.productColor,
    this.productDepartment,
    this.productBrand,
    this.quantity,
    this.amount,
    this.commission,
    this.otherPromoters,
  });

  Details.fromJson(dynamic json) {
    productName = json['product_name'];
    productUpc = json['product_upc'];
    productSize = json['product_size'];
    productColor = json['product_color'];
    productDepartment = json['product_department'];
    productBrand = json['product_brand'];
    quantity = json['quantity'];
    amount = json['amount'];
    commission = json['commission'];
    if (json['other_promoters'] != null) {
      otherPromoters = [];
      json['other_promoters'].forEach((v) {
        otherPromoters?.add(OtherPromoters.fromJson(v));
      });
    }
  }
  String? productName;
  String? productUpc;
  String? productSize;
  String? productColor;
  String? productDepartment;
  String? productBrand;
  String? quantity;
  String? amount;
  String? commission;
  List<OtherPromoters>? otherPromoters;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['product_name'] = productName;
    map['product_upc'] = productUpc;
    map['product_size'] = productSize;
    map['product_color'] = productColor;
    map['product_department'] = productDepartment;
    map['product_brand'] = productBrand;
    map['quantity'] = quantity;
    map['amount'] = amount;
    map['commission'] = commission;
    if (otherPromoters != null) {
      map['other_promoters'] = otherPromoters?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// name : "ARIANI "
/// code : "AAAA"

class OtherPromoters {
  OtherPromoters({
    this.name,
    this.code,
  });

  OtherPromoters.fromJson(dynamic json) {
    name = json['name'];
    code = json['code'];
  }
  String? name;
  String? code;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['code'] = code;
    return map;
  }
}
