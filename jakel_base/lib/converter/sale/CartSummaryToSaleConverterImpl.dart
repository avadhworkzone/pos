import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/utils/num_utils.dart';

import '../../restapi/sales/model/history/SalesResponse.dart';
import '../../restapi/sales/model/history/SaveSaleResponse.dart';
import '../../restapi/vouchers/model/VouchersListResponse.dart';
import '../../sale/get_extra_details_from_mbb.dart';
import 'CartSummaryToSaleConverter.dart';

class CartSummaryToSaleConverterImpl extends CartSummaryToSaleConverter {
  @override
  Future<Sale?> getSaleFromCartSummary(CartSummary cartSummary) {
    double totalTaxAmount = cartSummary.cartPrice?.tax ?? 0;

    UsedVoucherInSale? voucher;

    if (cartSummary.voucherDiscountAmount != null &&
        cartSummary.voucherDiscountAmount! > 0) {
      voucher = UsedVoucherInSale(
          amount: cartSummary.voucherDiscountAmount,
          voucherType: cartSummary.voucherType);
    }

    List<String>? extraDetails = getExtraDetailsFromMbb(cartSummary);

    Sale sale = Sale(
        offlineSaleId: cartSummary.offlineSaleId,
        totalTaxAmount: totalTaxAmount,
        saleRoundOffAmount: cartSummary.cartPrice?.roundOff ?? 0,
        userType: getUSerType(cartSummary),
        userDetails: getUserDetails(cartSummary),
        totalDiscountAmount: cartSummary.cartPrice?.discount ?? 0,
        totalAmountPaid: cartSummary.getPaidAmount(),
        saleNotes: cartSummary.remarks,
        vouchers: _getSaleVouchers(cartSummary),
        usedVoucher: voucher,
        payments: _getPayments(cartSummary),
        saleItems: _getSaleItems(cartSummary),
        extraDetails: extraDetails,
        changeDue: cartSummary.changeDue ?? 0.0);

    return Future(() => sale);
  }

  String? getUSerType(CartSummary cartSummary) {
    if (cartSummary.customers != null) {
      return "Member";
    }

    if (cartSummary.employees != null) {
      return "Employee";
    }

    return null;
  }

  UserDetails? getUserDetails(CartSummary cartSummary) {
    if (cartSummary.customers != null) {
      return UserDetails.fromJson(cartSummary.customers?.toJson());
    }

    if (cartSummary.employees != null) {
      return UserDetails.fromJson(cartSummary.employees?.toJson());
    }

    return null;
  }

  List<Vouchers> _getSaleVouchers(CartSummary cartSummary) {
    List<Vouchers> saleItems = List.empty(growable: true);
    cartSummary.voucherConfigs?.forEach((element) {
      saleItems.add(Vouchers(
          discountType: element.discountType == 2 ? "FLAT" : "PERCENTAGE",
          expiryDate: element.expiredAt,
          flatAmount: element.flatAmount,
          percentage: element.percentage,
          number: element.number,
          minimumSpendAmount: element.minimumSpendAmount));
    });
    return saleItems;
  }

  List<SaleItems> _getSaleItems(CartSummary cartSummary) {
    List<SaleItems> saleItems = List.empty(growable: true);
    cartSummary.cartItems?.forEach((element) {
      saleItems.add(SaleItems(
          productId: element.product?.id,
          quantity: element.qty,
          promoters: element.promoters,
          complimentary: element.isComplementaryItem()
              ? SaleComplimentary(
                  amount: element.cartItemPrice?.totalAmount, authorizer: "")
              : null,
          originalPricePerUnit: element.getOriginalProductPrice(),
          totalTaxAmount: element.cartItemPrice?.taxAmount,
          totalPricePaid: element.cartItemPrice?.totalAmount,
          pricePaidPerUnit: getRoundedDoubleValue(
              (element.cartItemPrice?.totalAmount ?? 0) / (element.qty ?? 1)),
          totalDiscountAmount: element.getTotalDiscountAmount(),
          product: Product.fromJson(element.product?.toJson())));
    });
    return saleItems;
  }

  List<Payments> _getPayments(CartSummary cartSummary) {
    List<Payments>? payments = List.empty(growable: true);

    cartSummary.payments?.forEach((element) {
      Payments payment = Payments(
          id: element.paymentType?.id,
          amount: element.amount,
          paymentType: PaymentType(
              id: element.paymentType?.id, name: element.paymentType?.name));
      payments.add(payment);
    });
    return payments;
  }
}
