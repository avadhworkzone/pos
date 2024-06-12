import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsResponse.dart';
import 'package:jakel_base/restapi/promoters/model/PromotersResponse.dart';
import 'package:jakel_base/restapi/sales/model/history/SalesResponse.dart';
import 'package:jakel_base/utils/num_utils.dart';

/// booking_payment_products : {"id":105,"offline_id":"","member":{"id":75,"first_name":"krishna1","last_name":"","mobile_number":"601190909090","company_id":5,"email":"t1@mailinator.com"},"total_amount":1000,"available_amount":1000,"created_at":"2023-08-22 00:21:35","status":"ACTIVE","mismatches":["",""],"remarks":"","bill_reference_number":"b12","promoters":[{"id":9,"first_name":"Promoter 11","last_name":"","staff_id":"PR11"}],"products":[{"product_id":3913,"product_name":"IZZAH JUBAH","article_number":0,"size":{"id":4,"name":"L","code":""},"color":{"id":57,"name":"MINT","code":""},"quantity":3,"upc":"JBH032320004","type_id":{"id":1,"name":"Regular Product","key":"REGULAR_PRODUCT"},"promoters":[{"id":9,"first_name":"Promoter 11","last_name":"","staff_id":"PR11"}]},{"product_id":3916,"product_name":"IZZAH JUBAH","article_number":0,"size":{"id":5,"name":"M","code":""},"color":{"id":57,"name":"MINT","code":""},"quantity":2,"upc":"JBH032320003","type_id":{"id":1,"name":"Regular Product","key":"REGULAR_PRODUCT"},"promoters":[{"id":9,"first_name":"Promoter 11","last_name":"","staff_id":"PR11"}]}],"payments":[{"payment_type":"Cash","amount":1000,"created_at":"2023-08-22 00:21:35","remarks":""}]}

class ResetBookingResponse {
  ResetBookingResponse({
      this.bookingPaymentProducts,});

  ResetBookingResponse.fromJson(dynamic json) {
    bookingPaymentProducts = json['booking_payment_products'] != null ? BookingPaymentProducts.fromJson(json['booking_payment_products']) : null;
  }
  BookingPaymentProducts? bookingPaymentProducts;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (bookingPaymentProducts != null) {
      map['booking_payment_products'] = bookingPaymentProducts?.toJson();
    }
    return map;
  }

}

/// id : 105
/// offline_id : ""
/// member : {"id":75,"first_name":"krishna1","last_name":"","mobile_number":"601190909090","company_id":5,"email":"t1@mailinator.com"}
/// total_amount : 1000
/// available_amount : 1000
/// created_at : "2023-08-22 00:21:35"
/// status : "ACTIVE"
/// mismatches : ["",""]
/// remarks : ""
/// bill_reference_number : "b12"
/// promoters : [{"id":9,"first_name":"Promoter 11","last_name":"","staff_id":"PR11"}]
/// products : [{"product_id":3913,"product_name":"IZZAH JUBAH","article_number":0,"size":{"id":4,"name":"L","code":""},"color":{"id":57,"name":"MINT","code":""},"quantity":3,"upc":"JBH032320004","type_id":{"id":1,"name":"Regular Product","key":"REGULAR_PRODUCT"},"promoters":[{"id":9,"first_name":"Promoter 11","last_name":"","staff_id":"PR11"}]},{"product_id":3916,"product_name":"IZZAH JUBAH","article_number":0,"size":{"id":5,"name":"M","code":""},"color":{"id":57,"name":"MINT","code":""},"quantity":2,"upc":"JBH032320003","type_id":{"id":1,"name":"Regular Product","key":"REGULAR_PRODUCT"},"promoters":[{"id":9,"first_name":"Promoter 11","last_name":"","staff_id":"PR11"}]}]
/// payments : [{"payment_type":"Cash","amount":1000,"created_at":"2023-08-22 00:21:35","remarks":""}]

class BookingPaymentProducts {
  BookingPaymentProducts({
      this.id, 
      this.offlineId, 
      this.member, 
      this.totalAmount, 
      this.availableAmount, 
      this.createdAt, 
      this.status, 
      this.mismatches, 
      this.remarks, 
      this.billReferenceNumber, 
      this.promoters, 
      this.products, 
      this.payments,});

  BookingPaymentProducts.fromJson(dynamic json) {
    id = json['id'];
    offlineId = json['offline_id'];
    member = json['member'] != null ? UserDetails.fromJson(json['member']) : null;
    totalAmount = getRoundedDoubleValue(json['total_amount']);
    availableAmount = getRoundedDoubleValue(json['available_amount']);
    createdAt = json['created_at'];
    status = json['status'];
    mismatches = json['mismatches'] != null ? json['mismatches'].cast<String>() : [];
    remarks = json['remarks'];
    billReferenceNumber = json['bill_reference_number'];
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
    if (json['payments'] != null) {
      payments = [];
      json['payments'].forEach((v) {
        payments?.add(BookingPaymentType.fromJson(v));
      });
    }
  }
  int? id;
  String? offlineId;
  UserDetails? member;
  double? totalAmount;
  double? availableAmount;
  String? createdAt;
  String? status;
  List<String>? mismatches;
  String? remarks;
  String? billReferenceNumber;
  List<Promoters>? promoters;
  List<BookingProducts>? products;
  List<BookingPaymentType>? payments;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['offline_id'] = offlineId;
    if (member != null) {
      map['member'] = member?.toJson();
    }
    map['total_amount'] = getDoubleValue(totalAmount);
    map['available_amount'] = availableAmount;
    map['created_at'] = createdAt;
    map['status'] = status;
    map['mismatches'] = mismatches;
    map['remarks'] = remarks;
    map['bill_reference_number'] = billReferenceNumber;
    if (promoters != null) {
      map['promoters'] = promoters?.map((v) => v.toJson()).toList();
    }
    if (products != null) {
      map['products'] = products?.map((v) => v.toJson()).toList();
    }
    if (payments != null) {
      map['payments'] = payments?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

