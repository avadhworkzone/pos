import 'package:jakel_base/database/sale/model/CartCustomDiscount.dart';
import 'package:jakel_base/database/sale/model/CartPrice.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/restapi/sales/model/UpdateLoyaltyPointsRequest.dart';
import 'package:jakel_base/restapi/vouchers/model/VoucherConfigurationResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/VouchersListResponse.dart';
import 'package:jakel_base/serialportdevices/model/MayBankPaymentDetails.dart';
import 'package:jakel_base/utils/num_utils.dart';

import '../../../restapi/companyconfiguration/model/CompanyConfigurationResponse.dart';
import '../../../restapi/employees/model/EmployeesResponse.dart';
import '../../../restapi/promoters/model/PromotersResponse.dart';
import '../../../restapi/sales/model/NewSaleRequest.dart';
import 'CartItem.dart';
import 'PaymentTypeData.dart';
import 'PromotionData.dart';
import 'ReturnItem.dart';

enum SaleTye { REGULAR, LAYAWYAY, BOOKING, RETURNS }

class CartSummary {
  CartPrice? cartPrice;
  CartCustomDiscount? cartCustomDiscount;

  String? offlineSaleId;
  List<CartItem>? cartItems;
  List<ReturnItem>? returnItems;
  List<PaymentTypeData>? payments;
  List<Promoters>? promoters;

  // this is used to create Sale Voucher Configs and sent o sale api
  List<VoucherConfiguration>? selectedVoucherConfigs;

  // This mainly user in offline sale calculated using selectedVoucherConfigs
  List<SaleVoucherConfigs>? voucherConfigs;
  List<CompanyRoundOffConfiguration>? roundingOffConfigurations;
  Customers? customers;
  Employees? employees;
  String? remarks;
  String? billReferenceNumber;
  SaleTye saleTye;
  bool isLayAwaySale;
  bool isBookingSale;
  bool isBookingItemReset = false;
  int returnBookingSaleId = 0;
  PromotionData? promotionData;
  bool autoPickPromotions;
  String? voucherErrorMessage;
  String? voucherCode;
  Vouchers? vouchers;
  double? voucherDiscountAmount;
  String? voucherType;
  double? cashBackAmount;
  int? cashbackId;
  double? changeDue;
  bool? isExchange;
  bool? isReturns;
  bool? triggerCustomerPopUpAtLeastOnce;
  List<MayBankPaymentDetails>? mayBankPaymentDetailList;
  String? happenedAt;
  CompanyConfigurationResponse? companyConfiguration;

  List<LoyaltyPoints>? loyaltyPoints;

  CartSummary({this.cartPrice,
    this.cartItems,
    this.isExchange,
    this.offlineSaleId,
    this.voucherType,
    this.returnItems,
    this.payments,
    this.promoters,
    this.happenedAt,
    this.employees,
    this.voucherConfigs,
    this.selectedVoucherConfigs,
    this.customers,
    this.mayBankPaymentDetailList,
    this.triggerCustomerPopUpAtLeastOnce,
    this.roundingOffConfigurations,
    this.billReferenceNumber,
    this.companyConfiguration,
    this.remarks,
    this.cashBackAmount,
    this.cashbackId,
    this.isLayAwaySale = false,
    this.isBookingSale = false,
    this.isBookingItemReset = false,
    this.returnBookingSaleId = 0,
    this.promotionData,
    this.autoPickPromotions = true,
    this.voucherCode,
    this.vouchers,
    this.voucherErrorMessage,
    this.voucherDiscountAmount,
    this.changeDue,
    this.isReturns,
    this.cartCustomDiscount,
    this.loyaltyPoints,
    this.saleTye = SaleTye.REGULAR});

  factory CartSummary.fromJson(dynamic json) {
    SaleTye getSaleType(String type) {
      if (type == "SaleTye.RETURNS") {
        return SaleTye.RETURNS;
      }

      if (type == "SaleTye.REGULAR") {
        return SaleTye.REGULAR;
      }

      if (type == "SaleTye.LAYAWYAY") {
        return SaleTye.LAYAWYAY;
      }

      return SaleTye.BOOKING;
    }

    return CartSummary(
        cartPrice: json['cartPrice'] != null
            ? CartPrice.fromJson(json['cartPrice'])
            : null,
        payments: json['payments'] != null
            ? (json['payments'] as List)
            .map((i) => PaymentTypeData.fromJson(i))
            .toList()
            : [],
        cartItems: json['cartItems'] != null
            ? (json['cartItems'] as List)
            .map((i) => CartItem.fromJson(i))
            .toList()
            : [],
        promoters: json['promoters'] != null
            ? (json['promoters'] as List)
            .map((i) => Promoters.fromJson(i))
            .toList()
            : [],
        mayBankPaymentDetailList: json['mayBankPaymentDetailList'] != null
            ? (json['mayBankPaymentDetailList'] as List)
            .map((i) => MayBankPaymentDetails.fromJson(i))
            .toList()
            : [],
        selectedVoucherConfigs: json['selectedVoucherConfigs'] != null
            ? (json['selectedVoucherConfigs'] as List)
            .map((i) => VoucherConfiguration.fromJson(i))
            .toList()
            : [],
        voucherConfigs: json['voucherConfigs'] != null
            ? (json['voucherConfigs'] as List)
            .map((i) => SaleVoucherConfigs.fromJson(i))
            .toList()
            : [],
        returnItems: json['returnItems'] != null
            ? (json['returnItems'] as List)
            .map((i) => ReturnItem.fromJson(i))
            .toList()
            : [],
        roundingOffConfigurations: json['roundingOffConfigurations'] != null
            ? (json['roundingOffConfigurations'] as List)
            .map((i) => CompanyRoundOffConfiguration.fromJson(i))
            .toList()
            : [],
        customers: json['customers'] != null
            ? Customers.fromJson(json['customers'])
            : null,
        employees: json['employees'] != null
            ? Employees.fromJson(json['employees'])
            : null,
        companyConfiguration: json['companyConfiguration'] != null
            ? CompanyConfigurationResponse.fromJson(
            json['companyConfiguration'])
            : null,
        promotionData: json['promotionData'] != null
            ? PromotionData.fromJson(json['promotionData'])
            : null,
        vouchers: json['vouchers'] != null
            ? Vouchers.fromJson(json['vouchers'])
            : null,
        cartCustomDiscount: json['cartCustomDiscount'] != null
            ? CartCustomDiscount.fromJson(json['cartCustomDiscount'])
            : null,
        loyaltyPoints: json['loyalty_points'] != null
            ? (json['loyalty_points'] as List)
            .map((i) => LoyaltyPoints.fromJson(i))
            .toList()
            : [],
        offlineSaleId: json['offlineSaleId'],
        happenedAt: json['happenedAt'],
        cashbackId: json['cashbackId'],
        cashBackAmount: getDoubleValue(json['cashBackAmount']),
        saleTye: getSaleType(json['saleType']),
        isLayAwaySale: json['isLayAwaySale'],
        isBookingSale: json['isBookingSale'],
        autoPickPromotions: json['autoPickPromotions'],
        voucherCode: json['voucherCode'],
        voucherType: json['voucherType'],
        voucherDiscountAmount: getDoubleValue(json['voucherDiscountAmount']),
        voucherErrorMessage: json['voucherErrorMessage'],
        changeDue: json['changeDue'],
        isReturns: json['isReturns'],
        isExchange: json['isExchange'],
        triggerCustomerPopUpAtLeastOnce:
        json['triggerCustomerPopUpAtLeastOnce'],
        billReferenceNumber: json['billReferenceNumber'],
        remarks: json['remarks']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (cartPrice != null) {
      data['cartPrice'] = cartPrice?.toJson();
    }

    if (payments != null) {
      data['payments'] = payments?.map((v) => v.toJson()).toList();
    }

    if (cartItems != null) {
      data['cartItems'] = cartItems?.map((v) => v.toJson()).toList();
    }

    if (promoters != null) {
      data['promoters'] = promoters?.map((v) => v.toJson()).toList();
    }

    if (mayBankPaymentDetailList != null) {
      data['mayBankPaymentDetailList'] =
          mayBankPaymentDetailList?.map((v) => v.toJson()).toList();
    }

    if (roundingOffConfigurations != null) {
      data['roundingOffConfigurations'] =
          roundingOffConfigurations?.map((v) => v.toJson()).toList();
    }

    if (selectedVoucherConfigs != null) {
      data['selectedVoucherConfigs'] =
          selectedVoucherConfigs?.map((v) => v.toJson()).toList();
    }

    if (voucherConfigs != null) {
      data['voucherConfigs'] = voucherConfigs?.map((v) => v.toJson()).toList();
    }

    if (returnItems != null) {
      data['returnItems'] = returnItems?.map((v) => v.toJson()).toList();
    }

    if (customers != null) {
      data['customers'] = customers?.toJson();
    }

    if (cartCustomDiscount != null) {
      data['cartCustomDiscount'] = cartCustomDiscount?.toJson();
    }

    if (companyConfiguration != null) {
      data['companyConfiguration'] = companyConfiguration?.toJson();
    }

    if (employees != null) {
      data['employees'] = employees?.toJson();
    }

    if (vouchers != null) {
      data['vouchers'] = vouchers?.toJson();
    }

    if (promotionData != null) {
      data['promotionData'] = promotionData?.toJson();
    }
    if (loyaltyPoints != null) {
      data['loyalty_points'] = loyaltyPoints?.map((v) => v.toJson()).toList();
    }
    data['happenedAt'] = happenedAt;
    data['offlineSaleId'] = offlineSaleId;
    data['cashBackAmount'] = cashBackAmount;
    data['saleType'] = saleTye.toString();
    data['isLayAwaySale'] = isLayAwaySale;
    data['isBookingSale'] = isBookingSale;
    data['autoPickPromotions'] = autoPickPromotions;
    data['voucherDiscountAmount'] = voucherDiscountAmount;
    data['voucherCode'] = voucherCode;
    data['voucherType'] = voucherType;
    data['voucherErrorMessage'] = voucherErrorMessage;
    data['cashbackId'] = cashbackId;
    data['cashBackAmount'] = cashBackAmount;
    data['changeDue'] = changeDue;
    data['isExchange'] = isExchange;
    data['isReturns'] = isReturns;
    data['triggerCustomerPopUpAtLeastOnce'] = triggerCustomerPopUpAtLeastOnce;
    data['billReferenceNumber'] = billReferenceNumber;
    return data;
  }

  @override
  String toString() {
    return '${toJson()}';
  }

  double getPaidAmount() {
    double paidAmount = 0.0;

    payments?.forEach((element) {
      paidAmount = paidAmount + element.amount;
    });

    return paidAmount;
  }

  double getDueAmount() {
    double total = (cartPrice?.total ?? 0);
    // if (isExchange == true) {
    //   total = -total;
    // }
    return getDoubleValue(total - getPaidAmount());
  }

  double getPayableExcludingProducts(List<int> productIds) {
    double payableTotal = 0.0;

    cartItems?.forEach((element) {
      if (!productIds.contains(element.product?.id)) {
        payableTotal = payableTotal + (element.cartItemPrice?.totalAmount ?? 0);
      }
    });

    return payableTotal;
  }

  double getPayableExcludingCategory(List<int> categoryIds) {
    double payableTotal = 0.0;

    cartItems?.forEach((element) {
      if (!element.isAvailableInGivenCategory(categoryIds)) {
        payableTotal = payableTotal + (element.cartItemPrice?.totalAmount ?? 0);
      }
    });

    return payableTotal;
  }

  bool isExchangeOrReturns() {
    if (isExchange == null && isReturns == null) {
      return false;
    }

    if ((isExchange != null && isExchange == true) ||
        (isReturns != null && isReturns == true)) {
      return true;
    }
    return false;
  }

  int getTotalLoyaltyPoints() {
    int totalLoyaltyPoints = 0;

    loyaltyPoints?.forEach((element) {
      totalLoyaltyPoints = totalLoyaltyPoints + (element.points ?? 0);
    });

    return totalLoyaltyPoints;
  }

  // double getRoundOff() {
  //   return ((cartPrice?.roundOff ?? 0) - (cartPrice?.returnRoundOff ?? 0));
  // }

  resetPaymentType() {
    changeDue = 0.0;
    payments = [];
  }

  double getTotalAmount() {
    return cartPrice?.total ?? 0;
  }
}
