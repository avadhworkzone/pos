import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

/// gift_cards : [{"type":{"id":1,"name":"Single Use Only","key":"SINGLE_USE_ONLY"},"number":"1021","expiry_date":"","total_amount":200.00,"available_amount":200.00,"status":{"id":1,"name":"Active","key":"ACTIVE"},"created_at":"2023-01-01 14:33:02"}]
/// total_records : 4
/// last_page : 2
/// current_page : 1
/// per_page : 3

GiftCardsResponse giftCardsResponseFromJson(String str) =>
    GiftCardsResponse.fromJson(json.decode(str));

String giftCardsResponseToJson(GiftCardsResponse data) =>
    json.encode(data.toJson());

class GiftCardsResponse {
  GiftCardsResponse({
    this.giftCards,
    this.totalRecords,
    this.lastPage,
    this.currentPage,
    this.perPage,
  });

  GiftCardsResponse.fromJson(dynamic json) {
    if (json['gift_cards'] != null) {
      giftCards = [];
      json['gift_cards'].forEach((v) {
        giftCards?.add(GiftCards.fromJson(v));
      });
    }
    totalRecords = json['total_records'];
    lastPage = json['last_page'];
    currentPage = json['current_page'];
    perPage = json['per_page'];
  }

  List<GiftCards>? giftCards;
  int? totalRecords;
  int? lastPage;
  int? currentPage;
  int? perPage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (giftCards != null) {
      map['gift_cards'] = giftCards?.map((v) => v.toJson()).toList();
    }
    map['total_records'] = totalRecords;
    map['last_page'] = lastPage;
    map['current_page'] = currentPage;
    map['per_page'] = perPage;
    return map;
  }
}

/// type : {"id":1,"name":"Single Use Only","key":"SINGLE_USE_ONLY"}
/// number : "1021"
/// expiry_date : ""
/// total_amount : 200.00
/// available_amount : 200.00
/// status : {"id":1,"name":"Active","key":"ACTIVE"}
/// created_at : "2023-01-01 14:33:02"

GiftCards giftCardsFromJson(String str) => GiftCards.fromJson(json.decode(str));

String giftCardsToJson(GiftCards data) => json.encode(data.toJson());

class GiftCards {
  GiftCards({
    this.id,
    this.type,
    this.number,
    this.expiryDate,
    this.totalAmount,
    this.availableAmount,
    this.status,
    this.createdAt,
  });

  GiftCards.fromJson(dynamic json) {
    id = json['id'];
    type = json['type'] != null ? GiftCardType.fromJson(json['type']) : null;
    number = json['number'];
    expiryDate = json['expiry_date'];
    totalAmount = getDoubleValue(json['total_amount']);
    availableAmount = getDoubleValue(json['available_amount']);
    status = json['status'] != null ? GiftCardStatus.fromJson(json['status']) : null;
    createdAt = json['created_at'];
  }

  int? id;
  GiftCardType? type;
  String? number;
  String? expiryDate;
  double? totalAmount;
  double? availableAmount;
  GiftCardStatus? status;
  String? createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (type != null) {
      map['type'] = type?.toJson();
    }

    map['id'] = id;
    map['number'] = number;
    map['expiry_date'] = expiryDate;
    map['total_amount'] = totalAmount;
    map['available_amount'] = availableAmount;
    if (status != null) {
      map['status'] = status?.toJson();
    }
    map['created_at'] = createdAt;
    return map;
  }
}

/// id : 1
/// name : "Active"
/// key : "ACTIVE"

GiftCardStatus statusFromJson(String str) => GiftCardStatus.fromJson(json.decode(str));

String statusToJson(GiftCardStatus data) => json.encode(data.toJson());

class GiftCardStatus {
  GiftCardStatus({
    this.id,
    this.name,
    this.key,
  });

  GiftCardStatus.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    key = json['key'];
  }

  int? id;
  String? name;
  String? key;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['key'] = key;
    return map;
  }
}

/// id : 1
/// name : "Single Use Only"
/// key : "SINGLE_USE_ONLY"

GiftCardType typeFromJson(String str) =>
    GiftCardType.fromJson(json.decode(str));

String typeToJson(GiftCardType data) => json.encode(data.toJson());

class GiftCardType {
  GiftCardType({
    this.id,
    this.name,
    this.key,
  });

  GiftCardType.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    key = json['key'];
  }

  int? id;
  String? name;
  String? key;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['key'] = key;
    return map;
  }
}
