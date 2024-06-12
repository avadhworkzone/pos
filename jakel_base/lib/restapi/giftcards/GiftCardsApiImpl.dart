import 'package:dio/dio.dart';
import 'package:jakel_base/restapi/BaseApi.dart';

import '../../utils/MyLogUtils.dart';
import 'GiftCardsApi.dart';

import 'model/GiftCardsResponse.dart';

class GiftCardsApiImpl extends BaseApi with GiftCardsApi {
  @override
  Future<GiftCardsResponse> getGiftCards(int pageNo, int perPage) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    var url = "$masterUrl$giftCardsUrl?";

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
      return GiftCardsResponse.fromJson(response.data);
    }

    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }
}
