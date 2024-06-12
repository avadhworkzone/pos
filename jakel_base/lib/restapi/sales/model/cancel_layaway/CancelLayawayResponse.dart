import 'dart:convert';

import 'package:jakel_base/restapi/sales/model/history/SaveSaleResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/VouchersListResponse.dart';
import 'package:jakel_base/utils/num_utils.dart';

/// sale : {"id":1289,"offline_sale_id":"345581686577789111","user_type":"Member","user_id":34,"user_details":{"first_name":"JY New","last_name":"","email":"","mobile_number":"172811180"},"cashier":{"id":5,"first_name":"CA 01","last_name":""},"counter":{"id":5,"name":"Counter A"},"total_tax_amount":2.07,"cart_discount_amount":0,"items_discount_amount":0,"total_discount_amount":0,"total_amount_paid":0,"change_due":0,"sale_items":[{"id":1656,"product":{"id":3804,"name":"SHAWL 119 SAPPHIRE VOILE PRINTED","upc":"S749PR0300","has_batch":false,"article_number":"S749","ean":"5915007110PR0300","is_non_inventory":false,"compound_product_name":"SHAWL 119 SAPPHIRE VOILE PRINTED PURPLE NO SIZE","type_id":{"id":1,"name":"Regular Product","key":"REGULAR_PRODUCT"},"color":{"id":61,"name":"PURPLE","code":""},"size":{"id":10,"name":"NO SIZE","code":""}},"quantity":1,"returned_quantity":0,"original_price_per_unit":69,"cart_discount_amount":0,"item_discount_amount":0,"total_discount_amount":0,"total_tax_amount":2.07,"price_paid_per_unit":71.07,"total_price_paid":0,"promoters":[{"id":2,"first_name":"Jay","last_name":"Patel"}],"complimentary":"","price_override":"","sale_item_discounts":[]}],"payments":[],"reason":"not good","store_manager":{"id":2,"first_name":"SM A","last_name":"","email":"sma@mailinator.com","mobile_number":"601158958960","staff_id":"SMA17"},"status":"CANCEL_LAYAWAY_SALE","sale_notes":"","bill_reference_number":"12345","happened_at":"2023-06-12 21:49:49","has_mismatch":false,"sale_mismatches":[],"cashback":"","vouchers":[],"credit_note":""}

class CancelLayawayResponse {
  CancelLayawayResponse({
      this.sale,});

  CancelLayawayResponse.fromJson(dynamic json) {
    sale = json['sale'] != null ? Sale.fromJson(json['sale']) : null;
  }
  Sale? sale;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (sale != null) {
      map['sale'] = sale?.toJson();
    }
    return map;
  }

}
//
// /// id : 1289
// /// offline_sale_id : "345581686577789111"
// /// user_type : "Member"
// /// user_id : 34
// /// user_details : {"first_name":"JY New","last_name":"","email":"","mobile_number":"172811180"}
// /// cashier : {"id":5,"first_name":"CA 01","last_name":""}
// /// counter : {"id":5,"name":"Counter A"}
// /// total_tax_amount : 2.07
// /// cart_discount_amount : 0
// /// items_discount_amount : 0
// /// total_discount_amount : 0
// /// total_amount_paid : 0
// /// change_due : 0
// /// sale_items : [{"id":1656,"product":{"id":3804,"name":"SHAWL 119 SAPPHIRE VOILE PRINTED","upc":"S749PR0300","has_batch":false,"article_number":"S749","ean":"5915007110PR0300","is_non_inventory":false,"compound_product_name":"SHAWL 119 SAPPHIRE VOILE PRINTED PURPLE NO SIZE","type_id":{"id":1,"name":"Regular Product","key":"REGULAR_PRODUCT"},"color":{"id":61,"name":"PURPLE","code":""},"size":{"id":10,"name":"NO SIZE","code":""}},"quantity":1,"returned_quantity":0,"original_price_per_unit":69,"cart_discount_amount":0,"item_discount_amount":0,"total_discount_amount":0,"total_tax_amount":2.07,"price_paid_per_unit":71.07,"total_price_paid":0,"promoters":[{"id":2,"first_name":"Jay","last_name":"Patel"}],"complimentary":"","price_override":"","sale_item_discounts":[]}]
// /// payments : []
// /// reason : "not good"
// /// store_manager : {"id":2,"first_name":"SM A","last_name":"","email":"sma@mailinator.com","mobile_number":"601158958960","staff_id":"SMA17"}
// /// status : "CANCEL_LAYAWAY_SALE"
// /// sale_notes : ""
// /// bill_reference_number : "12345"
// /// happened_at : "2023-06-12 21:49:49"
// /// has_mismatch : false
// /// sale_mismatches : []
// /// cashback : ""
// /// vouchers : []
// /// credit_note : ""
//
// class Sale {
//   Sale({
//       this.id,
//       this.offlineSaleId,
//       this.userType,
//       this.userId,
//       this.userDetails,
//       this.cashier,
//       this.counter,
//       this.totalTaxAmount,
//       this.cartDiscountAmount,
//       this.itemsDiscountAmount,
//       this.totalDiscountAmount,
//       this.totalAmountPaid,
//       this.changeDue,
//       this.saleItems,
//       this.payments,
//       this.reason,
//       this.storeManager,
//       this.status,
//       this.saleNotes,
//       this.billReferenceNumber,
//       this.happenedAt,
//       this.hasMismatch,
//       this.saleMismatches,
//       this.cashback,
//       this.vouchers,
//       this.creditNote,});
//
//   Sale.fromJson(dynamic json) {
//     id = json['id'];
//     offlineSaleId = json['offline_sale_id'];
//     userType = json['user_type'];
//     userId = json['user_id'];
//     userDetails = json['user_details'] != null ? UserDetails.fromJson(json['user_details']) : null;
//     cashier = json['cashier'] != null ? Cashier.fromJson(json['cashier']) : null;
//     counter = json['counter'] != null ? Counter.fromJson(json['counter']) : null;
//     totalTaxAmount = json['total_tax_amount'];
//     cartDiscountAmount = json['cart_discount_amount'];
//     itemsDiscountAmount = json['items_discount_amount'];
//     totalDiscountAmount = json['total_discount_amount'];
//     totalAmountPaid = json['total_amount_paid'];
//     changeDue = json['change_due'];
//
//     if (json['sale_items'] != null) {
//       saleItems = [];
//       json['sale_items'].forEach((v) {
//         saleItems?.add(SaleItems.fromJson(v));
//       });
//     }
//     if (json['payments'] != null) {
//       payments = [];
//       json['payments'].forEach((v) {
//         payments?.add(Payments.fromJson(v));
//       });
//     }
//     reason = json['reason'];
//     storeManager = json['store_manager'] != null ? StoreManager.fromJson(json['store_manager']) : null;
//     status = json['status'];
//     saleNotes = json['sale_notes'];
//     billReferenceNumber = json['bill_reference_number'];
//     happenedAt = json['happened_at'];
//     hasMismatch = json['has_mismatch'];
//     saleMismatches = json['sale_mismatches'] != null
//         ? json['sale_mismatches'].cast<String>()
//         : [];
//     cashback = json['cashback'];
//     if (json['vouchers'] != null) {
//       vouchers = [];
//       json['vouchers'].forEach((v) {
//         vouchers?.add(Vouchers.fromJson(v));
//       });
//     }
//     creditNote = json['credit_note'];
//   }
//   int? id;
//   String? offlineSaleId;
//   String? userType;
//   int? userId;
//   UserDetails? userDetails;
//   Cashier? cashier;
//   Counter? counter;
//   double? totalTaxAmount;
//   int? cartDiscountAmount;
//   int? itemsDiscountAmount;
//   int? totalDiscountAmount;
//   int? totalAmountPaid;
//   int? changeDue;
//   List<SaleItems>? saleItems;
//   List<Payments>? payments;
//   String? reason;
//   StoreManager? storeManager;
//   String? status;
//   String? saleNotes;
//   String? billReferenceNumber;
//   String? happenedAt;
//   bool? hasMismatch;
//   List<String>? saleMismatches;
//   String? cashback;
//   List<Vouchers>? vouchers;
//   String? creditNote;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['offline_sale_id'] = offlineSaleId;
//     map['user_type'] = userType;
//     map['user_id'] = userId;
//     if (userDetails != null) {
//       map['user_details'] = userDetails?.toJson();
//     }
//     if (cashier != null) {
//       map['cashier'] = cashier?.toJson();
//     }
//     if (counter != null) {
//       map['counter'] = counter?.toJson();
//     }
//     map['total_tax_amount'] = totalTaxAmount;
//     map['cart_discount_amount'] = cartDiscountAmount;
//     map['items_discount_amount'] = itemsDiscountAmount;
//     map['total_discount_amount'] = totalDiscountAmount;
//     map['total_amount_paid'] = totalAmountPaid;
//     map['change_due'] = changeDue;
//     if (saleItems != null) {
//       map['sale_items'] = saleItems?.map((v) => v.toJson()).toList();
//     }
//     if (payments != null) {
//       map['payments'] = payments?.map((v) => v.toJson()).toList();
//     }
//     map['reason'] = reason;
//     if (storeManager != null) {
//       map['store_manager'] = storeManager?.toJson();
//     }
//     map['status'] = status;
//     map['sale_notes'] = saleNotes;
//     map['bill_reference_number'] = billReferenceNumber;
//     map['happened_at'] = happenedAt;
//     map['has_mismatch'] = hasMismatch;
//     map['sale_mismatches'] = saleMismatches;
//     map['cashback'] = cashback;
//     if (vouchers != null) {
//       map['vouchers'] = vouchers?.map((v) => v.toJson()).toList();
//     }
//     map['credit_note'] = creditNote;
//     return map;
//   }
//
// }
//
// /// id : 2
// /// first_name : "SM A"
// /// last_name : ""
// /// email : "sma@mailinator.com"
// /// mobile_number : "601158958960"
// /// staff_id : "SMA17"
//
// class StoreManager {
//   StoreManager({
//       this.id,
//       this.firstName,
//       this.lastName,
//       this.email,
//       this.mobileNumber,
//       this.staffId,});
//
//   StoreManager.fromJson(dynamic json) {
//     id = json['id'];
//     firstName = json['first_name'];
//     lastName = json['last_name'];
//     email = json['email'];
//     mobileNumber = json['mobile_number'];
//     staffId = json['staff_id'];
//   }
//   int? id;
//   String? firstName;
//   String? lastName;
//   String? email;
//   String? mobileNumber;
//   String? staffId;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['first_name'] = firstName;
//     map['last_name'] = lastName;
//     map['email'] = email;
//     map['mobile_number'] = mobileNumber;
//     map['staff_id'] = staffId;
//     return map;
//   }
//
// }
//
// /// id : 1656
// /// product : {"id":3804,"name":"SHAWL 119 SAPPHIRE VOILE PRINTED","upc":"S749PR0300","has_batch":false,"article_number":"S749","ean":"5915007110PR0300","is_non_inventory":false,"compound_product_name":"SHAWL 119 SAPPHIRE VOILE PRINTED PURPLE NO SIZE","type_id":{"id":1,"name":"Regular Product","key":"REGULAR_PRODUCT"},"color":{"id":61,"name":"PURPLE","code":""},"size":{"id":10,"name":"NO SIZE","code":""}}
// /// quantity : 1
// /// returned_quantity : 0
// /// original_price_per_unit : 69
// /// cart_discount_amount : 0
// /// item_discount_amount : 0
// /// total_discount_amount : 0
// /// total_tax_amount : 2.07
// /// price_paid_per_unit : 71.07
// /// total_price_paid : 0
// /// promoters : [{"id":2,"first_name":"Jay","last_name":"Patel"}]
// /// complimentary : ""
// /// price_override : ""
// /// sale_item_discounts : []
//
// class SaleItems {
//   SaleItems({
//       this.id,
//       this.product,
//       this.quantity,
//       this.returnedQuantity,
//       this.originalPricePerUnit,
//       this.cartDiscountAmount,
//       this.itemDiscountAmount,
//       this.totalDiscountAmount,
//       this.totalTaxAmount,
//       this.pricePaidPerUnit,
//       this.totalPricePaid,
//       this.promoters,
//       this.complimentary,
//       this.priceOverride,
//       // this.saleItemDiscounts,
//   });
//
//   SaleItems.fromJson(dynamic json) {
//     id = json['id'];
//     product = json['product'] != null ? Product.fromJson(json['product']) : null;
//     quantity = json['quantity'];
//     returnedQuantity = json['returned_quantity'];
//     originalPricePerUnit = json['original_price_per_unit'];
//     cartDiscountAmount = json['cart_discount_amount'];
//     itemDiscountAmount = json['item_discount_amount'];
//     totalDiscountAmount = json['total_discount_amount'];
//     totalTaxAmount = json['total_tax_amount'];
//     pricePaidPerUnit = json['price_paid_per_unit'];
//     totalPricePaid = json['total_price_paid'];
//     if (json['promoters'] != null) {
//       promoters = [];
//       json['promoters'].forEach((v) {
//         promoters?.add(Promoters.fromJson(v));
//       });
//     }
//     complimentary = json['complimentary'];
//     priceOverride = json['price_override'];
//     // if (json['sale_item_discounts'] != null) {
//     //   saleItemDiscounts = [];
//     //   json['sale_item_discounts'].forEach((v) {
//     //     saleItemDiscounts?.add(Dynamic.fromJson(v));
//     //   });
//     // }
//   }
//   int? id;
//   Product? product;
//   int? quantity;
//   int? returnedQuantity;
//   int? originalPricePerUnit;
//   int? cartDiscountAmount;
//   int? itemDiscountAmount;
//   int? totalDiscountAmount;
//   double? totalTaxAmount;
//   double? pricePaidPerUnit;
//   int? totalPricePaid;
//   List<Promoters>? promoters;
//   String? complimentary;
//   String? priceOverride;
//   // List<dynamic>? saleItemDiscounts;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     if (product != null) {
//       map['product'] = product?.toJson();
//     }
//     map['quantity'] = quantity;
//     map['returned_quantity'] = returnedQuantity;
//     map['original_price_per_unit'] = originalPricePerUnit;
//     map['cart_discount_amount'] = cartDiscountAmount;
//     map['item_discount_amount'] = itemDiscountAmount;
//     map['total_discount_amount'] = totalDiscountAmount;
//     map['total_tax_amount'] = totalTaxAmount;
//     map['price_paid_per_unit'] = pricePaidPerUnit;
//     map['total_price_paid'] = totalPricePaid;
//     if (promoters != null) {
//       map['promoters'] = promoters?.map((v) => v.toJson()).toList();
//     }
//     map['complimentary'] = complimentary;
//     map['price_override'] = priceOverride;
//     // if (saleItemDiscounts != null) {
//     //   map['sale_item_discounts'] = saleItemDiscounts?.map((v) => v.toJson()).toList();
//     // }
//     return map;
//   }
//
// }
//
// /// id : 2
// /// first_name : "Jay"
// /// last_name : "Patel"
//
// class Promoters {
//   Promoters({
//       this.id,
//       this.firstName,
//       this.lastName,});
//
//   Promoters.fromJson(dynamic json) {
//     id = json['id'];
//     firstName = json['first_name'];
//     lastName = json['last_name'];
//   }
//   int? id;
//   String? firstName;
//   String? lastName;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['first_name'] = firstName;
//     map['last_name'] = lastName;
//     return map;
//   }
//
// }
//
// /// id : 3804
// /// name : "SHAWL 119 SAPPHIRE VOILE PRINTED"
// /// upc : "S749PR0300"
// /// has_batch : false
// /// article_number : "S749"
// /// ean : "5915007110PR0300"
// /// is_non_inventory : false
// /// compound_product_name : "SHAWL 119 SAPPHIRE VOILE PRINTED PURPLE NO SIZE"
// /// type_id : {"id":1,"name":"Regular Product","key":"REGULAR_PRODUCT"}
// /// color : {"id":61,"name":"PURPLE","code":""}
// /// size : {"id":10,"name":"NO SIZE","code":""}
//
// class Product {
//   Product({
//       this.id,
//       this.name,
//       this.upc,
//       this.hasBatch,
//       this.articleNumber,
//       this.ean,
//       this.isNonInventory,
//       this.compoundProductName,
//       this.typeId,
//       this.color,
//       this.size,});
//
//   Product.fromJson(dynamic json) {
//     id = json['id'];
//     name = json['name'];
//     upc = json['upc'];
//     hasBatch = json['has_batch'];
//     articleNumber = json['article_number'];
//     ean = json['ean'];
//     isNonInventory = json['is_non_inventory'];
//     compoundProductName = json['compound_product_name'];
//     typeId = json['type_id'] != null ? TypeId.fromJson(json['type_id']) : null;
//     color = json['color'] != null ? Color.fromJson(json['color']) : null;
//     size = json['size'] != null ? Size.fromJson(json['size']) : null;
//   }
//   int? id;
//   String? name;
//   String? upc;
//   bool? hasBatch;
//   String? articleNumber;
//   String? ean;
//   bool? isNonInventory;
//   String? compoundProductName;
//   TypeId? typeId;
//   Color? color;
//   Size? size;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['name'] = name;
//     map['upc'] = upc;
//     map['has_batch'] = hasBatch;
//     map['article_number'] = articleNumber;
//     map['ean'] = ean;
//     map['is_non_inventory'] = isNonInventory;
//     map['compound_product_name'] = compoundProductName;
//     if (typeId != null) {
//       map['type_id'] = typeId?.toJson();
//     }
//     if (color != null) {
//       map['color'] = color?.toJson();
//     }
//     if (size != null) {
//       map['size'] = size?.toJson();
//     }
//     return map;
//   }
//
// }
//
// /// id : 10
// /// name : "NO SIZE"
// /// code : ""
//
// class Size {
//   Size({
//       this.id,
//       this.name,
//       this.code,});
//
//   Size.fromJson(dynamic json) {
//     id = json['id'];
//     name = json['name'];
//     code = json['code'];
//   }
//   int? id;
//   String? name;
//   String? code;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['name'] = name;
//     map['code'] = code;
//     return map;
//   }
//
// }
//
// /// id : 61
// /// name : "PURPLE"
// /// code : ""
//
// class Color {
//   Color({
//       this.id,
//       this.name,
//       this.code,});
//
//   Color.fromJson(dynamic json) {
//     id = json['id'];
//     name = json['name'];
//     code = json['code'];
//   }
//   int? id;
//   String? name;
//   String? code;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['name'] = name;
//     map['code'] = code;
//     return map;
//   }
//
// }
//
// /// id : 1
// /// name : "Regular Product"
// /// key : "REGULAR_PRODUCT"
//
// class TypeId {
//   TypeId({
//       this.id,
//       this.name,
//       this.key,});
//
//   TypeId.fromJson(dynamic json) {
//     id = json['id'];
//     name = json['name'];
//     key = json['key'];
//   }
//   int? id;
//   String? name;
//   String? key;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['name'] = name;
//     map['key'] = key;
//     return map;
//   }
//
// }
//
// /// id : 5
// /// name : "Counter A"
//
// class Counter {
//   Counter({
//       this.id,
//       this.name,});
//
//   Counter.fromJson(dynamic json) {
//     id = json['id'];
//     name = json['name'];
//   }
//   int? id;
//   String? name;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['name'] = name;
//     return map;
//   }
//
// }
//
// /// id : 5
// /// first_name : "CA 01"
// /// last_name : ""
//
// class Cashier {
//   Cashier({
//       this.id,
//       this.firstName,
//       this.lastName,});
//
//   Cashier.fromJson(dynamic json) {
//     id = json['id'];
//     firstName = json['first_name'];
//     lastName = json['last_name'];
//   }
//   int? id;
//   String? firstName;
//   String? lastName;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['first_name'] = firstName;
//     map['last_name'] = lastName;
//     return map;
//   }
//
// }
//
// /// first_name : "JY New"
// /// last_name : ""
// /// email : ""
// /// mobile_number : "172811180"
//
// class UserDetails {
//   UserDetails({
//       this.firstName,
//       this.lastName,
//       this.email,
//       this.mobileNumber,});
//
//   UserDetails.fromJson(dynamic json) {
//     firstName = json['first_name'];
//     lastName = json['last_name'];
//     email = json['email'];
//     mobileNumber = json['mobile_number'];
//   }
//   String? firstName;
//   String? lastName;
//   String? email;
//   String? mobileNumber;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['first_name'] = firstName;
//     map['last_name'] = lastName;
//     map['email'] = email;
//     map['mobile_number'] = mobileNumber;
//     return map;
//   }
//
// }
//
// /// id : 28
// /// payment_type : {"id":1,"name":"Cash"}
// /// amount : 73.85
//
// Payments paymentsFromJson(String str) => Payments.fromJson(json.decode(str));
//
// String paymentsToJson(Payments data) => json.encode(data.toJson());
//
// class Payments {
//   Payments(
//       {int? id, PaymentType? paymentType, double? amount, String? happenedAt}) {
//     _id = id;
//     _paymentType = paymentType;
//     _amount = amount;
//     _happenedAt = happenedAt;
//   }
//
//   Payments.fromJson(dynamic json) {
//     _id = json['id'];
//     try {
//       _paymentType = json['payment_type'] != null
//           ? PaymentType.fromJson(json['payment_type'])
//           : null;
//     } catch (e) {
//       _paymentType = json['payment_type'] != null
//           ? PaymentType(name: json['payment_type'])
//           : null;
//     }
//     _amount = getDoubleValue(json['amount']);
//     _happenedAt = json['happened_at'];
//   }
//
//   int? _id;
//   PaymentType? _paymentType;
//   double? _amount;
//   String? _happenedAt;
//
//   Payments copyWith({
//     int? id,
//     PaymentType? paymentType,
//     double? amount,
//     String? happenedAt,
//   }) =>
//       Payments(
//         id: id ?? _id,
//         paymentType: paymentType ?? _paymentType,
//         amount: amount ?? _amount,
//         happenedAt: happenedAt ?? _happenedAt,
//       );
//
//   int? get id => _id;
//
//   PaymentType? get paymentType => _paymentType;
//
//   double? get amount => _amount;
//
//   String? get happenedAt => _happenedAt;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     if (_paymentType != null) {
//       map['payment_type'] = _paymentType?.toJson();
//     }
//     map['amount'] = _amount;
//     map['happened_at'] = _happenedAt;
//     return map;
//   }
// }
//
// /// id : 1
// /// name : "Cash"
//
// PaymentType paymentTypeFromJson(String str) =>
//     PaymentType.fromJson(json.decode(str));
//
// String paymentTypeToJson(PaymentType data) => json.encode(data.toJson());
//
// class PaymentType {
//   PaymentType({
//     int? id,
//     String? name,
//   }) {
//     _id = id;
//     _name = name;
//   }
//
//   PaymentType.fromJson(dynamic json) {
//     _id = json['id'];
//     _name = json['name'];
//   }
//
//   int? _id;
//   String? _name;
//
//   PaymentType copyWith({
//     int? id,
//     String? name,
//   }) =>
//       PaymentType(
//         id: id ?? _id,
//         name: name ?? _name,
//       );
//
//   int? get id => _id;
//
//   String? get name => _name;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['name'] = _name;
//     return map;
//   }
// }
