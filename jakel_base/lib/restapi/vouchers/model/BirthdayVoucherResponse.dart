import 'dart:convert';

import 'package:jakel_base/restapi/vouchers/model/VouchersListResponse.dart';

/// birthday_voucher : {"id":1,"member_id":1398,"discount_type":"PERCENTAGE","number":"1VTCG1669554622","minimum_spend_amount":0.01,"percentage":15.4,"flat_amount":10.01,"expiry_date":"2022-12-24T21:20:50.000000Z","mismatches":["Specified voucher expiry date is not valid. Actual expiry date for voucher is 2022-12-25 And, Given expiry date is 2022-12-27","Specified minimum spend amount is not valid. Actual minimum spend amount is 0.01 And, Requested Minimum spend amount is 0.02"]}

BirthdayVoucherResponse birthdayVoucherResponseFromJson(String str) =>
    BirthdayVoucherResponse.fromJson(json.decode(str));

String birthdayVoucherResponseToJson(BirthdayVoucherResponse data) =>
    json.encode(data.toJson());

class BirthdayVoucherResponse {
  BirthdayVoucherResponse({
    this.birthdayVoucher,
    this.message,
  });

  BirthdayVoucherResponse.fromJson(dynamic json) {
    birthdayVoucher = json['birthday_voucher'] != null
        ? Vouchers.fromJson(json['birthday_voucher'])
        : null;
    message = json['message'];
  }

  Vouchers? birthdayVoucher;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (birthdayVoucher != null) {
      map['birthday_voucher'] = birthdayVoucher?.toJson();
    }
    map['message'] = message;
    return map;
  }
}

/// id : 1
/// member_id : 1398
/// discount_type : "PERCENTAGE"
/// number : "1VTCG1669554622"
/// minimum_spend_amount : 0.01
/// percentage : 15.4
/// flat_amount : 10.01
/// expiry_date : "2022-12-24T21:20:50.000000Z"
/// mismatches : ["Specified voucher expiry date is not valid. Actual expiry date for voucher is 2022-12-25 And, Given expiry date is 2022-12-27","Specified minimum spend amount is not valid. Actual minimum spend amount is 0.01 And, Requested Minimum spend amount is 0.02"]

Vouchers birthdayVoucherFromJson(String str) =>
    Vouchers.fromJson(json.decode(str));

String birthdayVoucherToJson(Vouchers data) => json.encode(data.toJson());
