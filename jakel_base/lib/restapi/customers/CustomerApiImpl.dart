import 'package:dio/dio.dart';
import 'package:jakel_base/restapi/BaseApi.dart';
import 'package:jakel_base/restapi/customers/CustomerApi.dart';
import 'package:jakel_base/restapi/customers/model/CreateCustomerRequest.dart';
import 'package:jakel_base/restapi/customers/model/CustomerRaceResponse.dart';
import 'package:jakel_base/restapi/customers/model/CustomerResponse.dart';
import 'package:jakel_base/restapi/customers/model/CustomerTitlesResponse.dart';
import 'package:jakel_base/restapi/customers/model/CustomerTypesResponse.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/restapi/customers/model/GenderResponse.dart';
import 'package:jakel_base/restapi/customers/model/MembershipResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';

import 'model/MemberGroupResponse.dart';

class CustomerApiImpl extends BaseApi with CustomerApi {
  @override
  Future<CustomerTypesResponse> getCustomerTypes() async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + customerTypesUrl;

    MyLogUtils.logDebug("getCustomerTypes url : ${url}");

    Response response = await dio.get(url);
    MyLogUtils.logDebug("getCustomerTypes data : ${response.data}");

    if (response.statusCode == 200) {
      return CustomerTypesResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<CustomersResponse> getCustomers(int pageNo, int perPage) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    var url = "$masterUrl$customersUrl?";
    if (pageNo > 0) {
      url = "${url}page=$pageNo";
    }

    if (perPage > 0) {
      url = "$url&per_page=$perPage";
    }

    Response response = await dio.get(url);

    MyLogUtils.logDebug("getCustomers response : ${response.data}");

    if (response.statusCode == 200) {
      return CustomersResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<GenderResponse> getGenders() async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + gendersUrl;

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      return GenderResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<CustomerRaceResponse> getRaces() async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + customerRacesUrl;

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      return CustomerRaceResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<CustomerTitlesResponse> getTitles() async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + customerTitlesUrl;

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      return CustomerTitlesResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<CustomersResponse> createCustomer(
      CreateCustomerRequest request) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + saveCustomerUrl;

    FormData formData = FormData.fromMap(request.toJson());

    Response response = await dio.post(url, data: formData);

    MyLogUtils.logDebug("createCustomer response : ${response.data}");

    if (response.statusCode == 200) {
      return CustomersResponse.fromJson(response.data);
    }

    if (response.statusCode == 412) {
      logError(url, response.statusCode, response.data['message']);
      return CustomersResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<CustomersResponse> searchCustomer(String search) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url =
        "$masterUrl$customersUrl?search_text=$search&per_page=20&page=1";
    //final url = "$masterUrl$searchCustomersUrl?search_text=$search";

    MyLogUtils.logDebug("searchCustomer url : $url");

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      return CustomersResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<bool> updateCustomer(int customerId,
      CreateCustomerRequest request) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();

    MyLogUtils.logDebug("updateCustomer request : ${request.toJson()}");

    final url = "$masterUrl$updateCustomersUrl/$customerId";

    MyLogUtils.logDebug("updateCustomer url : $url");

    FormData formData = FormData.fromMap(request.toJson());

    Response response = await dio.post(url, data: formData);

    MyLogUtils.logDebug("updateCustomer response : ${response.data}");

    if (response.statusCode == 200) {
      return true;
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<MembershipResponse> getMembershipDetails() async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + getMembershipsUrl;

    MyLogUtils.logDebug("getMembershipDetails url : $url");

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      return MembershipResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<CustomersResponse> getCustomerDetail(int customerId) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();

    final url = '$masterUrl$updateCustomersUrl' '/$customerId';
    MyLogUtils.logDebug("getCustomerDetail url : ${url} ");
    Response response = await dio.get(url);
    if (response.statusCode == 200) {
      MyLogUtils.logDebug("getCustomerDetail response : ${response.data} ");

      return CustomersResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<CustomerDetailsResponse> getCustomerDetailById(int customerId) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();

    final url = '$masterUrl$updateCustomersUrl' '/$customerId';
    MyLogUtils.logDebug("getCustomerDetail url : ${url} ");
    Response response = await dio.get(url);
    if (response.statusCode == 200) {
      MyLogUtils.logDebug(
          "getCustomerDetail response : ${response.data} ");
      CustomerDetailsResponse mCustomerResponse =
      CustomerDetailsResponse.fromJson(response.data);
      MyLogUtils.logDebug("getCustomerDetail response : ${response.data} ");
      return mCustomerResponse;
    }

    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<MemberGroupResponse> getMemberGroup() async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();

    final url = '$masterUrl$memberGroupList';
    MyLogUtils.logDebug("getMemberGroup url : ${url}");
    Response response = await dio.get(url);
    MyLogUtils.logDebug("getMemberGroup response : ${response.data}");
    if (response.statusCode == 200) {
      return MemberGroupResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }
}
