import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:internal_base/common/alert/filter_value.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/image_assets.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/text_styles_constants.dart';
import 'package:internal_base/common/widget/edit_text_field.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class FilterCustomDialog extends StatefulWidget {
  final String message;

  const FilterCustomDialog({super.key, required this.message});

  @override
  _FilterCustomDialogState createState() => _FilterCustomDialogState();
}

class _FilterCustomDialogState extends State<FilterCustomDialog> {
  TextEditingController mSearchTextEditingController = TextEditingController();
  bool canUpload = false;
  String result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                    left: SizeConstants.s1 * 26, right: SizeConstants.s1 * 26),
                padding: EdgeInsets.only(
                    left: SizeConstants.s1 * 10,
                    top: SizeConstants.s1 * 15,
                    right: SizeConstants.s1 * 15,
                    bottom: SizeConstants.s1 * 15),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(SizeConstants.s1 * 35),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(image: AssetImage(ImageAssets.dialogIcon)),
                        Text(widget.message,
                            style: getTextRegular(
                                size: SizeConstants.s1 * 12,
                                heights: 1.5,
                                colors: Colors.grey.shade500)),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop("");
                            },
                            child: Image(
                                image: AssetImage(ImageAssets.dialogClose))),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: SizeConstants.s1 * 20,
                          left: SizeConstants.s1 * 15,
                          right: SizeConstants.s1 * 10),
                      child: editSearchText(mSearchTextEditingController, () {},
                          hintText: AppConstants.cWordConstants.wSearchText,
                          mIcons: Icons.search),
                    ),
                    SizedBox(
                      height: SizeConstants.s1 * 10,
                    ),
                    GestureDetector(
                        onTap: () async {
                          var res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SimpleBarcodeScannerPage(),
                              ));
                          setState(() {
                            if (res is String) {
                              result = res;
                              print('response===>>${result}');
                            }
                          });
                          FilterValue mFilterValue = FilterValue(
                              result.toString(), canUpload ? "0" : "1");
                          String pp = jsonEncode(mFilterValue);
                          Navigator.of(context).pop(pp);
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.adf_scanner_outlined),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Scan Here'),
                          ],
                        )),
                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text("Only No Stock products",
                          style: getTextMedium(
                              size: SizeConstants.s1 * 13,
                              heights: 1.5,
                              colors: Colors.black)),
                      value: canUpload,
                      onChanged: (val) {
                        setState(() {
                          canUpload = val as bool;
                        });
                      },
                    ),
                    SizedBox(
                      height: SizeConstants.s1 * 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          FilterValue mFilterValue = FilterValue(
                              mSearchTextEditingController.text,
                              canUpload ? "0" : "1");
                          String pp = jsonEncode(mFilterValue);
                          Navigator.of(context).pop(pp);
                        },
                        child: Image(
                            height: SizeConstants.s1 * 40,
                            width: SizeConstants.s1 * 40,
                            image: AssetImage(ImageAssets.dialogCheckArrow))),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
