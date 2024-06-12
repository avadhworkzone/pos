import 'package:dio/dio.dart';
import 'package:jakel_base/restapi/BaseApi.dart';

import 'package:jakel_base/restapi/vouchers/model/BirthdayVoucherResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/VoucherConfigurationResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/VouchersListResponse.dart';
import 'package:jakel_base/utils/my_date_utils.dart';

import '../../utils/MyLogUtils.dart';
import 'VoucherApi.dart';

class VoucherApiImpl extends BaseApi with VoucherApi {
  @override
  Future<VoucherConfigurationResponse> getVoucherConfigurations() async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + vouchersConfigurationUrl;

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      return VoucherConfigurationResponse.fromJson(response.data);
    }

    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<VouchersListResponse> getVouchers(int pageNo, int perPage) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    var url = "$masterUrl$vouchersUrl?";

    if (pageNo > 0) {
      url = "${url}page=$pageNo";
    }

    if (perPage > 0) {
      url = "$url&per_page=$perPage";
    }

    MyLogUtils.logDebug("getVouchers Url : $url");
    Response response = await dio.get(url);

    MyLogUtils.logDebug("getVouchers statusCode : ${response.statusCode}");

    if (response.statusCode == 200) {
      return VouchersListResponse.fromJson(response.data);
    }

    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<BirthdayVoucherResponse> generateBirthdayVoucher(int customerId,
      VoucherConfiguration voucherConfiguration, String number) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();

    final url = '$masterUrl$generateMemberBirthdayVoucherUrl$customerId';

    MyLogUtils.logDebug("generateBirthdayVoucher  url : $url");

    int discountType = (voucherConfiguration.flatAmount != null &&
            voucherConfiguration.flatAmount! > 0)
        ? 2
        : 1;
    Map<String, dynamic> requestMap = {};

    requestMap.putIfAbsent(
        "voucher_configuration_id", () => voucherConfiguration.id);

    requestMap.putIfAbsent("discount_type", () => discountType);

    requestMap.putIfAbsent("number", () => number);

    requestMap.putIfAbsent("minimum_spend_amount",
        () => voucherConfiguration.useMinimumSpendAmount);

    requestMap.putIfAbsent(
        "expired_at",
        () => dateYmd(getNow()
            .add(Duration(days: voucherConfiguration.validityDays ?? 0))
            .millisecondsSinceEpoch));

    requestMap.putIfAbsent("happened_at", () => dateYmdHis(getNow()));

    if (discountType == 1) {
      requestMap.putIfAbsent(
          "percentage", () => voucherConfiguration.percentage);
    } else {
      requestMap.putIfAbsent(
          "flat_amount", () => voucherConfiguration.flatAmount);
    }

    MyLogUtils.logDebug("generateBirthdayVoucher requestMap : ${requestMap}");

    FormData formData =
        FormData.fromMap(requestMap, ListFormat.multiCompatible);

    for (var element in formData.fields) {
      MyLogUtils.logDebug(
          "generateBirthdayVoucher  request element : ${element.key} = ${element.value}");
    }

    Response response = await dio.post(url, data: formData);

    MyLogUtils.logDebug("generateBirthdayVoucher response : ${response.data}");

    if (response.statusCode == 200 || response.statusCode == 412) {
      var saveSaleResponse = BirthdayVoucherResponse.fromJson(response.data);
      MyLogUtils.logDebug(
          "generateBirthdayVoucher response : ${response.data}");
      return saveSaleResponse;
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }
}
