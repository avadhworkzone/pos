import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsResponse.dart';
import 'package:jakel_base/restapi/paymenttypes/model/PaymentTypesResponse.dart';
import 'package:jakel_base/utils/num_utils.dart';

class PaymentTypeData {
  PaymentTypes? paymentType;
  double amount;
  BookingPayments? bookingPayments;
  int? loyaltyPoints;
  int? giftCardId;
  String? giftCardNumber;
  int? creditNoteId;
  String? cardNo;

  PaymentTypeData({this.paymentType,
    this.amount = 0.0,
    this.giftCardId,
    this.giftCardNumber,
    this.creditNoteId,
    this.cardNo,
    this.bookingPayments,
    this.loyaltyPoints});

  factory PaymentTypeData.fromJson(dynamic json) {
    return PaymentTypeData(
      paymentType: json['paymentType'] != null
          ? PaymentTypes.fromJson(json['paymentType'])
          : null,
      bookingPayments: json['bookingPayments'] != null
          ? BookingPayments.fromJson(json['bookingPayments'])
          : null,
      amount: getRoundedDoubleValue(json['amount']),
      loyaltyPoints: json['loyaltyPoints'],
      giftCardId: json['giftCardId'],
      giftCardNumber: json['giftCardNumber'],
      creditNoteId: json['creditNoteId'],
      cardNo: json['cardNo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['amount'] = amount;
    data['loyaltyPoints'] = loyaltyPoints;
    data['giftCardId'] = giftCardId;
    data['creditNoteId'] = creditNoteId;
    data['cardNo'] = cardNo;
    if (paymentType != null) {
      data['paymentType'] = paymentType?.toJson();
    }

    if (bookingPayments != null) {
      data['bookingPayments'] = bookingPayments?.toJson();
    }

    return data;
  }

  @override
  String toString() {
    return '${toJson()}';
  }
}
