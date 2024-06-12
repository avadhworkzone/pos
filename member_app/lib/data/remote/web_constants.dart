
import 'package:member_app/common/app_constants.dart';

class WebConstants {
  /// Standard Comparison Values
  static int statusCode200 = 200;
  static int statusCode400 = 400;
  static int statusCode422 = 422;

  static String statusMessageOK = "OK";
  static String statusMessageBadRequest = "Bad Request";
  static String statusMessageEntityError = "Unprocessable Entity Error";
  static String statusMessageTokenIsExpired = "Token is Expired";

  /// Web response cases
  static String statusCode200Message =
      "{  \"error\" : true,\n  \"statusCode\" : 200,\n  \"statusMessage\" : \"Success Request\",\n  \"data\" : {\"message\":\" Success \"},\n  \"responseTime\" : 1639548038\n  }";
 static String statusCode401Message =
      "{  \"error\" : true,\n  \"statusCode\" : 401,\n  \"statusMessage\" : \"Unauthenticated\",\n  \"data\" : {\"message\":\"Unauthenticated\"},\n  \"responseTime\" : 1639548038\n  }";
 static String statusCode403Message =
      "{  \"error\" : true,\n  \"statusCode\" : 403,\n  \"statusMessage\" : \"Bad Request\",\n  \"data\" : {\"message\":\"Unauthorized error\"},\n  \"responseTime\" : 1639548038\n  }";
  static String statusCode404Message =
      "{  \"error\" : true,\n  \"statusCode\" : 404,\n  \"statusMessage\" : \"Bad Request\",\n  \"data\" : {\"message\":\"Unable to find the action URL\"},\n  \"responseTime\" : 1639548038\n  }";
  static String statusCode412Message =
      "{  \"error\" : true,\n  \"statusCode\" : 412,\n  \"statusMessage\" : \"Bad Request\",\n  \"data\" : {\"message\":\"Unable to find the action URL\"},\n  \"responseTime\" : 1639548038\n  }";
  static String statusCode422Message =
      "{  \"error\" : true,\n  \"statusCode\" : 412,\n  \"statusMessage\" : \"Bad Request\",\n  \"data\" : {\"message\":\"Unable to find the action URL\"},\n  \"responseTime\" : 1639548038\n  }";
  static String statusCode502Message =
      "{\r\n  \"error\": true,\r\n  \"statusCode\": 502,\r\n  \"statusMessage\": \"Bad Request\",\r\n  \"data\": {\r\n    \"message\": \"Server Error, Please try after sometime\"\r\n  },\r\n  \"responseTime\": 1639548038\r\n}";
  static String statusCode503Message =
      "{  \"error\" : true,\n  \"statusCode\" : 503,\n  \"statusMessage\" : \"Bad Request\",\n  \"data\" : {\"message\":\"Unable to process your request right now, Please try again later\"},\n  \"responseTime\" : 1639548038\n  }";

  /// Control

  /// Base URL
  static String baseUrlLive = "https://retail.ariani.my/api/member/";
  static String baseUrlDev = "https://arianidevpos.freshbits.in/api/member/";
  static String baseUrlStaging = "https://stagingretail.ariani.my/api/member/";

  static String baseURL =AppConstants.isLiveURLStaging?baseUrlStaging:
  (AppConstants.isLiveURLToUse ? baseUrlLive : baseUrlDev);

  /// send otp
  static String actionLoginMobileNumberScreen = "${baseURL}send-otp";

  ///validate-otp
  static String actionLoginMobileNumberOtpScreen = "${baseURL}validate-otp";

  ///get-members
  static String actionGetMembers = "${baseURL}get-members";

  ///get-genders
  static String actionGetGenders = "${baseURL}get-genders";

  ///get-races
  static String actionGetRaces = "${baseURL}get-races";

  ///get-titles
  static String actionGetTitles = "${baseURL}get-titles";

  ///get-members-details
  static String actionGetMembersDetails = "${baseURL}member-details";

  ///get-all-members-vouchers
  static String actionMemberVoucherPaginatedList = "${baseURL}member/vouchers";

  ///Transactions-List
  static String actionTransactionsList = "${baseURL}transactions-list";

  ///profile-update
  static String actionProfileUpdate = "${baseURL}profile-update";

  ///upload-profile-photo
  static String actionUploadProfilePic = "${baseURL}upload-profile-photo";

  ///delete-member
  static String actionDeleteMember = "${baseURL}delete-member";

}
