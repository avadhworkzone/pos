import 'package:dio/dio.dart';
import 'package:jakel_base/restapi/BaseApi.dart';
import 'package:jakel_base/restapi/products/ProductsApi.dart';
import 'package:jakel_base/restapi/products/model/UnitOfMeasureResponse.dart';
import '../../utils/MyLogUtils.dart';
import 'model/ProductsResponse.dart';

class ProductsApiImpl extends BaseApi with ProductsApi {
  @override
  Future<ProductsResponse> getProducts(int pageNo, int perPage) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = '$masterUrl$productsUrl$pageNo&per_page=$perPage';

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      return ProductsResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<UnitOfMeasureResponse> getUnitOfMeasures() async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + unitOfMeasuresUrl;

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      return UnitOfMeasureResponse.fromJson(response.data);
    }

    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }
}
