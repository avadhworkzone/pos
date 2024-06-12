import 'package:jakel_base/utils/num_utils.dart';

/// booking_payment_top_up : {"id":84,"member":{"id":73,"first_name":"kk","last_name":"","mobile_number":"601141541541","company_id":5,"email":""},"total_amount":360,"available_amount":360,"status":"ACTIVE","mismatches":["mismatches mismatches","mismatches mismatches"],"created_at":"2023-07-26 12:55:30","payments":[{"payment_type":"Cash","amount":350,"created_at":"2023-07-26 12:55:30","remarks":""},{"payment_type":"Cash","amount":10,"created_at":"2023-07-31 14:14:06","remarks":""}]}

class BookingPaymentsTopUpResponse {
  BookingPaymentsTopUpResponse({
      this.bookingPaymentTopUp,});

  BookingPaymentsTopUpResponse.fromJson(dynamic json) {
    bookingPaymentTopUp = json['booking_payment_top_up'] != null ? BookingPaymentTopUp.fromJson(json['booking_payment_top_up']) : null;
  }
  BookingPaymentTopUp? bookingPaymentTopUp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (bookingPaymentTopUp != null) {
      map['booking_payment_top_up'] = bookingPaymentTopUp?.toJson();
    }
    return map;
  }

}

/// id : 84
/// member : {"id":73,"first_name":"kk","last_name":"","mobile_number":"601141541541","company_id":5,"email":""}
/// total_amount : 360
/// available_amount : 360
/// status : "ACTIVE"
/// mismatches : ["mismatches mismatches","mismatches mismatches"]
/// created_at : "2023-07-26 12:55:30"
/// payments : [{"payment_type":"Cash","amount":350,"created_at":"2023-07-26 12:55:30","remarks":""},{"payment_type":"Cash","amount":10,"created_at":"2023-07-31 14:14:06","remarks":""}]

class BookingPaymentTopUp {
  BookingPaymentTopUp({
      this.id, 
      this.member, 
      this.totalAmount, 
      this.availableAmount, 
      this.status, 
      this.mismatches, 
      this.createdAt, 
      this.payments,});

  BookingPaymentTopUp.fromJson(dynamic json) {
    id = json['id'];
    member = json['member'] != null ? Member.fromJson(json['member']) : null;
    totalAmount = getDoubleValue(json['total_amount']);
    availableAmount = getDoubleValue(json['available_amount']);
    status = json['status'];
    mismatches = json['mismatches'] != null ? json['mismatches'].cast<String>() : [];
    createdAt = json['created_at'];
    if (json['payments'] != null) {
      payments = [];
      json['payments'].forEach((v) {
        payments?.add(Payments.fromJson(v));
      });
    }
  }
  int? id;
  Member? member;
  double? totalAmount;
  double? availableAmount;
  String? status;
  List<String>? mismatches;
  String? createdAt;
  List<Payments>? payments;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    if (member != null) {
      map['member'] = member?.toJson();
    }
    map['total_amount'] = totalAmount;
    map['available_amount'] = availableAmount;
    map['status'] = status;
    map['mismatches'] = mismatches;
    map['created_at'] = createdAt;
    if (payments != null) {
      map['payments'] = payments?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// payment_type : "Cash"
/// amount : 350
/// created_at : "2023-07-26 12:55:30"
/// remarks : ""

class Payments {
  Payments({
      this.paymentType, 
      this.amount, 
      this.createdAt, 
      this.remarks,});

  Payments.fromJson(dynamic json) {
    paymentType = json['payment_type'];
    amount = getDoubleValue(json['amount']);
    createdAt = json['created_at'];
    remarks = json['remarks'];
  }
  String? paymentType;
  double? amount;
  String? createdAt;
  String? remarks;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['payment_type'] = paymentType;
    map['amount'] = amount;
    map['created_at'] = createdAt;
    map['remarks'] = remarks;
    return map;
  }

}

/// id : 73
/// first_name : "kk"
/// last_name : ""
/// mobile_number : "601141541541"
/// company_id : 5
/// email : ""

class Member {
  Member({
      this.id, 
      this.firstName, 
      this.lastName, 
      this.mobileNumber, 
      this.companyId, 
      this.email,});

  Member.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobileNumber = json['mobile_number'];
    companyId = json['company_id'];
    email = json['email'];
  }
  int? id;
  String? firstName;
  String? lastName;
  String? mobileNumber;
  int? companyId;
  String? email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['mobile_number'] = mobileNumber;
    map['company_id'] = companyId;
    map['email'] = email;
    return map;
  }

}