import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:jakel_base/database/user/UserLocalApi.dart';
import 'package:jakel_base/database/user/UserLocalApiImpl.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/appinfo/get_app_info.dart';
import 'package:jakel_base/utils/my_unique_id.dart';

import '../logs/MyLogs.dart';

class BaseApi {
  final String loginUrl = "/login"; //POST
  final String meUrl = "/me"; //GET
  final String storesUrl = "/cashier-stores"; //GET
  final String countersUrl = "/store-counters/"; //GET
  final String openCounterUrl = "/open-counter"; // POST
  final String storeManagersUrl = "/store-manager-list"; // GET
  final String cashierPermissionsUrl = "/cashier-permissions-list"; // GET
  final String getPaymentTypesUrl = "/get-payment-types"; // GET
  final String productsUrl = "/products?page="; //GET
  final String saleReturnReasonsUrl = "/sale-return-reasons"; //GET
  final String unitOfMeasuresUrl = "/get-all-unit-of-measures"; //GET
  final String unitOfMeasureDerivativeUrl = "/get-unit-of-measure-derivatives/";
  final String promotersUrl = "/get-all-promoters"; //GET
  final String directorsUrl = "/directors"; //GET
  final String complimentaryItemReasons = "/complimentary-item-reasons"; //GET
  final String pettyCashUsageReasons = "/petty-cash-usage-reasons"; //GET
  final String cashMovementReasons = "/cash-movement-reasons"; //GET
  final String saveCashMovements = "/cash-movements"; //POST
  final String customersUrl = "/get-paginated-members"; //GET
  final String gendersUrl = "/get-genders"; //GET
  final String customerTypesUrl = "/get-member-types"; //GET
  final String customerRacesUrl = "/get-races"; //GET
  final String customerTitlesUrl = "/get-titles"; //GET
  final String saveCustomerUrl = "/save-member"; //POST
  final String saveSale = "/save-sale-details"; // POST
  final String getRegularAndCompletedLayawaySales =
      "/get-paginated-regular-and-completed-layaway-sales"; // GET
  final String searchCustomersUrl = "/search-members"; //GET
  final String promotionsUrl = "/promotions"; //GET
  final String updateCustomersUrl = "/members"; //POST
  final String getPendingLayawaySales = "/get-pending-layaway-sales"; // GET
  final String voidSaleReasonsUrl = "/void-sale-reasons"; //GET
  final String voidASaleUrl = "/sales"; // POST
  final String getPaginatedVoidSaleList = "/get-paginated-voided-sales"; // GET
  final String newBookingPayment = "/booking-payments"; // GET
  final String resetBookingPaymentsList = "/reset-booking-payment-products/"; //POST
  final String bookingPaymentsList = "/get-paginated-booking-payments"; //GET
  final String bookingPaymentsRefund = "/booking-payments/"; //POST
  final String getCurrentCounterDetails =
      "/get-current-counter-closing-details"; //GET
  final String closeCounterUrl = "/close-counter"; //POST
  final String savePettyCashUsage = "/petty-cash-usage"; //POST
  final String dreamPriceUrl = "/dream-prices"; //GET
  final String cashiersUrl = "/cashiers"; //GET
  final String vouchersConfigurationUrl = "/vouchers"; //GET
  final String vouchersUrl = "/get-paginated-vouchers"; //GET
  final String cashBackUrl = "/cashback-list"; //GET
  final String getSaleDetails = "/get-sale-details/"; // GET
  final String pettyCashUsages = "/get-paginated-petty-cash-usages"; //GET
  final String updateLayawaySale = "/complete-layaway-sale/"; // POST
  final String cancelLayawaySale = "/cancel-layaway-sale/"; // POST
  final String denominationsUrl = "/denominations"; //GET
  final String cashMovements = "/get-paginated-cash-movements"; //GET
  final String getPendingLayawaySaleById = "/get-pending-layaway-sale/"; // GET
  final String getMembershipsUrl = "/get-memberships"; //GET
  final String getPaginatedSaleReturns =
      "/get-filtered-and-paginated-sale-returns"; // GET
  final String getEmployeesUrl = "/get-paginated-employees"; //GET
  final String generateMemberBirthdayVoucherUrl =
      "/generate-member-birthday-voucher/"; //POST
  final String getCompanyConfigurationUrl = "/get-configuration"; //GET
  final String getLoyaltyPointVoucherConfigurationUrl = "/get-loyalty-point-voucher-configuration"; //GET
  final String giftCardsUrl = "/get-gift-cards"; //GET
  final String updateTakeBreak = "/counter-update-events"; //POST
  final String updatePaymentDeclaration =
      "/counter-update-declaration-attempt"; // POST
  final String generateMemberLoyaltyPointVoucherUrl =
      "/generate-member-loyalty-point-voucher"; // POST
  final String getLastThirtyDaysClosedCountersUrl =
      "/get-last-thirty-days-closed-counters"; // GET
  final String getCounterPaymentDeclarationAttempts =
      "/get-counter-update-declaration-attempts"; // GET
  final String getCreditNoteDetailsById = "/get-credit-note-details/"; // GET
  final String getLoyaltyCampaignsUrl = "/loyalty-campaigns"; //GET
  final String getCreditNoteList = "/get-paginated-active-credit-notes/"; // GET
  final String getCreditNoteDetails = "/get-credit-note-details/"; // GET
  final String creditNoteRefund = "/credit-notes/"; // POST
  final String saveHoldSaleUrl = "/save-hold-sale-details"; // POST
  final String getHoldSaleTypesUrl = "/get-hold-sale-types"; // GET
  final String cancelHoldSaleUrl = "/cancel-hold-sale"; // POST
  final String releasedHoldSaleUrl = "/released-hold-sale"; // POST
  final String completeHoldSaleUrl = "/complete-hold-sale"; // POST
  final String getCurrentlyOpenedCounterStatus =
      "/get-currently-open-counter-details"; //GET
  final String memberGroupList = "/get-paginate-member-group-list?per_page=100&page=1"; //GET
  final String employeeGroupList = "/get-paginate-employee-group-list?per_page=100&page=1"; //GET
  final String getCounterOpenStatusUrl = "/get-counter-open-status"; //GET
  final String getPriceOverrideTypesUrl = "/get-price-override-types";

  Future<String> getMasterUrl() async {
    var localUserApi = UserLocalApiImpl();
    var config = await localUserApi.getConfiguration();

    var masterUrl = config?.url ?? "https://devpos.jakel.my";
    return '$masterUrl/api/pos';
  }

  Future<Dio> getDioInstance() async {
    String? deviceId = await getUniqueDeviceId();

    var dio = Dio();

    var token = await locator.get<UserLocalApi>().getToken();
    var appInfo = await getAppInformation();

    dio.options.headers['app-version'] = '${appInfo.version}';
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['DeviceId'] = deviceId;
    dio.options.followRedirects = true;
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 10000;
    dio.options.validateStatus = (status) {
      if (status == null) {
        return false;
      }
      return status < 1000;
    };

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    return dio;
  }

  void logError(String url, int? statusCode, String? statusMessage) {
    locator.get<MyLogs>().logNetworkError(
          url,
          "",
          statusMessage,
          statusCode,
        );
  }

  void logErrorWithRequest(
      String url, int? statusCode, String? statusMessage, dynamic? request) {
    locator.get<MyLogs>().logNetworkError(
          url,
          request,
          statusMessage,
          statusCode,
        );
  }
}
