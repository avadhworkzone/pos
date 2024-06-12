// === Card Type  === //
// 01 - UPI
// 04 - VISA
// 05 - MASTER
// 06 - DINERS
// 07 - AMEX
// 08 - DEBIT
// 10 - GENTING CARD
// 11 - JCB
String getPaymentCardFromMbbCode(String? cardType) {
  if (cardType == "01") {
    return "UPI";
  }
  if (cardType == "04") {
    return "VISA";
  }
  if (cardType == "05") {
    return "MASTER";
  }
  if (cardType == "06") {
    return "DINERS";
  }
  if (cardType == "07") {
    return "AMEX";
  }
  if (cardType == "08") {
    return "DEBIT";
  }
  if (cardType == "10") {
    return "GENTING CARD";
  }
  if (cardType == "11") {
    return "JCB";
  }

  return "";
}
