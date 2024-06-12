import 'package:dio/dio.dart';
import 'package:jakel_base/restapi/BaseApi.dart';
import 'package:jakel_base/restapi/loyaltycampaigns/LoyaltyCampaignsApi.dart';
import 'package:jakel_base/restapi/loyaltycampaigns/model/LoyaltyCampaignsResponse.dart';

class LoyaltyCampaignsAPIImpl extends BaseApi with LoyaltyCampaignsApi {
  @override
  Future<LoyaltyCampaignsResponse> getLoyaltyCampaigns() async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + getLoyaltyCampaignsUrl;

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      return LoyaltyCampaignsResponse.fromJson(response.data);
    }

    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }
}
