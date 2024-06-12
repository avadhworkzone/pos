import 'dart:convert';

import 'package:jakel_base/constants.dart';
import 'package:jakel_base/database/customertypes/CustomerTypesLocalApi.dart';
import 'package:jakel_base/database/memberships/MemberShipsLocalApi.dart';

import 'package:jakel_base/jakel_base.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/restapi/customers/CustomerApi.dart';
import 'package:jakel_base/restapi/customers/model/CreateCustomerRequest.dart';
import 'package:jakel_base/restapi/customers/model/CustomerRaceResponse.dart';
import 'package:jakel_base/restapi/customers/model/CustomerResponse.dart';
import 'package:jakel_base/restapi/customers/model/CustomerTitlesResponse.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/restapi/customers/model/GenderResponse.dart';
import 'package:jakel_base/restapi/customers/model/MemberShipPointsData.dart';
import 'package:jakel_base/restapi/customers/model/MembershipResponse.dart';

import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';

import 'package:rxdart/rxdart.dart';
import 'package:jakel_base/restapi/customers/model/CustomerTypesResponse.dart';

class CustomersViewModel extends BaseViewModel {
  var responseSubject = PublishSubject<CustomersResponse>();

  Stream<CustomersResponse> get responseStream => responseSubject.stream;

  void closeObservable() {
    responseSubject.close();
  }

  Future<MemberShipPointsData> getCustomerPointsAsAmount(
      Customers customer, double totalPayableAmount) async {
    int totalAvailablePoints = getInValue(customer.totalLoyaltyPoints ?? 0);

    var localApi = locator.get<MemberShipsLocalApi>();
    Memberships? memberships =
        await localApi.getById(customer.membershipId ?? 0);

    if (memberships != null) {
      double availableAmount =
          totalAvailablePoints / (memberships.loyaltyPointsPerRinggit ?? 0.0);
      if (totalPayableAmount >= availableAmount) {
        return MemberShipPointsData(totalAvailablePoints, availableAmount,
            memberships.loyaltyPointsPerRinggit ?? 0.0);
      }

      if (availableAmount > totalPayableAmount) {
        int points = getInValue((totalPayableAmount *
            (memberships.loyaltyPointsPerRinggit ?? 0.0)));
        return MemberShipPointsData(points, totalPayableAmount,
            memberships.loyaltyPointsPerRinggit ?? 0.0);
      }
    }
    return MemberShipPointsData(0, 0.0, 0.0);
  }

  void createCustomer(CreateCustomerRequest request) async {
    var api = locator.get<CustomerApi>();

    try {
      var response = await api.createCustomer(request);
      responseSubject.sink.add(response);
    } catch (e) {
      MyLogUtils.logDebug("createCustomer exception $e");
      responseSubject.sink.addError(e);
    }
  }

  void getCustomerDetails(Customers customers) async {
    var api = locator.get<CustomerApi>();

    try {
      var response = await api.getCustomerDetail(customers.id ?? 0);
      responseSubject.sink.add(response);
    } catch (e) {
      MyLogUtils.logDebug("getCustomerDetails exception $e");
      responseSubject.sink.addError(e);
    }
  }

  void updateCustomer(int customerId, CreateCustomerRequest request) async {
    var api = locator.get<CustomerApi>();

    try {
      MyLogUtils.logDebug("updateCustomer request ${request.toJson()}");

      var response = await api.updateCustomer(customerId, request);
      if (response) {
        final data = CustomersResponse(customer: Customers());
        responseSubject.sink.add(data);
      }
    } catch (e) {
      MyLogUtils.logDebug("updateCustomer exception $e");
      responseSubject.sink.addError(e);
    }
  }

  void getCustomers(int pageNo, int perPage) async {
    var api = locator.get<CustomerApi>();

    try {
      var response = await api.getCustomers(pageNo, perPage);

      responseSubject.sink.add(response);
    } catch (e) {
      MyLogUtils.logDebug("getCustomers exception $e");
      responseSubject.sink.addError(e);
    }
  }

  void searchCustomer(String searchText) async {
    var api = locator.get<CustomerApi>();
    try {
      var response = await api.searchCustomer(searchText);
      responseSubject.sink.add(response);
    } catch (e) {
      MyLogUtils.logDebug("searchText exception $e for word $searchText");
      responseSubject.sink.addError(e);
    }
  }

  Future<CustomerDetailsResponse> customerDetails(int id) async {
    var api = locator.get<CustomerApi>();
    try {
      CustomerDetailsResponse response = await api.getCustomerDetailById(id);
      return response;
    } catch (e) {
      return CustomerDetailsResponse();
    }
  }

  Future<List<CustomerTypes>> getCustomerTypes() async {
    var api = locator.get<CustomerTypesLocalApi>();
    var response = await api.getAll();
    return response;
  }

  Future<List<CustomerRaces>> getCustomerRaces() async {
    var api = locator.get<CustomerApi>();
    var response = await api.getRaces();
    return response.races ?? [];
  }

  Future<List<CustomerTitles>> getCustomerTitles() async {
    var api = locator.get<CustomerApi>();
    var response = await api.getTitles();
    return response.titles ?? [];
  }

  Future<List<Genders>> getAllGenders() async {
    var api = locator.get<CustomerApi>();
    var response = await api.getGenders();
    return response.genders ?? [];
  }

  String name(Customers customers) {
    if (customers.lastName != null && customers.firstName != null) {
      return customers.lastName! + customers.firstName!;
    }
    if (customers.firstName != null) {
      return customers.firstName!;
    }

    if (customers.firstName != null) {
      return customers.firstName!;
    }
    return noData;
  }

  String fullName(Customers customers) {
    if (customers.titleDetails?.name != null) {
      return "${customers.titleDetails!.name!}. ${name(customers)}";
    }
    return name(customers);
  }

  String status(Customers customers) {
    return noData;
  }

  String gender(Customers customers) {
    return customers.genderDetails?.name ?? noData;
  }

  String dateOfBirth(Customers customers) {
    return customers.dateOfBirth ?? noData;
  }

  String email(Customers customers) {
    return customers.email ?? noData;
  }

  String mobileNumber(Customers customers) {
    return customers.mobileNumber ?? noData;
  }

  String address(Customers customer) {
    String value = "";
    if (customer.addressLine1 != null) {
      value = "$value${customer.addressLine1!},";
    }

    if (customer.addressLine2 != null) {
      value = "$value${customer.addressLine2!},";
    }

    if (customer.city != null) {
      value = value + customer.city!;
    }
    return value.isEmpty ? noData : value;
  }

  String since(Customers customers) {
    return noData;
  }

  String lastPurchased(Customers customers) {
    return customers.lastPurchaseDate ?? noData;
  }

  String totalOrders(Customers customers) {
    return customers.totalOrders != null ? '${customers.totalOrders}' : noData;
  }

  String spentTillNow(Customers customers) {
    return getReadableAmount(getCurrency(), customers.spentTillNow);
  }

  String type(Customers customers) {
    return customers.typeDetails?.name ?? noData;
  }

  String race(Customers customers) {
    return customers.raceDetails?.name ?? noData;
  }

  String voucherDescription(CustomerVouchers voucher) {
    MyLogUtils.logDebug("voucherDescription voucher : ${voucher.toJson()}");

    String description = "";

    if (voucher.discountType == "FLAT" ||
        voucher.discountType == "Flat" ||
        voucher.discountType?.toLowerCase() == "flat") {
      if (voucher.minimumSpendAmount != null) {
        description =
            "Flat ${getCurrency()} ${voucher.flatAmount} off with minimum spend amount of ${voucher.minimumSpendAmount}";
      } else {
        description = "Flat  ${getCurrency()} ${voucher.flatAmount} off";
      }
    }

    if (voucher.discountType == "PERCENTAGE" ||
        voucher.discountType == "Percentage" ||
        voucher.discountType?.toUpperCase() == "PERCENTAGE") {
      if (voucher.minimumSpendAmount != null) {
        description =
            "${voucher.percentage} % off with minimum spend amount of ${voucher.minimumSpendAmount}";
      } else {
        description = "${voucher.flatAmount} % off";
      }
    }

    return description;
  }
}
