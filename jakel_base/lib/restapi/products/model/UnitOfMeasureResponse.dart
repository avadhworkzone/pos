import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

/// unit_of_measures : [{"id":1,"name":"Ellen Upton III","derivatives":[{"id":1,"name":"843totam","ratio":46.81},{"id":2,"name":"338delectus","ratio":14.94},{"id":3,"name":"884cupiditate","ratio":59.81},{"id":4,"name":"199quasi","ratio":0.56},{"id":5,"name":"270iusto","ratio":57.05}]}]

UnitOfMeasureResponse unitOfMeasureResponseFromJson(String str) =>
    UnitOfMeasureResponse.fromJson(json.decode(str));

String unitOfMeasureResponseToJson(UnitOfMeasureResponse data) =>
    json.encode(data.toJson());

class UnitOfMeasureResponse {
  UnitOfMeasureResponse({
    List<UnitOfMeasures>? unitOfMeasures,
  }) {
    _unitOfMeasures = unitOfMeasures;
  }

  UnitOfMeasureResponse.fromJson(dynamic json) {
    if (json['unit_of_measures'] != null) {
      _unitOfMeasures = [];
      json['unit_of_measures'].forEach((v) {
        _unitOfMeasures?.add(UnitOfMeasures.fromJson(v));
      });
    }
  }

  List<UnitOfMeasures>? _unitOfMeasures;

  UnitOfMeasureResponse copyWith({
    List<UnitOfMeasures>? unitOfMeasures,
  }) =>
      UnitOfMeasureResponse(
        unitOfMeasures: unitOfMeasures ?? _unitOfMeasures,
      );

  List<UnitOfMeasures>? get unitOfMeasures => _unitOfMeasures;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_unitOfMeasures != null) {
      map['unit_of_measures'] =
          _unitOfMeasures?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 1
/// name : "Ellen Upton III"
/// derivatives : [{"id":1,"name":"843totam","ratio":46.81},{"id":2,"name":"338delectus","ratio":14.94},{"id":3,"name":"884cupiditate","ratio":59.81},{"id":4,"name":"199quasi","ratio":0.56},{"id":5,"name":"270iusto","ratio":57.05}]

UnitOfMeasures unitOfMeasuresFromJson(String str) =>
    UnitOfMeasures.fromJson(json.decode(str));

String unitOfMeasuresToJson(UnitOfMeasures data) => json.encode(data.toJson());

class UnitOfMeasures {
  UnitOfMeasures({
    int? id,
    String? name,
    bool? allowDecimalQty,
    List<Derivatives>? derivatives,
  }) {
    _id = id;
    _name = name;
    _allowDecimalQty = allowDecimalQty;
    _derivatives = derivatives;
  }

  UnitOfMeasures.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _allowDecimalQty = json['allow_decimal_qty'];
    if (json['derivatives'] != null) {
      _derivatives = [];
      json['derivatives'].forEach((v) {
        _derivatives?.add(Derivatives.fromJson(v));
      });
    }
  }

  int? _id;
  String? _name;
  bool? _allowDecimalQty;
  List<Derivatives>? _derivatives;

  int? get id => _id;

  String? get name => _name;

  bool? get allowDecimalQty => _allowDecimalQty;

  List<Derivatives>? get derivatives => _derivatives;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['allow_decimal_qty'] = _allowDecimalQty;

    if (_derivatives != null) {
      map['derivatives'] = _derivatives?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 1
/// name : "843totam"
/// ratio : 46.81

Derivatives derivativesFromJson(String str) =>
    Derivatives.fromJson(json.decode(str));

String derivativesToJson(Derivatives data) => json.encode(data.toJson());

class Derivatives {
  Derivatives({
    int? id,
    String? name,
    double? ratio,
  }) {
    _id = id;
    _name = name;
    _ratio = ratio;
  }

  Derivatives.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _ratio = getDoubleValue(json['ratio']);
  }

  int? _id;
  String? _name;
  double? _ratio;

  Derivatives copyWith({
    int? id,
    String? name,
    double? ratio,
  }) =>
      Derivatives(
        id: id ?? _id,
        name: name ?? _name,
        ratio: ratio ?? _ratio,
      );

  int? get id => _id;

  String? get name => _name;

  double? get ratio => _ratio;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['ratio'] = _ratio;
    return map;
  }
}
