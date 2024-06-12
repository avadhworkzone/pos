import 'package:dio/dio.dart';
import 'package:jakel_base/restapi/BaseApi.dart';
import 'package:jakel_base/restapi/generatememberloyaltypointvoucher/GenerateMemberLoyaltyPointVoucherApi.dart';
import 'package:jakel_base/restapi/generatememberloyaltypointvoucher/model/GenerateMemberLoyaltyPointVoucherRequest.dart';
import 'package:jakel_base/restapi/generatememberloyaltypointvoucher/model/GenerateMemberLoyaltyPointVoucherResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';

class GenerateMemberLoyaltyPointVouchersApiImpl extends BaseApi
    with GenerateMemberLoyaltyPointVoucherApi {
  @override
  Future<GenerateMemberLoyaltyPointVoucherResponse> generateMemberLoyaltyPointVoucher(
      GenerateMemberLoyaltyPointVoucherRequest request) async {
    MyLogUtils.logDebug(
        "generateMemberLoyaltyPointVoucher  request : ${request.toJson()}");
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = "$masterUrl$generateMemberLoyaltyPointVoucherUrl";

    MyLogUtils.logDebug("paymentDeclaration  url : $url");

    FormData formData =
    FormData.fromMap(request.toJson(), ListFormat.multiCompatible);

    for (var element in formData.fields) {
      MyLogUtils.logDebug(
          "generateMemberLoyaltyPointVoucher  request element : ${element
              .key} = ${element.value}");
    }

    var response = await dio.post(url, data: formData);

    MyLogUtils.logDebug(
        "generateMemberLoyaltyPointVoucher response data: ${response.data}");

    MyLogUtils.logDebug(
        "generateMemberLoyaltyPointVoucher response statusCode: ${response
            .statusCode}");

    if (response.statusCode == 200) {
      return GenerateMemberLoyaltyPointVoucherResponse.fromJson(response.data);
    }
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }
}
