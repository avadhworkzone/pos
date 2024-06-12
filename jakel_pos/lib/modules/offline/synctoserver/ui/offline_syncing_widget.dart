import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_pos/AppPreference.dart';
import 'package:jakel_pos/modules/offline/synctoserver/OfflineSyncingViewModel.dart';
import 'package:cron/cron.dart';

import '../../../downloaddata/DownloadDataViewModel.dart';

class OfflineSyncingWidget extends StatefulWidget {
  final bool downloadData;

  const OfflineSyncingWidget({Key? key, required this.downloadData})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OfflineSyncingWidgetState();
  }
}

class _OfflineSyncingWidgetState extends State<OfflineSyncingWidget> {
  final viewModel = OfflineSyncingViewModel();
  final downloadDataViewModel = DownloadDataViewModel();

  final cron = Cron();
  bool showSyncing = false;
  bool showDownloading = true;
  String downloadMessage = "";

  bool isFirstTime = false; // make it as true, to download items on app open
  bool pauseDownload = true; // make it as true, to stop auto download

  Timer? _downloadTimer, _syncTimer;

  @override
  void initState() {
    super.initState();
    _cronJobToSyncDownload();
  }

  @override
  void dispose() {
    super.dispose();
    if (_downloadTimer != null) {
      _downloadTimer?.cancel();
    }

    if (_syncTimer != null) {
      _syncTimer?.cancel();
    }
  }

  void _cronJobToSyncDownload() {
    _downloadTimer = Timer.periodic(
        const Duration(hours: 5), (Timer t) => downloadAllDataFromServer());

    _syncTimer = Timer.periodic(
        const Duration(seconds: 30), (Timer t) => syncAllDataToServer());
  }

  @override
  Widget build(BuildContext context) {
    if (isFirstTime) {
      isFirstTime = false;
      downloadAllDataFromServer();
    }
    return IntrinsicWidth(
        child: Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        showSyncing ? const Text('Syncing to cloud..') : Container(),
        const SizedBox(
          width: 10,
        ),
        showDownloading
            ? Text(
                downloadMessage,
                style: Theme.of(context).textTheme.caption,
              )
            : Container(),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: getOfflineSalesCountWidget(),
        )
      ],
    ));
  }

  Widget getOfflineSalesCountWidget() {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 10))
          .asyncMap((i) => getAllNotSyncedData()),
      // i is null here (check periodic docs)
      builder: (context, snapshot) => Text(
        snapshot.data == null ? "" : snapshot.data.toString(),
        style: Theme.of(context).textTheme.caption,
      ), // builder should also handle the case when data is not fetched yet
    );
  }

  Future<String> getAllNotSyncedData() async {
    MyLogUtils.logDebug("getAllNotSyncedData every 10 seconds");

    List<CartSummary> allOfflineSales = await viewModel.getAllOfflineSales();

    MyLogUtils.logDebug(
        "getAllSales every 10 seconds  allOfflineSales length : ${allOfflineSales.length}");

    if (allOfflineSales.isEmpty) {
      return "";
    }

    return "Offline Sale : ${allOfflineSales.length}";
  }

  void syncAllDataToServer() async {
    MyLogUtils.logDebug("syncAllData");
    setState(() {
      showSyncing = true;
    });

    await viewModel.syncAllDataToCloud();

    setState(() {
      showSyncing = false;
    });
  }

  void downloadAllDataFromServer() async {
    if (pauseDownload) {
      return;
    }
    if (!widget.downloadData) {
      return;
    }

    MyLogUtils.logDebug("downloadAllDataFromServer started");

    setState(() {
      showDownloading = true;
    });

    downloadDataViewModel.startDownloading((message) {
      MyLogUtils.logDebug(message);
      if (message == "Completed") {
        setState(() {
          AppPreference().refreshProductsData = true;
          showDownloading = false;
        });
      } else {
        setState(() {
          downloadMessage = message;
        });
      }
    }, () {
      //OnCompleted CallBack
      setState(() {
        showDownloading = false;
      });
    }, (m) {
      //OnError CallBack
      setState(() {
        showDownloading = false;
        downloadMessage = "";
      });
    });
  }
}
