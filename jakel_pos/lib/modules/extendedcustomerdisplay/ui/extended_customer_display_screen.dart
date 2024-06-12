import 'dart:async';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/jakel_base.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/appbgwidget/MyBackgroundWidget.dart';
import 'package:video_player_win/video_player_win.dart';

import '../../app/theme/my_theme.dart';

class ExtendedCustomerDisplayScreen extends StatefulWidget {
  final WindowController windowController;
  final Map? args;
  final List<String> mediaFiles;

  const ExtendedCustomerDisplayScreen(
      {Key? key,
      required this.windowController,
      this.args,
      required this.mediaFiles})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ExtendedCustomerDisplayScreenState();
  }
}

class _ExtendedCustomerDisplayScreenState
    extends State<ExtendedCustomerDisplayScreen> {
  late CarouselController buttonCarouselController;
  bool playController = false;
  late WinVideoPlayerController? controller;

  void reload(String sFilePart) {
    //controller?.dispose();
    controller = WinVideoPlayerController.file(File(sFilePart));
    controller!.initialize().then((value) {
      if (controller!.value.isInitialized) {
        controller!.play();
        setState(() {
          playController = true;
        });

        controller!.addListener(() {
          if (!controller!.value.isPlaying &&
              controller!.value.isInitialized &&
              (controller!.value.duration == controller!.value.position)) {
            setState(() {
              controller?.dispose();
              playController = false;
            });
          }
        });
      } else {
        MyLogUtils.logDebug("video file load failed");
      }
    }).catchError((e) {
      MyLogUtils.logDebug("controller.initialize() error occurs: $e");
    });
  }

  @override
  void initState() {
    super.initState();
    DesktopMultiWindow.setMethodHandler(_handleMethodCallback);
    buttonCarouselController = CarouselController();
  }

  @override
  dispose() {
    DesktopMultiWindow.setMethodHandler(null);
    controller?.dispose();
    super.dispose();
  }

  CartSummary? cartSummary;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.transparent,
      debugShowCheckedModeBanner: false,
      theme: myLightTheme(context),
      darkTheme: myDarkTheme(context),
      home: Scaffold(
          body: SizedBox(
        child: MyBackgroundWidget(
          child: getMainWidget(context),
        ),
      )),
    );
  }

  Widget getMainWidget(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Container(
              padding:
                  const EdgeInsets.only(top: 30, bottom: 30, left: 3, right: 3),
              decoration: BoxDecoration(
                color: (getPrimaryColor(context) as Color).withOpacity(0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              constraints: const BoxConstraints.expand(),
              child: Column(
                children: [
                  Text(
                    "Cart Items",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const Divider(
                    thickness: 4,
                  ),
                  Expanded(child: getCartWidget())
                ],
              ),
            )),
        Expanded(
            flex: 3,
            child: Column(
              children: [
                Expanded(
                  child: getMediaPage(),
                ),
                getGrandTotal()
              ],
            ))
      ],
    );
  }

  Widget getCartWidget() {
    if (cartSummary == null ||
        cartSummary?.cartItems == null ||
        cartSummary!.cartItems!.isEmpty) {
      return Container();
    }

    var length = cartSummary?.cartItems?.length ?? 0;

    return ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        shrinkWrap: true,
        itemCount: length,
        itemBuilder: (context, index) {
          //For all previous items no short cuts
          return cartItemRow(cartSummary!.cartItems![index], index);
        });
  }

  Widget cartItemRow(CartItem item, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              '${index + 1}.',
            ),
            const SizedBox(width: 10),
            Flexible(
                child: Text(
              item.getProductName(),
              maxLines: 2,
              style: Theme.of(context).textTheme.bodyText1,
            ))
          ],
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '       x ${item.qty}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              getReadableAmount(getCurrency(), item.cartItemPrice?.totalAmount),
              style: Theme.of(context).textTheme.bodyText1,
            )
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  // To Be used when we support gif & fix video crash
  Widget getMediaPage() {
    MyLogUtils.logDebug("get media page mediaFiles : ${widget.mediaFiles}");
    return Container(
      constraints: const BoxConstraints.expand(),
      child: CarouselSlider(
        carouselController: buttonCarouselController,
        options: CarouselOptions(
          aspectRatio: 1,
          viewportFraction: 0.8,
          enlargeCenterPage: true,
          autoPlay: !playController,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          enableInfiniteScroll: true,
          autoPlayCurve: Curves.fastOutSlowIn,
          onPageChanged: callbackFunction,
        ),
        items: widget.mediaFiles.map((i) {
          return Builder(
            builder: (BuildContext context) {
              if (i.contains("mp4")) {
                return Container(
                  color: Colors.red,
                  child:
                      playController ? WinVideoPlayer(controller!) : SizedBox(),
                );
              } else {
                return Container(
                  padding: const EdgeInsets.all(5),
                  constraints: const BoxConstraints.expand(),
                  child: Image(
                    fit: BoxFit.cover,
                    image: FileImage(File(i)),
                  ),
                );
              }
            },
          );
        }).toList(),
      ),
    );
  }

  // Widget getMediaPage() {
  //   if (widget.videoFile == null) {
  //     return Container();
  //   }
  //
  //   if (widget.videoFile!.contains("gif")) {
  //     return Container(
  //       constraints: const BoxConstraints.expand(),
  //       child: MyGifWidget(videoFile: File(widget.videoFile!)),
  //     );
  //   }
  //
  //   if (widget.videoFile!.contains(".png") ||
  //       widget.videoFile!.contains(".jpg") ||
  //       widget.videoFile!.contains(".jpeg")) {
  //     return Container(
  //       constraints: const BoxConstraints.expand(),
  //       child: Image(
  //         fit: BoxFit.cover,
  //         image: FileImage(File(widget.videoFile!)),
  //       ),
  //     );
  //   }
  //   return Container(
  //     constraints: const BoxConstraints.expand(),
  //     child: MyVideoPlayer(fileName: widget.videoFile),
  //     // child: Stack(
  //     //   children: [
  //     //     Align(
  //     //         alignment: Alignment.bottomCenter,
  //     //         child: Container(
  //     //           margin: const EdgeInsets.only(bottom: 50),
  //     //           child: Column(
  //     //             mainAxisAlignment: MainAxisAlignment.end,
  //     //             children: [
  //     //               const Text("Welcome,"),
  //     //               const SizedBox(height: 10),
  //     //               Text(cartSummary?.customers?.firstName ?? ''),
  //     //               const SizedBox(height: 10),
  //     //             ],
  //     //           ),
  //     //         )),
  //     //
  //     //   ],
  //     // ),
  //   );
  // }

  Widget getGrandTotal() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: (getPrimaryColor(context) as Color).withOpacity(0.3),
      ),
      child: Center(
        child: Text(
          "GRAND TOTAL : ${getReadableAmount(getCurrency(), cartSummary?.cartPrice?.total)}",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String? fileName;

  Future<dynamic> _handleMethodCallback(
      MethodCall call, int fromWindowId) async {
    MyLogUtils.logDebug("Received Cart Update from $fromWindowId");
    MyLogUtils.logDebug("Received call.method ${call.method}");
    MyLogUtils.logDebug("Received call.arguments ${call.arguments}");

    if (call.arguments != null) {
      setState(() {
        cartSummary = CartSummary.fromJson(call.arguments);
      });
    }
  }

  callbackFunction(int index, CarouselPageChangedReason reason) {
    if (widget.mediaFiles[index].contains("mp4")) {
      buttonCarouselController.stopAutoPlay();
      reload(widget.mediaFiles[index]);
    } else {
      playController = false;
    }
  }
}
