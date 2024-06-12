import 'dart:convert';

import 'package:jakel_base/restapi/counters/model/GetCountersResponse.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/restapi/me/model/CurrentUserResponse.dart';
import 'package:jakel_base/restapi/sales/model/history/SalesResponse.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/utils/string_utils.dart';

import '../../products/model/ProductsResponse.dart';
import '../../promoters/model/PromotersResponse.dart';

/// booking_payments : [{"id":2,"customer":{"id":3,"first_name":"Pradeep","last_name":"","mobile_number":"9790642170"},"counter":{"id":1,"name":"Samantha Beatty"},"cashier":{"id":2,"first_name":"Hettie Olson","last_name":"Erik Walter","email":"bhahn@example.net","company_id":1},"total_amount":10.50,"available_amount":10.05,"status":"ACTIVE","created_at":"2022-08-14 07:16:50","products":[{"product_id":6,"product_name":"product 6189minus name 819817856","quantity":1}]}]
/// total_records : 6
/// last_page : 1
/// current_page : 1
/// per_page : 15

BookingPaymentsResponse bookingPaymentsResponseFromJson(String str) =>
    BookingPaymentsResponse.fromJson(json.decode(str));

String bookingPaymentsResponseToJson(BookingPaymentsResponse data) =>
    json.encode(data.toJson());

class BookingPaymentsResponse {
  BookingPaymentsResponse({this.bookingPayments,
    this.bookingPaymentStore,
    this.totalRecords,
    this.lastPage,
    this.currentPage,
    this.perPage,
    this.message});

  BookingPaymentsResponse.fromJson(dynamic json) {
    if (json['booking_payments'] != null) {
      bookingPayments = [];
      json['booking_payments'].forEach((v) {
        bookingPayments?.add(BookingPayments.fromJson(v));
      });
    }

    bookingPaymentStore = json['booking_payment_store'] != null
        ? BookingPayments.fromJson(json['booking_payment_store'])
        : null;

    totalRecords = json['total_records'];
    lastPage = json['last_page'];
    currentPage = json['current_page'];
    perPage = json['per_page'];
    message = json['message'];
  }

  List<BookingPayments>? bookingPayments;
  BookingPayments? bookingPaymentStore;
  int? totalRecords;
  int? lastPage;
  int? currentPage;
  int? perPage;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (bookingPayments != null) {
      map['booking_payments'] =
          bookingPayments?.map((v) => v.toJson()).toList();
    }
    if (bookingPaymentStore != null) {
      map['booking_payment_store'] = bookingPaymentStore?.toJson();
    }

    map['total_records'] = totalRecords;
    map['last_page'] = lastPage;
    map['current_page'] = currentPage;
    map['per_page'] = perPage;
    map['message'] = message;
    return map;
  }
}

/// id : 2
/// customer : {"id":3,"first_name":"Pradeep","last_name":"","mobile_number":"9790642170"}
/// counter : {"id":1,"name":"Samantha Beatty"}
/// cashier : {"id":2,"first_name":"Hettie Olson","last_name":"Erik Walter","email":"bhahn@example.net","company_id":1}
/// total_amount : 10.50
/// available_amount : 10.05
/// status : "ACTIVE"
/// created_at : "2022-08-14 07:16:50"
/// products : [{"product_id":6,"product_name":"product 6189minus name 819817856","quantity":1}]

BookingPayments bookingPaymentsFromJson(String str) =>
    BookingPayments.fromJson(json.decode(str));

String bookingPaymentsToJson(BookingPayments data) =>
    json.encode(data.toJson());

class BookingPayments {
  BookingPayments({
    this.id,
    this.quantity,
    this.offlineId,
    this.customer,
    this.counter,
    this.cashier,
    this.totalAmount,
    this.availableAmount,
    this.status,
    this.createdAt,
    this.products,
    this.payments,
    this.promoters,
    this.remarks,
    this.billReferenceNumber,
    this.happenedAt,

  });

  BookingPayments.fromJson(dynamic json) {
    id = json['id'];
    quantity = json['quantity'];

    offlineId = json['offline_id'].toString();
    billReferenceNumber = json['bill_reference_number'];
    happenedAt = json['happened_at'];
    customer =
    json['member'] != null ? UserDetails.fromJson(json['member']) : null;

    if (json['payments'] != null) {
      payments = [];
      json['payments'].forEach((v) {
        payments?.add(BookingPaymentType.fromJson(v));
      });
    }

    counter =
    json['counter'] != null ? Counters.fromJson(json['counter']) : null;
    cashier =
    json['cashier'] != null ? Cashier.fromJson(json['cashier']) : null;
    totalAmount = getRoundedDoubleValue(json['total_amount']);
    availableAmount = getRoundedDoubleValue(json['available_amount']);
    status = json['status'];
    createdAt = json['created_at'];
    remarks = json['remarks'];
    if (json['promoters'] != null) {
      promoters = [];
      json['promoters'].forEach((v) {
        promoters?.add(Promoters.fromJson(v));
      });
    }

    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(BookingProducts.fromJson(v));
      });
    }

  }

  int? id;
  int? quantity;
  String? offlineId;
  UserDetails? customer;
  List<BookingPaymentType>? payments;
  Counters? counter;
  Cashier? cashier;
  double? totalAmount;
  double? availableAmount;
  String? status;
  String? createdAt;
  String? remarks;
  String? billReferenceNumber;
  List<BookingProducts>? products;
  List<Promoters>? promoters;
  String? happenedAt;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['offline_id'] = id;
    map['bill_reference_number'] = billReferenceNumber;
    map['remarks'] = remarks;
    map['happened_at'] = happenedAt;

    if (customer != null) {
      map['member'] = customer?.toJson();
    }

    if (payments != null) {
      map['payments'] = payments?.map((v) => v.toJson()).toList();
    }

    if (counter != null) {
      map['counter'] = counter?.toJson();
    }

    if (cashier != null) {
      map['cashier'] = cashier?.toJson();
    }

    map['quantity'] = quantity;
    map['total_amount'] = totalAmount;
    map['available_amount'] = availableAmount;
    map['status'] = status;
    map['created_at'] = createdAt;
    if (products != null) {
      map['products'] = products?.map((v) => v.toJson()).toList();
    }

    if (promoters != null) {
      map['promoters'] = promoters?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}

class BookingPaymentType {
  BookingPaymentType({
    this.paymentType,
    this.amount,
    this.createdAt,
    this.remarks,
    this.happenedAt,
  });

  BookingPaymentType.fromJson(dynamic json) {
    paymentType = json['payment_type'];
    amount = getDoubleValue(json['amount']);
    createdAt = json['created_at'];
    remarks = json['remarks'];
    happenedAt = json['happened_at'];
  }

  String? paymentType;
  double? amount;
  String? createdAt;
  String? remarks;
  String? happenedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['payment_type'] = paymentType;
    map['amount'] = amount;
    map['created_at'] = createdAt;
    map['remarks'] = remarks;
    map['happened_at'] = happenedAt;

    return map;
  }
}

/// product_id : 6
/// product_name : "product 6189minus name 819817856"
/// quantity : 1

BookingProducts productsFromJson(String str) =>
    BookingProducts.fromJson(json.decode(str));

String productsToJson(BookingProducts data) => json.encode(data.toJson());

class BookingProducts {
  BookingProducts({
    this.productId,
    this.articleNumber,
    this.productName,
    this.quantity,
    this.color,
    this.size,
    this.promoters,
  });

  BookingProducts.fromJson(dynamic json) {
    productId = json['product_id'];
    articleNumber = getStringValue(json['article_number']);
    productName = json['product_name'];
    quantity = json['quantity'];
    color = json['color'] != null ? ProductColor.fromJson(json['color']) : null;
    size = json['size'] != null ? Size.fromJson(json['size']) : null;
    if (json['promoters'] != null) {
      promoters = [];
      json['promoters'].forEach((v) {
        promoters?.add(Promoters.fromJson(v));
      });
    }
  }

  int? productId;
  String? productName;
  String? articleNumber;
  int? quantity;
  ProductColor? color;
  Size? size;
  List<Promoters>? promoters;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['product_id'] = productId;
    map['product_name'] = productName;
    map['quantity'] = quantity;
    map['article_number'] = articleNumber;
    if (promoters != null) {
      map['promoters'] = promoters?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 2
/// first_name : "Hettie Olson"
/// last_name : "Erik Walter"
/// email : "bhahn@example.net"
/// company_id : 1

Cashier cashierFromJson(String str) => Cashier.fromJson(json.decode(str));

String cashierToJson(Cashier data) => json.encode(data.toJson());

/// id : 1
/// name : "Samantha Beatty"

Counters counterFromJson(String str) => Counters.fromJson(json.decode(str));

String counterToJson(Counters data) => json.encode(data.toJson());

/// id : 3
/// first_name : "Pradeep"
/// last_name : ""
/// mobile_number : "9790642170"

Customers customerFromJson(String str) => Customers.fromJson(json.decode(str));

String customerToJson(Customers data) => json.encode(data.toJson());
