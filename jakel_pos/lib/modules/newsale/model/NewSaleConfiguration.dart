import 'dart:convert';

/// newSaleCartCalculationSteps : [{"key":"SUB_TOTAL","order":1},{"key":"SUB_TOTAL","order":1}]

NewSaleConfiguration newSaleConfigurationFromJson(String str) =>
    NewSaleConfiguration.fromJson(json.decode(str));

String newSaleConfigurationToJson(NewSaleConfiguration data) =>
    json.encode(data.toJson());

class NewSaleConfiguration {
  NewSaleConfiguration({
    this.newSaleCartCalculationSteps,
  });

  NewSaleConfiguration.fromJson(dynamic json) {
    if (json['newSaleCartCalculationSteps'] != null) {
      newSaleCartCalculationSteps = [];
      json['newSaleCartCalculationSteps'].forEach((v) {
        newSaleCartCalculationSteps
            ?.add(NewSaleCartCalculationSteps.fromJson(v));
      });
    }
  }

  List<NewSaleCartCalculationSteps>? newSaleCartCalculationSteps;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (newSaleCartCalculationSteps != null) {
      map['newSaleCartCalculationSteps'] =
          newSaleCartCalculationSteps?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// key : "SUB_TOTAL"
/// order : 1
/// allowedInReturns : false
/// allowedInExchange:true

NewSaleCartCalculationSteps newSaleCartCalculationStepsFromJson(String str) =>
    NewSaleCartCalculationSteps.fromJson(json.decode(str));

String newSaleCartCalculationStepsToJson(NewSaleCartCalculationSteps data) =>
    json.encode(data.toJson());

class NewSaleCartCalculationSteps {
  NewSaleCartCalculationSteps(
      {this.key, this.order, this.allowedInExchange, this.allowedInReturns});

  NewSaleCartCalculationSteps.fromJson(dynamic json) {
    key = json['key'];
    order = json['order'];
    allowedInExchange = json['allowedInExchange'];
    allowedInReturns = json['allowedInReturns'];
  }

  String? key;
  int? order;
  bool? allowedInExchange;
  bool? allowedInReturns;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    map['order'] = order;
    map['allowedInExchange'] = allowedInExchange;
    map['allowedInReturns'] = allowedInReturns;

    return map;
  }
}
