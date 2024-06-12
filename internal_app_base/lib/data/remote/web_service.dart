import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_constants.dart';
import 'web_common_response.dart';
import 'web_exceptions.dart';
import 'web_request.dart';

class Webservice {
  static final Webservice _instance = Webservice._internal();

  factory Webservice() => _instance;

  Webservice._internal();

  Map<String, String> postHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Map<String, String> getHeaders = {
    'Content-Type': 'application/json',
    "Accept": "application/json"
  };

  Future<dynamic> getWithAuthAndStringRequest(
      String action, dynamic params) async {
    Map mapResponseJson;
    String tokenValue = await SharedPrefs().getUserToken();
    getHeaders.addAll({'Authorization': "Bearer $tokenValue"});
    // var requestJson = jsonEncode(params);

    debugPrint("##getWithAuthAndClassRequest###");
    debugPrint("##action### $action");
    debugPrint("##tokenValue### $tokenValue");
    debugPrint("##params### $params");
    debugPrint("##action+requestJson### ${action + params}");

    try {
      final response = await http.get(
        Uri.parse(action + params),
        headers: getHeaders,
      );
      mapResponseJson = processResponseToJson(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return mapResponseJson;
  }

  Future<dynamic> getWithAuthAndClassQueryRequest(
      String action, dynamic params) async {
    Map mapResponseJson;
    String tokenValue = await SharedPrefs().getUserToken();
    getHeaders.addAll({'Authorization': "Bearer $tokenValue"});

    debugPrint("##getWithAuthAndClassQueryRequest###");
    debugPrint("##action### $action");
    debugPrint("##tokenValue### $tokenValue");
    debugPrint("##params### ${jsonEncode(params)}");

    try {
      final uri = Uri.parse(action).replace(queryParameters: params);
      debugPrint("##uri### $uri");
      final response = await http.get(
        uri,
        headers: getHeaders,
      );
      mapResponseJson = processResponseToJson(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return mapResponseJson;
  }

  Future<dynamic> getWithAuthWithoutRequest(String action) async {
    Map mapResponseJson;

    String tokenValue = await SharedPrefs().getUserToken();
    postHeaders.addAll({'Authorization': "Bearer $tokenValue"});
    debugPrint("##action### ${action}");
    debugPrint("##tokenValue### ${tokenValue}");
    try {
      final response = await http.get(Uri.parse(action), headers: postHeaders);
      mapResponseJson = processResponseToJson(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return mapResponseJson;
  }

  // Future<dynamic> getWithAuthAndClassQueryRequest2(
  //     String action, dynamic params) async {
  //   Map mapResponseJson;
  //   String tokenValue = await SharedPrefs().getUserToken();
  //   postHeaders.addAll({'Authorization': "Bearer $tokenValue"});
  //   var arr = ["2023-05-01", "2023-05-28"];
  //   debugPrint("##getWithAuthAndClassQueryRequest###");
  //   debugPrint("##action### $action");
  //   debugPrint("##tokenValue### $tokenValue");
  //   debugPrint("##params### ${jsonEncode(params)}");
  //   final queryParameters = {
  //     'sort_by': 'id',
  //     'sort_direction': 'desc',
  //     'per_page': '10',
  //     'page': '1',
  //     'store_id': '55',
  //     'date_range': arr.toString(),
  //   };
  //
  //   try {
  //     final uri = Uri.parse(
  //         "https://arianidevpos.freshbits.in/api/promoter/get-promoter-commission-history?sort_by=id&sort_direction=desc&per_page=10&page=1&store_id=55&date_range[]=2023-05-01&date_range[]=2023-05-28");
  //     debugPrint("##uri2### $uri");
  //     final response = await http.get(
  //       uri,
  //       headers: postHeaders,
  //     );
  //     mapResponseJson = processResponseToJson(response);
  //   } on SocketException {
  //     throw FetchDataException('No Internet connection');
  //   }
  //   return mapResponseJson;
  // }

  Future<dynamic> getWithAuthAndQueryAndStringRequest(
      String action, dynamic params, dynamic stringParams) async {
    Map mapResponseJson;
    String tokenValue = await SharedPrefs().getUserToken();
    postHeaders.addAll({'Authorization': "Bearer $tokenValue"});

    debugPrint("##getWithAuthAndClassQueryRequest###");
    debugPrint("##action### $action");
    debugPrint("##tokenValue### $tokenValue");
    debugPrint("##params### ${jsonEncode(params)}");

    // var requestJson = jsonEncode(stringParams);
    debugPrint("##stringParams### $stringParams");
    debugPrint("##action+stringParams### ${action + stringParams}");

    try {
      final uri =
          Uri.parse(action + stringParams).replace(queryParameters: params);
      final response = await http.get(
        uri,
        headers: postHeaders,
      );
      mapResponseJson = processResponseToJson(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return mapResponseJson;
  }

  Future<dynamic> postWithAuthAndRequest(String action, dynamic params) async {
    Map mapResponseJson;

    String tokenValue = await SharedPrefs().getUserToken();
    postHeaders.addAll({'Authorization': "Bearer $tokenValue"});
    var requestJson = jsonEncode(params);

    debugPrint("##postWithAuthAndRequest###");
    debugPrint("##action### $action");
    debugPrint("##tokenValue### $tokenValue");
    debugPrint("##params### $requestJson");

    try {
      final response = await http.post(Uri.parse(action),
          headers: postHeaders, body: requestJson);
      mapResponseJson = processResponseToJson(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return mapResponseJson;
  }

  Future<dynamic> postWithoutAuthAndRequest(String action) async {
    Map mapResponseJson;
    postHeaders.removeWhere((key, value) => key == "Authorization");

    try {
      final response = await http.post(Uri.parse(action), headers: postHeaders);
      mapResponseJson = processResponseToJson(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return mapResponseJson;
  }

  Future<dynamic> postWithAuthWithoutRequest(String action) async {
    Map mapResponseJson;

    postHeaders.addAll({'Authorization': "Bearer ${WebRequest.sBearerToken}"});

    try {
      final response = await http.post(Uri.parse(action), headers: postHeaders);
      mapResponseJson = processResponseToJson(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return mapResponseJson;
  }

  Future<dynamic> postWithRequestWithoutAuth(
      String action, dynamic param) async {
    Map mapResponseJson = {};
    postHeaders.removeWhere((key, value) => key == "Authorization");

    var requestJson = jsonEncode(param);
    debugPrint("##action### ${action}");
    debugPrint("##param### ${requestJson}");

    try {
      final response = await http.post(Uri.parse(action),
          headers: postHeaders, body: requestJson);
      mapResponseJson = processResponseToJson(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return mapResponseJson;
  }

  Future<dynamic> postWithAuthAndRequestAndAttachment(
      String action, String filePath) async {
    Map mapResponseJson;

    postHeaders.addAll({'Authorization': "Bearer ${WebRequest.sBearerToken}"});

    var postUri = Uri.parse(action);

    http.MultipartRequest request = http.MultipartRequest("POST", postUri);

    try {
      request.headers.addAll(postHeaders);
      if (filePath.isNotEmpty) {
        http.MultipartFile multipartFile =
            await http.MultipartFile.fromPath('photo', filePath);
        request.files.add(multipartFile);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      mapResponseJson = processResponseToJson(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return mapResponseJson;
  }

  Map processResponseToJson(http.Response response) {
    WebCommonResponse mWebCommonResponse = WebCommonResponse();
    mWebCommonResponse.statusCode = response.statusCode.toString();

    var responseBody = response.body;
    debugPrint("statusCode   :   ${response.statusCode}");
    debugPrint("responseBody   :   $responseBody");

    switch (response.statusCode) {
      case 200:
        mWebCommonResponse.data = responseBody.isNotEmpty
            ? responseBody.toString()
            : WebConstants.statusCode200Message;
        return mWebCommonResponse.toJson();
      case 400:
        mWebCommonResponse.data = responseBody.toString();
        return mWebCommonResponse.toJson();
      case 403:
        mWebCommonResponse.data = responseBody.isNotEmpty
            ? responseBody.toString()
            : WebConstants.statusCode404Message;
        return mWebCommonResponse.toJson();

      case 401:
        mWebCommonResponse.data = responseBody.isNotEmpty
            ? responseBody.toString()
            : WebConstants.statusCode404Message;
        return mWebCommonResponse.toJson();
      case 404:
        mWebCommonResponse.data = responseBody.isNotEmpty
            ? responseBody.toString()
            : WebConstants.statusCode404Message;
        return mWebCommonResponse.toJson();
      case 412:
        mWebCommonResponse.data = responseBody.isNotEmpty
            ? responseBody.toString()
            : WebConstants.statusCode412Message;
        return mWebCommonResponse.toJson();
      case 422:
        mWebCommonResponse.data = responseBody.isNotEmpty
            ? responseBody.toString()
            : WebConstants.statusCode422Message;
        return mWebCommonResponse.toJson();
      case 500:
        mWebCommonResponse.data = responseBody.isNotEmpty
            ? responseBody.toString()
            : WebConstants.statusCode502Message;
        return mWebCommonResponse.toJson();
      case 502:
        mWebCommonResponse.data = responseBody.isNotEmpty
            ? responseBody.toString()
            : WebConstants.statusCode502Message;
        return mWebCommonResponse.toJson();
      case 503:
        mWebCommonResponse.data = responseBody.isNotEmpty
            ? responseBody.toString()
            : WebConstants.statusCode503Message;
        return mWebCommonResponse.toJson();
      default:
        mWebCommonResponse.data = responseBody.isNotEmpty
            ? responseBody.toString()
            : WebConstants.statusCode503Message;
        return mWebCommonResponse.toJson();
    }
  }
}
