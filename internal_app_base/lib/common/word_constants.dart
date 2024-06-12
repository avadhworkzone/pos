import 'package:flutter/material.dart';

import 'localization/locale_constant.dart';
import 'localization/localizations_delegate.dart';

abstract class WordConstants {
  static Future<WordConstants> of(BuildContext context) async {
    return AppLocalizationsDelegate.load(Locale(await getLocale(), ''));
  }

  String get appName {
    return "Member app";
  }

  String get wLogoutText {
    return "Logout";
  }

  String get wSomethingWentWrong {
    return 'Something went wrong, try again later!';
  }

  String get wPrivacyPolicy {
    return "Privacy Policy";
  }

  ///walk_through_screen
  String get wWalkThroughText {
    return "My role in the\norganization is:";
  }

  String get wPromoterText {
    return "Promoter";
  }

  String get wStoreManagerText {
    return "Store Manager";
  }

  String get wWarehouseManagerText {
    return "Warehouse Manager";
  }

  ///login
  String get wUsernameText {
    return "Username";
  }

  String get wPleaseEnterUsernameText {
    return "Please enter username";
  }

  String get wPasswordText {
    return "Password";
  }

  String get wPleaseEnterPasswordText {
    return "Please enter password";
  }

  String get wLoginText {
    return "Login";
  }

  String get wForgotPasswordText {
    return "Forgot Password?";
  }

  ///add member
  String get wFirstNameText {
    return "First Name";
  }

  String get wPleaseEnterFirstNameText {
    return "Please enter First Name";
  }

  String get wAddMemberTitleText {
    return "Add Member";
  }

  String get wEnterFullNameText {
    return "Full Name";
  }

  String get wPleaseEnterFullNameText {
    return "Please Enter Full Name";
  }

  String get wMobileNumberText {
    return "Mobile Number";
  }

  String get wPleaseMobileNumberText {
    return "Please Enter Your Mobile Number";
  }

  String get wEnterEmailText {
    return "Enter Email";
  }

  String get wEnterDateOfBirthText {
    return "Date Of Birth";
  }

  String get wHintDateOfBirthText {
    return "May 02, 2023";
  }

  ///Warehouse Manager
  String get wProductListText {
    return "Product List";
  }

  String get wProductDetailsText {
    return "Product Details";
  }

  String get wProfileSettingsText {
    return "Profile Settings";
  }

  String get wPromotersText {
    return "Promoters";
  }

  String get wPromotersNameText {
    return "Promoter Name: ";
  }

  String get wCountsText {
    return "Count: ";
  }

  String get wDetailsText {
    return "Details ";
  }

  String get wNameText {
    return "Name: ";
  }

  String get wArticleNumberText {
    return "Article Number: ";
  }

  String get wUPCText {
    return "UPC: ";
  }

  String get wPriceText {
    return "Price: ";
  }

  String get wColorText {
    return "Color: ";
  }

  String get wCategoriesText {
    return "Categories: ";
  }

  String get wBrandText {
    return "Brand: ";
  }

  String get wSizeText {
    return "Size: ";
  }

  String get wOutOfStockText {
    return "Out Of Stock";
  }

  String get wStockText {
    return "Stock";
  }

  String get wSearchText {
    return "Search";
  }

  String get wStockDetailsText {
    return "Stock Details";
  }

  String get wNoStockText {
    return "No Stock";
  }

  String get wSKUManagedText {
    return "SKU’s Managed";
  }

  String get wPleaseEnterSearchText {
    return "Please Enter Search Keyword";
  }

  // String  get wCheckInAllLocationText { return   "Check in all Location";}
  String get wStockInOthers {
    return "Stock in others";
  }

  ///Store Manager
  String get wSalesText {
    return "Sales";
  }

  String get wDateText {
    return "Date: ";
  }

  String get wSaleText {
    return "Sale";
  }

  String get wReturnText {
    return "Return";
  }

  String get wReceiptIdText {
    return "Receipt Id: ";
  }

  String get wSalesAmountText {
    return "Sales Amount: ";
  }

  String get wAmountText {
    return "Amount";
  }

  String get wTodayText {
    return "Today";
  }

  String get wSalesCountText {
    return "Sales Count";
  }

  String get wTotalReceipts {
    return "Total Receipts";
  }

  String get wNetSales {
    return "Net Sales";
  }

  ///Promoter
  String get wSalesReturnsText {
    return "Sales & Returns";
  }

  String get wOverviewText {
    return "Overview";
  }

  String get wThisMonthText {
    return "This Month";
  }

  String get wLastMonthText {
    return "Last Month";
  }

  String get wAddMemberText {
    return "Add-Member";
  }

  String get wCommissionText {
    return "Commission";
  }

  String get wHomeText {
    return "Home";
  }

  String get wMenuText {
    return "Menu";
  }

  String get wItemsSoldText {
    return "Items Sold: ";
  }

  String get wItemsSold_Text {
    return "Items Sold";
  }

  String get wItemsReturnedText {
    return "Items Returned: ";
  }

  String get wOtherPromotersText {
    return "Other Promoters:";
  }

  String get wItemDetailsText {
    return "Item Details";
  }

  String get wQuantityText {
    return "Quantity: ";
  }

  String get wProductNameText {
    return "Product Name: ";
  }

  String get wProductUPCText {
    return "Product UPC: ";
  }

  String get wProductSizeText {
    return "Product Size: ";
  }

  String get wProductColorText {
    return "Product Color: ";
  }

  String get wProductDepartmenText {
    return "Product Department: ";
  }

  String get wProductBrandText {
    return "Product Brand: ";
  }

  ///pull_to_refresh
  String get wPullUpLoad {
    return "Pull up load";
  }

  String get wLoadFailedClickRetry {
    return "Load Failed!Click retry!";
  }

  String get wNoMoreData {
    return "No more Data";
  }

  ///profile lable
  String get wEmailIdText {
    return "Email Id";
  }

  String get wPhoneNumberText {
    return "Phone Number";
  }

  String get wStaffIdText {
    return "Staff Id";
  }

  String get wAddressLine1Text {
    return "Address Line 1";
  }

  String get wAddressLine2Text {
    return "Address Line 2";
  }

  String get wCityText {
    return "City";
  }

  String get wAreaCodeText {
    return "Area Code";
  }

  String get wDateofJoiningText {
    return "Date of Joining";
  }

  String get wPrimaryContactNameText {
    return "Primary Contact Name";
  }

  String get wPrimaryContactNumberText {
    return "Primary Contact Number";
  }

  String get wICNumberText {
    return "IC Number";
  }

  ///profile hint
  String get wPleaseEnterEmailIdText {
    return "Please enter your Email Id";
  }

  String get wPleaseEnterPhoneNumberText {
    return "Please enter your Phone Number";
  }

  String get wPleaseEnterStaffIdText {
    return "Please enter your Staff Id";
  }

  String get wPleaseEnterAddressLine1Text {
    return "Please enter your Address";
  }

  String get wPleaseEnterAddressLine2Text {
    return "Please enter your Address";
  }

  String get wPleaseEnterCityText {
    return "City";
  }

  String get wPleaseEnterAreaCodeText {
    return "Area Code";
  }

  String get wPleaseEnterDateofJoiningText {
    return "Please enter your Date of Joining";
  }

  String get wPleaseEnterPrimaryContactNameText {
    return "Please enter your Primary Contact Name";
  }

  String get wPleaseEnterPrimaryContactNumberText {
    return "Please enter your Primary Contact Number";
  }

  String get wPleaseEnterICNumberText {
    return "Please enter your IC Number";
  }

  ///button text
  String get wSaveChangesText {
    return "Save Changes";
  }

  String get wSubmitText {
    return "Submit";
  }

  ///dilog
  String get wDilogMessage {
    return "You can search by Name, Article\nNumber, UPC, Custom SKU.\nYou may also use Barcode scanner.";
  }
}
