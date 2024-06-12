import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internal_base/common/color_constants.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/text_styles_constants.dart';

editTextFiled(TextEditingController mTextEditingController,
    {bool readOnly = false,
      bool obscureText = false,
      bool validate = false,
      bool mandatoryField = false,
      labelColor: ColorConstants.cWhite,
      cursorColor: ColorConstants.cWhite,
      int maxLines = 1,
      String labelText = "",
      String hintText = "",
      IconData mIcons = Icons.add,
      TextInputType textInputType = TextInputType.text}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
      margin: EdgeInsets.only(
          left: SizeConstants.s1 * 3, right: SizeConstants.s1 * 3),
      padding: EdgeInsets.only(
          left: SizeConstants.s1 * 15,
          right: SizeConstants.s1 * 15,
          top: SizeConstants.s1 * 12,
          bottom: SizeConstants.s1 * 16),
      decoration: BoxDecoration(
          borderRadius:
          BorderRadius.all(Radius.circular(SizeConstants.s1 * 15)),
          color: Colors.transparent,
          border: Border.all(
            color: ColorConstants.cEditTextBorderLightColor,
            width: SizeConstants.s1 * 1.25,
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: labelText,
              style: getTextRegular(
                  size: SizeConstants.s1 * 12,
                  colors: labelColor,
                  letterSpacing: 0.2),
              children: <TextSpan>[
                TextSpan(
                    text: mandatoryField? "*" : "", style: getTextLight(
                    size: SizeConstants.s1 * 14,
                    colors: Colors.red,
                    letterSpacing: 1.0),),
              ],
            ),
          ),

          SizedBox(
            height: SizeConstants.s1 * 5,
          ),

          TextField(
              autocorrect: false,
              controller: mTextEditingController,
              cursorColor: cursorColor,
              maxLines: maxLines,
              readOnly: readOnly,
              obscureText: obscureText,
              keyboardType: textInputType,
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.next,
              textAlignVertical: TextAlignVertical.top,
              style: getTextMedium(
                  size: SizeConstants.s1 * 16,
                  colors: cursorColor,
                  letterSpacing: 0.2),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0.0),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: hintText,
                  alignLabelWithHint: true,
                  hintStyle: getTextRegular(
                      size: SizeConstants.s1 * 11,
                      colors: labelColor,
                      letterSpacing: 0.2)
              )),
        ],
      )
  ),
        (validate == true) ? Container(
          padding: const EdgeInsets.only(left: 10),
          height: SizeConstants.s1 * 15,
          child: Text(
            "Please enter ${labelText}",
            style: getTextLight(
                size: SizeConstants.s1 * 12,
                colors: Colors.red,
                letterSpacing: 0.2),
          )
   ) : SizedBox(),
      ]
  );
}

editSearchText(TextEditingController mTextEditingController,
    Function fSuarch,
    {bool readOnly = false,
      bool obscureText = false,
      cursorColor: ColorConstants.cBlack,
      int maxLines = 1,
      String labelText = "",
      String hintText = "",
      IconData mIcons = Icons.add,
      TextInputType textInputType = TextInputType.text}) {
  return Container(
      margin: EdgeInsets.only(
          left: SizeConstants.s1 * 3, right: SizeConstants.s1 * 3),
      padding: EdgeInsets.only(
          left: SizeConstants.s1 * 15,
          right: SizeConstants.s1 * 15,
          top: SizeConstants.s1 * 12,
          bottom: SizeConstants.s1 * 16),
      decoration: BoxDecoration(
          borderRadius:
          BorderRadius.all(Radius.circular(SizeConstants.s1 * 8)),
          color: Colors.transparent,
          border: Border.all(
            color: ColorConstants.cEditTextBorderLightColor,
            width: SizeConstants.s1 * 1.25,
          )),
      child:
      Row(
        children: [
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              labelText.isNotEmpty ? Text(
                labelText,
                style: getTextRegular(
                    size: SizeConstants.s1 * 14,
                    colors: Colors.grey,
                    letterSpacing: 0.2),
              ) : SizedBox(),
              SizedBox(
                height: labelText.isNotEmpty ? SizeConstants.s1 * 5 : 0.0,
              ),
              TextField(
                  controller: mTextEditingController,
                  cursorColor: cursorColor,
                  maxLines: maxLines,
                  readOnly: readOnly,
                  obscureText: obscureText,
                  keyboardType: textInputType,
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.next,
                  textAlignVertical: TextAlignVertical.top,
                  style: getTextMedium(
                      size: SizeConstants.s1 * 15,
                      colors: ColorConstants.cBlack,
                      letterSpacing: 0.2),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0.0),
                      filled: true,
                      fillColor: Colors.transparent,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: hintText,
                      alignLabelWithHint: true,
                      hintStyle: getTextRegular(
                          size: SizeConstants.s1 * 12,
                          colors: Colors.grey,
                          letterSpacing: 0.2)
                  )),
            ],
          )),
          SizedBox(width: SizeConstants.s1 * 10,),
          GestureDetector(
            onTap: () {
              fSuarch();
            },
            child: Icon(
              mIcons,
              color: Colors.grey,
              size: SizeConstants.s1 * 30,
            ),
          ),

        ],
      )
  );
}

editTextFiledSelection(TextEditingController mTextEditingController,
    Function fSuarch,
    {bool obscureText = false,
      bool mandatoryField = false,
      bool validate = false,
      labelColor: ColorConstants.cWhite,
      cursorColor: ColorConstants.cWhite,
      int maxLines = 1,
      String labelText = "",
      String hintText = "",
      IconData mIcons = Icons.add,
      TextInputType textInputType = TextInputType.text}) {
  return
    GestureDetector(
        onTap: () {
          fSuarch();
        },
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
        children:
        [
          Container(
          margin: EdgeInsets.only(
              left: SizeConstants.s1 * 3, right: SizeConstants.s1 * 3),
          padding: EdgeInsets.only(
              left: SizeConstants.s1 * 15,
              right: SizeConstants.s1 * 15,
              top: SizeConstants.s1 * 12,
              bottom: SizeConstants.s1 * 16),
          decoration: BoxDecoration(
              borderRadius:
              BorderRadius.all(Radius.circular(SizeConstants.s1 * 15)),
              color: Colors.transparent,
              border: Border.all(
                color: ColorConstants.cEditTextBorderLightColor,
                width: SizeConstants.s1 * 1.25,
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: labelText,
                  style: getTextRegular(
                      size: SizeConstants.s1 * 12,
                      colors: labelColor,
                      letterSpacing: 0.2),
                  children: <TextSpan>[
                    TextSpan(
                      text: mandatoryField? "*" : "", style: getTextMedium(
                        size: SizeConstants.s1 * 14,
                        colors: Colors.red,
                        letterSpacing: 1.0),),
                  ],
                ),
              ),

              SizedBox(
                height: SizeConstants.s1 * 5,
              ),

              TextField(
                  controller: mTextEditingController,
                  cursorColor: cursorColor,
                  maxLines: maxLines,
                  readOnly: true,
                  onTap: (){
                    fSuarch();
                  },
                  obscureText: obscureText,
                  keyboardType: textInputType,
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.next,
                  textAlignVertical: TextAlignVertical.top,
                  style: getTextMedium(
                      size: SizeConstants.s1 * 16,
                      colors: cursorColor,
                      letterSpacing: 0.2),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0.0),
                      filled: true,
                      fillColor: Colors.transparent,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: hintText,
                      alignLabelWithHint: true,
                      hintStyle: getTextLight(
                          size: SizeConstants.s1 * 12,
                          colors: labelColor,
                          letterSpacing: 0.2)
                  )),
            ],
          ),
        ),
        (validate == true) ? Container(
            padding: const EdgeInsets.only(left: 10),
            height: SizeConstants.s1 * 15,
            child: Text(
              "Please enter ${labelText}",
              style: getTextLight(
                  size: SizeConstants.s1 * 12,
                  colors: Colors.red,
                  letterSpacing: 0.2),
            )
        ) : SizedBox(),
        ]
    )
    );
}
