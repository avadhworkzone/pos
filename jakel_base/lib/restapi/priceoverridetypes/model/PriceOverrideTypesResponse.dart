/// price_override_types : [{"id":1,"name":"Percentage","key":"PERCENTAGE"},{"id":2,"name":"Flat","key":"FLAT"}]

class PriceOverrideTypesResponse {
  PriceOverrideTypesResponse({
    this.priceOverrideTypes,
  });

  PriceOverrideTypesResponse.fromJson(dynamic json) {
    if (json['price_override_types'] != null) {
      priceOverrideTypes = [];
      json['price_override_types'].forEach((v) {
        priceOverrideTypes?.add(PriceOverrideTypes.fromJson(v));
      });
    }
  }

  List<PriceOverrideTypes>? priceOverrideTypes;

  PriceOverrideTypesResponse copyWith({
    List<PriceOverrideTypes>? priceOverrideTypes,
  }) =>
      PriceOverrideTypesResponse(
        priceOverrideTypes: priceOverrideTypes ?? this.priceOverrideTypes,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (priceOverrideTypes != null) {
      map['price_override_types'] =
          priceOverrideTypes?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 1
/// name : "Percentage"
/// key : "PERCENTAGE"

class PriceOverrideTypes {
  PriceOverrideTypes({
    this.id,
    this.name,
    this.key,
  });

  PriceOverrideTypes.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    key = json['key'];
  }

  int? id;
  String? name;
  String? key;

  PriceOverrideTypes copyWith({
    int? id,
    String? name,
    String? key,
  }) =>
      PriceOverrideTypes(
        id: id ?? this.id,
        name: name ?? this.name,
        key: key ?? this.key,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['key'] = key;
    return map;
  }
}
