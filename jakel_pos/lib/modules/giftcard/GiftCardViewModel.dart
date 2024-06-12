import 'dart:convert';

import 'package:jakel_base/database/giftcards/GiftCardsLocalApi.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/restapi/giftcards/model/GiftCardsResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/my_date_utils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:rxdart/rxdart.dart';

class GiftCardViewModel extends BaseViewModel {
  List<GiftCards> mGiftCardsList = [];

  var responseSubject = PublishSubject<GiftCardsResponse>();

  Stream<GiftCardsResponse> get responseStream => responseSubject.stream;

  void closeObservable() {
    responseSubject.close();
  }

  ///GiftCards
  var responseSubjectGiftCardsDetails = PublishSubject<GiftCards>();

  Stream<GiftCards?> get responseStreamGiftCardsDetails =>
      responseSubjectGiftCardsDetails.stream;

  void closeObservableGiftCardsDetails() {
    responseSubjectGiftCardsDetails.close();
  }

  void getGiftCardDetails(String number) async {
    var localApi = locator.get<GiftCardsLocalApi>();

    try {
      GiftCards? giftCards = await localApi.getById(number);
      if (giftCards != null) {
        responseSubjectGiftCardsDetails.sink.add(giftCards);
      } else {
        responseSubjectGiftCardsDetails.sink.addError("No gift card available");
      }
    } catch (e) {
      MyLogUtils.logDebug("getEmployees exception $e");
      responseSubjectGiftCardsDetails.sink.addError(e);
    }
  }

  bool isAlreadyUsed(GiftCards? giftCards) {
    if (giftCards?.type?.key == "SINGLE_USE_ONLY" &&
        giftCards?.status?.key == "USED") {
      return true;
    }

    if ((giftCards?.availableAmount ?? 0) <= 0) {
      return true;
    }

    return false;
  }

  bool isExpired(GiftCards? giftCards) {
    if (giftCards != null) {
      bool isValid = isGiftCardsDateExpired(giftCards.expiryDate);
      return !isValid;
    }
    return false;
  }

  /// get GiftCards Offline call from GiftCardListWidget
  Future<void> getGiftCardsOffline({String sSearch = ""}) async {
    List<GiftCards> mGiftCardsSubList = [];
    try {
      if (mGiftCardsList.isEmpty) {
        mGiftCardsList = await getAllGiftCardsOffline();
        mGiftCardsSubList.addAll(mGiftCardsList);
      }
      if (sSearch.trim().isEmpty) {
        mGiftCardsSubList.addAll(mGiftCardsList);
      } else {
        mGiftCardsSubList
            .addAll(await onSearchGiftCards(sSearch.toLowerCase().trim()));
      }

      GiftCardsResponse mGiftCardsResponse = GiftCardsResponse(
        giftCards: mGiftCardsSubList,
      );
      responseSubject.sink.add(mGiftCardsResponse);
    } catch (e) {
      MyLogUtils.logDebug("getGiftCards exception $e");
      responseSubject.sink.addError(e);
    }
  }

  ///get All GiftCards list LocalApi
  Future<List<GiftCards>> getAllGiftCardsOffline() async {
    var api = locator.get<GiftCardsLocalApi>();
    return await api.getAll();
  }

  /// Search by name
  Future<List<GiftCards>> onSearchGiftCards(String text) async {
    List<GiftCards> mGiftCardsSubList = [];
    for (var mGiftCards in mGiftCardsList) {
      if (mGiftCards.id.toString().toLowerCase().contains(text.toLowerCase())) {
        mGiftCardsSubList.add(mGiftCards);
      } else if (mGiftCards.type!.name!
          .toLowerCase()
          .contains(text.toLowerCase())) {
        mGiftCardsSubList.add(mGiftCards);
      } else if (mGiftCards.number
          .toString()
          .toLowerCase()
          .contains(text.toLowerCase())) {
        mGiftCardsSubList.add(mGiftCards);
      }
    }
    return mGiftCardsSubList;
  }
}
