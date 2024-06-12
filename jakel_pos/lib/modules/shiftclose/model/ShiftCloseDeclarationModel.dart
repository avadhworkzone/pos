import 'dart:collection';

import 'package:jakel_base/restapi/counters/model/CloseCounterRequest.dart';
import 'package:jakel_base/restapi/counters/model/ShiftDetailsResponse.dart';
import 'package:jakel_base/restapi/managers/model/StoreManagersResponse.dart';

class ShiftCloseDeclarationModel {
  CounterClosingDetails? closingDetails;
  StoreManagers? storeManagers;
  bool? isDeclarationDone = false;
  HashMap<int, double>? paymentDeclaration;
  bool? paymentMismatch = false;
  List<Denominations>? denominations;

  ShiftCloseDeclarationModel(
      {this.closingDetails,
      this.isDeclarationDone,
      this.storeManagers,
      this.denominations,
      this.paymentDeclaration,
      this.paymentMismatch});

  factory ShiftCloseDeclarationModel.fromJson(dynamic json) {
    return ShiftCloseDeclarationModel(
        closingDetails: json['closingDetails'] != null
            ? CounterClosingDetails.fromJson(json['closingDetails'])
            : null,
        denominations: json['denominations'] != null
            ? (json['denominations'] as List)
                .map((i) => Denominations.fromJson(i))
                .toList()
            : [],
        storeManagers: json['storeManagers'] != null
            ? StoreManagers.fromJson(json['storeManagers'])
            : null,
        paymentMismatch: json['paymentMismatch'],
        paymentDeclaration: json['paymentDeclaration'],
        isDeclarationDone: json['isDeclarationDone']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (closingDetails != null) {
      data['closingDetails'] = closingDetails?.toJson();
    }

    if (storeManagers != null) {
      data['storeManagers'] = storeManagers?.toJson();
    }

    if (isDeclarationDone != null) {
      data['isDeclarationDone'] = isDeclarationDone;
    }

    if (paymentDeclaration != null) {
      data['paymentDeclaration'] = paymentDeclaration;
    }

    if (paymentMismatch != null) {
      data['paymentMismatch'] = paymentMismatch;
    }

    if (denominations != null) {
      data['denominations'] = denominations?.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
