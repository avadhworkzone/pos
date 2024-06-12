class LayawayPaymentLoyaltyPointRequest {
  String _totalPoint;
  String _usePoint;
  String _useAmount;

  LayawayPaymentLoyaltyPointRequest(
      this._totalPoint, this._usePoint, this._useAmount);

  String get useAmount => _useAmount;

  String get usePoint => _usePoint;

  String get totalPoint => _totalPoint;
}
