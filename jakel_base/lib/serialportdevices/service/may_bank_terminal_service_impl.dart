import 'dart:typed_data';

import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:jakel_base/serialportdevices/model/MayBankPaymentDetails.dart';
import 'package:jakel_base/serialportdevices/serial_port_helper.dart';
import 'package:jakel_base/serialportdevices/service/process_runner_service.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';

import '../../database/serialport/SerialPortDevicesApi.dart';
import '../../locator.dart';
import 'may_bank_terminal_service.dart';

/// Refer https://www.eso.org/~ndelmott/ascii.html for characters
class MayBankTerminalServiceImpl with MayBankTerminalService {
  final tag = "MayBankTerminalService";

  final stxAsInt = 2;
  final etxAsInt = 3;
  final enqAsInt = 5;
  final ackAsIn = 6;

  final stx = '\x02';
  final etx = '\x03';
  final enq = '\x05';
  final ack = '\x06';

  // statusCode & its description
  // Code	Description
  // 00	Approved or completed successfully
  // 01	Refer to card issuer
  // 02	Refer to card issuer's special conditions
  // 03	Invalid merchant
  // 04	Pick-up
  // 05	Do not honor
  // 06	Error
  // 07	Pick-up card, special condition
  // 08	Honour with identification
  // 09	Request in progress
  // 10	Approved for partial amount
  // 11	Approved (VIP)
  // 12	Invalid transaction
  // 13	Invalid amount
  // 14	Invalid card number (no such number)
  // 15	No such issuer
  // 16	Approved, update track 3
  // 17	Customer cancellation
  // 18	Customer dispute
  // 19	Re-enter transaction
  // 20	Invalid response
  // 21	No action taken
  // 22	Suspected malfunction
  // 23	Unacceptable transaction fee
  // 24	File update not supported by receiver
  // 25	Unable to locate record on file
  // 26	Duplicate file update record, old record replaced
  // 27	File update field edit error
  // 28	File update file locked out
  // 29	File update not successful, contact acquirer
  // 30	Format error
  // 31	Bank not supported by switch
  // 32	Completed partially
  // 33	Expired card
  // 34	Suspected fraud
  // 35	Card acceptor contact acquirer
  // 36	Restricted card
  // 37	Card acceptor call acquirer security
  // 38	Allowable PIN tries exceeded
  // 39	No credit account
  // 40	Requested function not supported
  // 41	Lost card
  // 42	No universal account
  // 43	Stolen card, pick-up
  // 44	No investment account
  // 45-50	Reserved for ISO use
  // 51	Not sufficient funds
  // 52	No checking account
  // 53	No savings account
  // 54	Expired card
  // 55	Incorrect personal identification number
  // 56	No card record
  // 57	Transaction not permitted to cardholder
  // 58	Transaction not permitted to terminal
  // 59	Suspected fraud
  // 60	Card acceptor contact acquirer
  // 61	Exceeds withdrawal amount limit
  // 62	Restricted card
  // 63	Security violation
  // 64	Original amount incorrect
  // 65	Exceeds withdrawal frequency limit
  // 66	Card acceptor call acquirer's security department
  // 67	Hard capture (requires that card be picked up at ATM)
  // 68	Response received too late
  // 69-74	Reserved for ISO use
  // 75	Allowable number of PIN tries exceeded
  // 76-89	Reserved for private use
  // 76-89	Reserved for private use
  // 76-89	Reserved for private use
  // 76-89	Reserved for private use
  // 90	Cutoff is in process
  // (switch ending a day's business and starting the next. Transaction can be sent again in a few minutes)
  //
  // 91	Issuer or switch is inoperative
  // 92	Financial institution or intermediate network facility cannot be found for routing
  // 93	Transaction cannot be completed. Violation of law
  // 94	Duplicate transmission
  // 95	Reconcile error
  // 96	System malfunction
  // 97-99	Reserved for national use
  // Zero A-9Z	Reserved for ISO use
  // A Zero-MZ	Reserved for national use
  // N Zero-ZZ	Reserved for private use

  // === Card Type  === //
  // 01 - UPI
  // 04 - VISA
  // 05 - MASTER
  // 06 - DINERS
  // 07 - AMEX
  // 08 - DEBIT
  // 10 - GENTING CARD
  // 11 - JCB

  @override
  Future<bool> initDevice() async {
    var localApi = locator.get<SerialPortDevicesApi>();
    var device = await localApi.getMyPaymentTerminalDevice();

    if (device != null) {
      var processRunner = locator.get<ProcessRunnerService>();
      //Set the configuration Using process runner
      await processRunner
          .execute("mode ${device.address}: BAUD=9600 PARITY=N data=8 stop=1");
    }
    return true;
  }

  @override
  Future<bool> echoTerminalTest() async {
    //Step 1: Fetch May Bank terminal device from local storage
    var localApi = locator.get<SerialPortDevicesApi>();
    var device = await localApi.getMyPaymentTerminalDevice();
    if (device != null) {
      await initDevice();
      final serialPortDevice = SerialPort(device.address);
      MyLogUtils.logDebug(
          "$tag, echoTerminalTest serialPortDevice : $serialPortDevice ");

      //serialPortDevice.config = getConfiguration();

      //Open the device in read & write mode;
      try {
        if (!serialPortDevice.isOpen) serialPortDevice.openReadWrite();

        //Enquire & Acknowledge
        bool result = await _enqAndAck(serialPortDevice);

        MyLogUtils.logDebug("$tag,echoTerminalTest Enquiry Result : $result ");

        if (!result) {
          return false;
        }

        String inputCommand = "";

        MyLogUtils.logDebug(
            "$tag,echoTerminalTest inputCommand Add Stx : $inputCommand ");

        // Add trigger command
        inputCommand = '${inputCommand}C902';

        MyLogUtils.logDebug(
            "$tag,echoTerminalTest inputCommand trigger cmd : $inputCommand ");

        // Add ETX
        inputCommand = '$inputCommand$etx';

        MyLogUtils.logDebug(
            "$tag,echoTerminalTest inputCommand b4 lrc : $inputCommand ");

        // ADD LRC
        inputCommand = '$inputCommand${getLrc(inputCommand)}';

        // Add STX in front
        inputCommand = '$stx$inputCommand';

        MyLogUtils.logDebug(
            "$tag,echoTerminalTest inputCommand after lrc and stx : $inputCommand ");

        String? echoTestResult =
            await _readAndAcknowledge(serialPortDevice, inputCommand, 9);

        echoTestResult = echoTestResult.trim();

        MyLogUtils.logDebug(
            '$tag echoTerminalTest echoTestResult : $echoTestResult');

        if (echoTestResult.startsWith("<STX>R90200<ETX>")) {
          return true;
        }
      } catch (e) {
        MyLogUtils.logDebug("$tag, echoTerminalTest exception : $e ");
        closeTheDevice(serialPortDevice);
      }
    }

    return false;
  }

  @override
  Future<bool> closeThePort() async {
    var localApi = locator.get<SerialPortDevicesApi>();
    var device = await localApi.getMyPaymentTerminalDevice();
    if (device != null) {
      final serialPortDevice = SerialPort(device.address);
      closeTheDevice(serialPortDevice);
    }
    return true;
  }

  @override
  void requestPaymentAsync(double amount, bool triggerMayBankCard,
      bool triggerMayBankQrCode, Function onProcessCompleted) async {
    //var processRunner = locator.get<ProcessRunnerService>();

    MyLogUtils.logDebug(
        type: LogType.MBB,
        "requestPaymentAsync amount : $amount , "
        "_getAmountAsTwelveCharacters : ${_getAmountAsTwelveCharacters(amount)} , "
        "triggerMayBankCard : $triggerMayBankCard , "
        "triggerMayBankQrCode : $triggerMayBankQrCode ");

    //Step 1: Fetch May Bank terminal device from local storage
    var localApi = locator.get<SerialPortDevicesApi>();
    var device = await localApi.getMyPaymentTerminalDevice();
    if (device == null) {
      MyLogUtils.logDebug(
          type: LogType.MBB,
          "requestPaymentAsync=>Terminal is not configured ");
      onProcessCompleted(MayBankPaymentDetails(
          errorMessage:
              "Terminal is not configured.\nPlease contact IT team.\nIf payment is success, you can update payment manually in this pop up to complete the sale"));
    }

    await initDevice();

    final serialPortDevice = SerialPort(device!.address);

    //closeTheDevice(serialPortDevice);

    MyLogUtils.logDebug(
        type: LogType.MBB,
        "requestPaymentAsync=> $tag,serialPortDevice name : ${serialPortDevice.name},"
        "serialPortDevice manufacturer : ${serialPortDevice.manufacturer}, "
        "serialPortDevice serialNumber : ${serialPortDevice.serialNumber}, "
        "serialPortDevice address : ${serialPortDevice.address}, "
        "serialPortDevice macAddress : ${serialPortDevice.macAddress} ");

    //Step 2: Open the device in read & write mode;
    try {
      MyLogUtils.logDebug(
          type: LogType.MBB,
          "$tag,requestPaymentAsync serialPortDevice isOpen : ${serialPortDevice.isOpen} ");

      if (!serialPortDevice.isOpen) {
        serialPortDevice.openReadWrite();
      }

      //Step 0. Enquire & Acknowledge
      MyLogUtils.logDebug(
          type: LogType.MBB_PAYSYS,
          "Send >> ${convertUInt8ListToString(convertStringToUInt8List(enq))}");
      int writeResult = serialPortDevice.write(convertStringToUInt8List(enq));

      MyLogUtils.logDebug(
          type: LogType.MBB, "writeResult for enq & Ack : $writeResult");

      int step = 1;

      bool step1Result = false;

      List<int> mbbResponseIntLists = List.empty(growable: true);
      MayBankPaymentDetails? paymentDetails;

      final reader = SerialPortReader(serialPortDevice, timeout: 1000);
      reader.stream.listen((data) {
        String readResultAsString = convertUInt8ListToString(data);

        MyLogUtils.logDebug(
            type: LogType.MBB,
            "On Data Received Current Step : $step & raw data $data &  readResultAsString: $readResultAsString");

        //Step 1.  Send ENQ & get ACK
        if (step == 1) {
          if (readResultAsString.isNotEmpty) {
            MyLogUtils.logDebug(
                type: LogType.MBB_PAYSYS,
                "$step Received << $readResultAsString");
            if (readResultAsString == "ENQ") {
              //In some cases , it gives response as ENQ which is previus request.
              return;
            }
            if (readResultAsString == "ACK") {
              step = 2;
              step1Result = true;
            } else {
              step1Result = false;
              reader.close();
              onProcessCompleted(MayBankPaymentDetails(
                  errorMessage:
                      "Failed to acknowledge from payment terminal.\nPlease contact IT team.\nIf payment is success, you can update payment manually in this pop up to complete the sale"));
            }
          }
        }

        //Step 2.  Send Payment request
        if (step == 2 && step1Result) {
          String inputCommand = getRequestPaymentInput(
              triggerMayBankCard, triggerMayBankQrCode, amount);

          MyLogUtils.logDebug(
              type: LogType.MBB_PAYSYS,
              "$step Send payment request >> ${convertUInt8ListToString(convertStringToUInt8List(inputCommand))}");

          int writeResultBytesSize =
              serialPortDevice.write(convertStringToUInt8List(inputCommand));
          MyLogUtils.logDebug(
              type: LogType.MBB,
              "Step 2.  Send Payment request Write Result total Bytes Wrote : $writeResultBytesSize");
          step = 3;
        }

        // Step 3. Wait for ack callback from MBB after payment request is sent
        if (readResultAsString == "ACK") {
          MyLogUtils.logDebug(
              type: LogType.MBB_PAYSYS,
              "$step Received << $readResultAsString");
          step = 4;
          MyLogUtils.logDebug(
              type: LogType.MBB,
              "$tag,_requestPaymentInMbb received ACK for payment request");
        }

        //Step 4: After ACK, MBB will Send ENQ to device. We need to ACK the Enquiry.
        if (step == 4 && readResultAsString == "ENQ") {
          MyLogUtils.logDebug(
              type: LogType.MBB_PAYSYS,
              "$step Received << $readResultAsString");

          MyLogUtils.logDebug(
              type: LogType.MBB_PAYSYS,
              "$step Send >> ${convertUInt8ListToString(convertStringToUInt8List(ack))}");

          int writeResultBytesSize =
              serialPortDevice.write(convertStringToUInt8List(ack));
          MyLogUtils.logDebug(
              type: LogType.MBB,
              "$tag,Step 4 Write ACK to MBB  result Size : $writeResultBytesSize");
          step = 5;
        }

        //Step 5.  First check it STX is received. If so add to data list.
        // In some cases, response comes with ACK & ENQ
        if (step >= 3 && step < 6) {
          // ============== //

          // First check it STX is received. If so add to data list.
          if (mbbResponseIntLists.isEmpty && data.contains(stxAsInt)) {
            mbbResponseIntLists.addAll(data);
          }

          // THis condition is to make sure , STX is received & added to data lists.
          if (data.isNotEmpty &&
              mbbResponseIntLists.isNotEmpty &&
              mbbResponseIntLists.contains(stxAsInt)) {
            mbbResponseIntLists.addAll(data);

            if (mbbResponseIntLists.contains(etxAsInt)) {
              reader.close();

              paymentDetails = getMayBankPaymentDataFromMbbResponse(
                  Uint8List.fromList(mbbResponseIntLists)); // TODO

              MyLogUtils.logDebug(
                  type: LogType.MBB_PAYSYS,
                  "$step Received << ${convertUInt8ListToString(Uint8List.fromList(mbbResponseIntLists))}");
              MyLogUtils.logDebug(
                  type: LogType.MBB,
                  "$tag,Final payment Details response  : $paymentDetails");
              step = 6;
            }
          }
        }
        MyLogUtils.logDebug(
            type: LogType.MBB,
            "$tag, mbbResponseIntLists : $mbbResponseIntLists");

        // Step 6. Write ACK to mbb after received Data from MBB
        if (step == 6) {
          String mbbResponseIntListsResultAsString =
              convertUInt8ListToString(Uint8List.fromList(mbbResponseIntLists));

          MyLogUtils.logDebug(
              type: LogType.MBB,
              "$tag, mbbResponseIntListsResultAsString : $mbbResponseIntListsResultAsString");

          MyLogUtils.logDebug(
              type: LogType.MBB_PAYSYS,
              "$step Send >> ${convertUInt8ListToString(convertStringToUInt8List(ack))}");

          int writeResult =
              serialPortDevice.write(convertStringToUInt8List(ack));
          MyLogUtils.logDebug(
              type: LogType.MBB,
              "Step 6. Write ACK to mbb after received Data from MBB : $writeResult");
          step = 7;
        }

        // Step 7.Wait for EOT from MBB
        if (step == 7) {
          // Its Success Case
          MyLogUtils.logDebug(
              type: LogType.MBB_PAYSYS, "Received << $readResultAsString");
          if (readResultAsString == "EOT") {
            reader.close();
            onProcessCompleted(paymentDetails);
            closeTheDevice(serialPortDevice);
          }

          // Its failure case
          if (paymentDetails == null || paymentDetails?.statusCode != "00") {
            reader.close();
            onProcessCompleted(MayBankPaymentDetails(
                errorMessage:
                    "Payment failed!!!.\nPlease cross check for payment with customer.\nIf success, update the payment manually."));
            closeTheDevice(serialPortDevice);
            return;
          }

          // In some cases , EOT is not sent my MBB. So we can directly close the terminal if status is success
          if (paymentDetails != null && paymentDetails?.statusCode == "00") {
            reader.close();
            onProcessCompleted(paymentDetails);
            closeTheDevice(serialPortDevice);
          }
        }
      });
    } catch (e) {
      MyLogUtils.logDebug(type: LogType.MBB, '$tag requestPayment error : $e');
      closeTheDevice(serialPortDevice);
      onProcessCompleted(MayBankPaymentDetails(
          errorMessage:
              "No Response from payment terminal.\nPlease contact IT team to check payment terminal.\nIf payment is success, you can update payment manually in this pop up to complete the sale"));
    }
  }

  SerialPortConfig getConfiguration() {
    final configuration = SerialPortConfig();
    configuration.baudRate = 9600;
    configuration.bits = 8;
    configuration.parity = 0;
    configuration.stopBits = 1;
    return configuration;
  }

  String getRequestPaymentInput(
      bool triggerMayBankCard, bool triggerMayBankQrCode, double amount) {
    // Create command to trigger payment
    String inputCommand = "";

    // Add trigger command
    inputCommand = '${inputCommand}C200';

    // Add both card type & QR type
    if (triggerMayBankCard && triggerMayBankQrCode) {
      inputCommand = '${inputCommand}00';
    }
    // Add only QR payment type
    if (triggerMayBankCard && !triggerMayBankQrCode) {
      inputCommand = '${inputCommand}CP';
    }

    // Add only Card Payment Type
    if (!triggerMayBankCard && triggerMayBankQrCode) {
      inputCommand = '${inputCommand}QR';
    }

    // Add 12 character of amount;
    inputCommand = '$inputCommand${_getAmountAsTwelveCharacters(amount)}';

    // Add 24 character additional data;
    inputCommand = '$inputCommand${_getZeros(24)}';

    // Add STX
    inputCommand = '$inputCommand$etx';

    // ADD LRC
    inputCommand = '$inputCommand${getLrc(inputCommand)}';

    // Add STX IN FRONT
    inputCommand = '$stx$inputCommand';
    return inputCommand;
  }

  void closeTheDevice(SerialPort serialPortDevice) {
    MyLogUtils.logDebug(
        type: LogType.MBB,
        "$tag closeTheDevice is Open : ${serialPortDevice.isOpen} ");
    if (serialPortDevice.isOpen) {
      serialPortDevice.close();
    }
  }

  // Enquire & acknowledge the same
  Future<String> _readAndAcknowledge(
      SerialPort portDevice, String data, int expectedLength) async {
    MyLogUtils.logDebug(
        type: LogType.MBB, "$tag, _readAndAcknowledge data : $data ");

    int writeResult = portDevice.write(convertStringToUInt8List(data));

    MyLogUtils.logDebug(
        type: LogType.MBB,
        "$tag,_readAndAcknowledge writeResult : $writeResult ");

    final reader = SerialPortReader(portDevice);

    await Future.delayed(const Duration(seconds: 2));

    MayBankPaymentDetails? paymentDetails =
        await getMayBankPaymentDataFromStreams(reader.stream);

    Uint8List lists = await getFromStream(reader.stream, expectedLength);

    MyLogUtils.logDebug(
        type: LogType.MBB,
        "$tag,_readAndAcknowledge paymentDetails : ${paymentDetails?.toJson()}");

    String readResultAsString = convertUInt8ListToString(lists);

    return readResultAsString;
  }

  MayBankPaymentDetails? getMayBankPaymentDataFromMbbResponse(Uint8List list) {
    List<String> responseData = List.empty(growable: true);
    List<int> intList = List.empty(growable: true);
    String? start, response, card, expiry, statusCode, approvalCode, rrn, trace;
    String? batchNo,
        hostNo,
        terminalId,
        merchantId,
        aid,
        tc,
        cardHolderName,
        cardType;

    bool startAdding = false;
    if (list.isNotEmpty) {
      for (var value in list) {
        if (start != null && startAdding == true) {
          // After start 4 bytes for response is updated here.
          intList.add(value);

          if (response == null) {
            if (intList.length == 4) {
              response = convertUInt8ListToString(
                  Uint8List.fromList(intList)); // Add response
              MyLogUtils.logDebug(
                  type: LogType.MBB,
                  "$tag, getMayBankPaymentData response String : $response for intList : $intList");
              intList.clear();
              responseData.add(response);
            }
          }

          // After response 19 bytes card is updated here.
          if (response != null && card == null) {
            if (intList.length == 19) {
              card = convertUInt8ListToString(
                  Uint8List.fromList(intList)); // Add card number
              MyLogUtils.logDebug(
                  type: LogType.MBB,
                  "$tag, getMayBankPaymentData card String : $card for intList : $intList");
              intList.clear();
              responseData.add(card);
            }
          }

          // After card 4 bytes is used for expiry
          if (card != null && expiry == null) {
            if (intList.length == 4) {
              expiry = convertUInt8ListToString(
                  Uint8List.fromList(intList)); // Add card number
              MyLogUtils.logDebug(
                  type: LogType.MBB, "$tag, expiry String : $expiry");
              intList.clear();
              responseData.add(expiry);
            }
          }
          // After card expiry 2 bytes is used for status code
          if (expiry != null && statusCode == null) {
            if (intList.length == 2) {
              statusCode = convertUInt8ListToString(
                  Uint8List.fromList(intList)); // Add card number
              MyLogUtils.logDebug(
                  type: LogType.MBB,
                  "$tag,getMayBankPaymentData status String : $statusCode");
              intList.clear();
              responseData.add(statusCode);
            }
          }

          // After status 6 bytes is used for approvalCode
          if (statusCode != null && approvalCode == null) {
            if (intList.length == 6) {
              approvalCode = convertUInt8ListToString(
                  Uint8List.fromList(intList)); // Add card number
              MyLogUtils.logDebug(
                  type: LogType.MBB,
                  "$tag,getMayBankPaymentData approvalCode String : $approvalCode");
              intList.clear();
              responseData.add(approvalCode);
            }
          }

          // After approvalCode 12 bytes is used for rrn
          if (approvalCode != null && rrn == null) {
            if (intList.length == 12) {
              rrn = convertUInt8ListToString(
                  Uint8List.fromList(intList)); // Add card number
              MyLogUtils.logDebug(
                  type: LogType.MBB,
                  "$tag,getMayBankPaymentData rrn String : $rrn");
              intList.clear();
              responseData.add(rrn);
            }
          }

          // After rrn 6 bytes i used for trace
          if (rrn != null && trace == null) {
            if (intList.length == 6) {
              trace = convertUInt8ListToString(
                  Uint8List.fromList(intList)); // Add card number
              MyLogUtils.logDebug(
                  type: LogType.MBB,
                  "$tag,getMayBankPaymentData trace String : $trace");
              intList.clear();
              responseData.add(trace);
            }
          }

          // After trace 6 bytes is used for batchNo
          if (rrn != null && batchNo == null) {
            if (intList.length == 6) {
              batchNo = convertUInt8ListToString(
                  Uint8List.fromList(intList)); // Add card number
              MyLogUtils.logDebug(
                  type: LogType.MBB,
                  "$tag,getMayBankPaymentData batchNo String : $batchNo");
              intList.clear();
              responseData.add(batchNo);
            }
          }

          // After batch no, 2 bytes us used for host
          if (batchNo != null && hostNo == null) {
            if (intList.length == 2) {
              hostNo = convertUInt8ListToString(
                  Uint8List.fromList(intList)); // Add card number
              MyLogUtils.logDebug(
                  type: LogType.MBB,
                  "$tag,getMayBankPaymentData hostNo String : $hostNo");
              intList.clear();
              responseData.add(hostNo);
            }
          }

          // After host , 8 bytes of terminal Id
          if (hostNo != null && terminalId == null) {
            if (intList.length == 8) {
              terminalId = convertUInt8ListToString(
                  Uint8List.fromList(intList)); // Add card number
              MyLogUtils.logDebug(
                  type: LogType.MBB,
                  "$tag,getMayBankPaymentData terminalId String : $terminalId");
              intList.clear();
              responseData.add(terminalId);
            }
          }

          // After terminal id, 15 bytes of merchant id
          if (terminalId != null && merchantId == null) {
            if (intList.length == 15) {
              merchantId = convertUInt8ListToString(
                  Uint8List.fromList(intList)); // Add card number
              MyLogUtils.logDebug(
                  type: LogType.MBB,
                  "$tag,getMayBankPaymentData merchantId String : $merchantId");
              intList.clear();
              responseData.add(merchantId);
            }
          }

          // After merchant id, 14 bytes of aid
          if (merchantId != null && aid == null) {
            if (intList.length == 14) {
              aid = convertUInt8ListToString(
                  Uint8List.fromList(intList)); // Add card number
              MyLogUtils.logDebug(
                  type: LogType.MBB,
                  "$tag,getMayBankPaymentData aid String : $aid");
              intList.clear();
              responseData.add(aid);
            }
          }

          // After aid, 16 bytes of tc
          if (aid != null && tc == null) {
            if (intList.length == 16) {
              tc = convertUInt8ListToString(
                  Uint8List.fromList(intList)); // Add card number
              MyLogUtils.logDebug(
                  type: LogType.MBB,
                  "$tag,getMayBankPaymentData tc String : $tc");
              intList.clear();
              responseData.add(tc);
            }
          }

          // After tc, 26 bytes of card holder nmae
          if (tc != null && cardHolderName == null) {
            if (intList.length == 26) {
              cardHolderName = convertUInt8ListToString(
                  Uint8List.fromList(intList)); // Add card number
              MyLogUtils.logDebug(
                  type: LogType.MBB,
                  "$tag,getMayBankPaymentData cardHolderName String : $cardHolderName");
              intList.clear();
              responseData.add(cardHolderName);
              cardHolderName ??= "";
            }
          }

          // After car holder name, 2 bytes of cart type
          if (cardHolderName != null && cardType == null) {
            if (intList.length == 2) {
              cardType = convertUInt8ListToString(
                  Uint8List.fromList(intList)); // Add card number
              MyLogUtils.logDebug(
                  type: LogType.MBB,
                  "$tag,getMayBankPaymentData cardType String : $cardType");
              intList.clear();
              responseData.add(cardType);
            }
          }
        }

        // Card type is last needed parameter.
        if (cardType != null) {
          MyLogUtils.logDebug(
              type: LogType.MBB,
              "$tag,getMayBankPaymentData Break the loop in getFromStream responseData :$responseData");

          if (response == "R200" && statusCode == "00") {
            MayBankPaymentDetails details = MayBankPaymentDetails();
            details.cardNumber = card;
            details.traceNo = trace;
            details.referenceNumber = rrn;
            details.expiry = expiry;
            details.approvalCode = approvalCode;
            details.batchNumber = batchNo;
            details.statusCode = statusCode;
            details.hostNo = hostNo;
            details.cardNumberName = cardHolderName;
            details.cardType = cardType;
            return details;
          } else {
            return MayBankPaymentDetails(
                errorMessage:
                    "Payment failed!!!.\nPlease cross check for payment with customer.\nIf success, update the payment in this pop up manually.");
          }
        }

        if (value == startOfText) {
          startAdding = true;
          start = convertUInt8ListToString(
              Uint8List.fromList([value])); // Add start
          MyLogUtils.logDebug(
              type: LogType.MBB,
              "$tag, getMayBankPaymentData Start String : $start");
          response = null;
          card = null;
          expiry = null;
          statusCode = null;
          approvalCode = null;
          rrn = null;
          trace = null;
          batchNo = null;
          hostNo = null;
          responseData.clear();
          intList.clear();
        }
      }
    }
    return null;
  }

  Future<Uint8List> getFromStream(
      Stream<Uint8List> streams, int expectedLength) async {
    List<Uint8List> allLists = List.empty(growable: true);

    List<int> intList = List.empty(growable: true);
    bool startAdding = false;
    bool endOfListReached = false;
    bool stopAdding = false;

    await for (Uint8List? list in streams) {
      MyLogUtils.logDebug(
          type: LogType.MBB,
          "$tag, getFromStream list : $list and its length "
          ":${list?.length} & updated list size : ${intList.length} & $intList"
          " : String value: ${convertUInt8ListToString(Uint8List.fromList(intList))}");

      if (list != null && list.isNotEmpty) {
        for (var value in list) {
          if (value == startOfText) {
            startAdding = true;
          }

          if (startAdding && value == endOfText) {
            endOfListReached = true;
          }

          // After end of list LRC of 1 byte is sent.
          if (startAdding && endOfListReached) {
            intList.add(value);
            stopAdding = true;
          }

          if (startAdding & !stopAdding) {
            if (value == startOfText) {
              if (!intList.contains(startOfText)) {
                intList.add(value);
              }
            } else if (value == endOfText) {
              if (!intList.contains(endOfText)) {
                intList.add(value);
              }
            } else {
              intList.add(value);
            }
          }

          if (stopAdding) {
            allLists.add(Uint8List.fromList(intList));
            intList.clear();
          }
        }

        if (intList.length >= expectedLength && !stopAdding) {
          MyLogUtils.logDebug(
              type: LogType.MBB,
              "$tag, Break the loop in getFromStream with size :${intList.length}");
          if (allLists.isNotEmpty) {
            return allLists.first;
          }
        }
      }
    }
    MyLogUtils.logDebug(
        type: LogType.MBB, "$tag, getFromStream final list : $intList");
    return Uint8List.fromList(intList);
  }

  Future<MayBankPaymentDetails?> getMayBankPaymentDataFromStreams(
      Stream<Uint8List> streams) async {
    List<String> responseData = List.empty(growable: true);
    List<int> intList = List.empty(growable: true);

    String? start, response, card, expiry, statusCode, approvalCode, rrn, trace;
    String? batchNo, hostNo;

    bool startAdding = false;

    await for (Uint8List? list
        in streams.timeout(const Duration(seconds: 80), onTimeout: (h) {
      h.close();
    })) {
      MyLogUtils.logDebug(
          type: LogType.MBB,
          "$tag, getMayBankPaymentData list : $list and its length "
          ":${list?.length} & updated list size : ${intList.length} & $intList");

      if (list != null && list.isNotEmpty) {
        for (var value in list) {
          if (start != null && startAdding == true) {
            // After start 4 bytes for response is updated here.
            intList.add(value);

            if (response == null) {
              if (intList.length == 4) {
                response = convertUInt8ListToString(
                    Uint8List.fromList(intList)); // Add response
                MyLogUtils.logDebug(
                    type: LogType.MBB,
                    "$tag, getMayBankPaymentData response String : $response for intList : $intList");
                intList.clear();
                responseData.add(response);
              }
            }

            // After response 19 bytes card is updated here.
            if (response != null && card == null) {
              if (intList.length == 19) {
                card = convertUInt8ListToString(
                    Uint8List.fromList(intList)); // Add card number
                MyLogUtils.logDebug(
                    type: LogType.MBB,
                    "$tag, getMayBankPaymentData card String : $card for intList : $intList");
                intList.clear();
                responseData.add(card);
              }
            }

            // After card 4 bytes is used for expiry
            if (card != null && expiry == null) {
              if (intList.length == 4) {
                expiry = convertUInt8ListToString(
                    Uint8List.fromList(intList)); // Add card number
                MyLogUtils.logDebug(
                    type: LogType.MBB, "$tag, expiry String : $expiry");
                intList.clear();
                responseData.add(expiry);
              }
            }
            // After card expiry 2 bytes is used for status code
            if (expiry != null && statusCode == null) {
              if (intList.length == 2) {
                statusCode = convertUInt8ListToString(
                    Uint8List.fromList(intList)); // Add card number
                MyLogUtils.logDebug(
                    type: LogType.MBB,
                    "$tag,getMayBankPaymentData status String : $statusCode");
                intList.clear();
                responseData.add(statusCode);
              }
            }

            // After status 6 bytes is used for approvalCode
            if (statusCode != null && approvalCode == null) {
              if (intList.length == 6) {
                approvalCode = convertUInt8ListToString(
                    Uint8List.fromList(intList)); // Add card number
                MyLogUtils.logDebug(
                    type: LogType.MBB,
                    "$tag,getMayBankPaymentData approvalCode String : $approvalCode");
                intList.clear();
                responseData.add(approvalCode);
              }
            }

            // After approvalCode 12 bytes is used for rrn
            if (approvalCode != null && rrn == null) {
              if (intList.length == 12) {
                rrn = convertUInt8ListToString(
                    Uint8List.fromList(intList)); // Add card number
                MyLogUtils.logDebug(
                    type: LogType.MBB,
                    "$tag,getMayBankPaymentData rrn String : $rrn");
                intList.clear();
                responseData.add(rrn);
              }
            }

            // After approvalCode 6 bytes is used for trace
            if (rrn != null && trace == null) {
              if (intList.length == 6) {
                trace = convertUInt8ListToString(
                    Uint8List.fromList(intList)); // Add card number
                MyLogUtils.logDebug(
                    type: LogType.MBB,
                    "$tag,getMayBankPaymentData trace String : $trace");
                intList.clear();
                responseData.add(trace);
              }
            }

            // After trace 6 bytes is used for batchNo
            if (trace != null && batchNo == null) {
              if (intList.length == 6) {
                batchNo = convertUInt8ListToString(
                    Uint8List.fromList(intList)); // Add card number
                MyLogUtils.logDebug(
                    type: LogType.MBB,
                    "$tag,getMayBankPaymentData batchNo String : $batchNo");
                intList.clear();
                responseData.add(batchNo);
              }
            }

            // After batchNo 6 bytes is used for host no
            if (trace != null && hostNo == null) {
              if (intList.length == 6) {
                hostNo = convertUInt8ListToString(
                    Uint8List.fromList(intList)); // Add card number
                MyLogUtils.logDebug(
                    type: LogType.MBB,
                    "$tag,getMayBankPaymentData hostNo String : $hostNo");
                intList.clear();
                responseData.add(hostNo);
              }
            }
          }

          if (responseData.length > 8) {
            MyLogUtils.logDebug(
                type: LogType.MBB,
                "$tag,getMayBankPaymentData Break the loop in getFromStream responseData :$responseData");

            if (response == "R200" && statusCode == "00") {
              MayBankPaymentDetails details = MayBankPaymentDetails();
              details.cardNumber = card;
              details.traceNo = trace;
              details.referenceNumber = rrn;
              details.expiry = expiry;
              details.approvalCode = approvalCode;
              details.batchNumber = batchNo;
              details.statusCode = statusCode;
              details.hostNo = hostNo;
              return details;
            } else {
              return MayBankPaymentDetails(
                  errorMessage:
                      "Payment failed!!!.\nPlease cross check for payment with customer.\nIf success, update the payment in this pop up manually.");
            }
          }

          if (value == startOfText) {
            startAdding = true;
            start = convertUInt8ListToString(
                Uint8List.fromList([value])); // Add start
            MyLogUtils.logDebug(
                type: LogType.MBB,
                "$tag, getMayBankPaymentData Start String : $start");
            response = null;
            card = null;
            expiry = null;
            statusCode = null;
            approvalCode = null;
            rrn = null;
            trace = null;
            batchNo = null;
            hostNo = null;
            responseData.clear();
          }
        }
      }
    }
    MyLogUtils.logDebug(
        type: LogType.MBB, "$tag, getMayBankPaymentData final list : $intList");
    return MayBankPaymentDetails(
        errorMessage:
            "Payment timeout!!!.\nPlease cross payment with customer.\nIf success, update the payment in this pop up manually.");
  }

  // Enquire & acknowledge the same
  Future<bool> _enqAndAck(SerialPort portDevice) async {
    int writeResult = portDevice.write(convertStringToUInt8List(enq));
    MyLogUtils.logDebug(
        type: LogType.MBB, "$tag,_enqAndAck writeResult : $writeResult ");
    final reader = SerialPortReader(portDevice);
    await Future.delayed(const Duration(seconds: 3));
    Stream<Uint8List> stream = reader.stream;
    final chunk = await stream.first;
    MyLogUtils.logDebug(
        type: LogType.MBB, "$tag,_enqAndAck received chunk: $chunk");
    String readResultAsString = convertUInt8ListToString(chunk);
    MyLogUtils.logDebug(
        type: LogType.MBB,
        "$tag,_enqAndAck received string : $readResultAsString");
    return readResultAsString == "ACK";
  }

  // Convert amount to 12 characters
  // 34.31 => remove decimal  & convert to 12 chars =>  000000003431
  // 34.3 => remove decimal  & convert to 12 chars =>   000000003430
  // 343.0 => remove decimal  & convert to 12 chars =>  000000034300
  // 343.55 => remove decimal  & convert to 12 chars => 000000034355
  // 343.50 => remove decimal  & convert to 12 chars => 000000034350
  String _getAmountAsTwelveCharacters(double amount) {
    String amountStringWithNoDecimals = getStringWithTwoDecimal(amount);
    MyLogUtils.logDebug(
        "_getAmountAsTwelveCharacters amountStringWithNoDecimals =>$amountStringWithNoDecimals<=");

    // Get InValue is used to make sure its integer only.
    int amountInCents =
        getInValue(amountStringWithNoDecimals.replaceAll(".", ""));

    MyLogUtils.logDebug(
        "_getAmountAsTwelveCharacters amountInCents =>$amountInCents<=");

    String amountAsString = '$amountInCents';

    int length = amountAsString.length;

    MyLogUtils.logDebug(
        "_getAmountAsTwelveCharacters for =>$amount<= length $length");

    var price = '${_getZeros(12 - length)}$amountAsString';

    MyLogUtils.logDebug("_getAmountAsTwelveCharacters for $amount is $price");
    return price;
  }

  String _getZeros(int count) {
    String value = "";

    for (int i = 0; i < count; i++) {
      value = "${value}0";
    }

    return value;
  }
}
