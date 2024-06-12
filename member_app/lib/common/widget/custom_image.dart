import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:member_app/common/color_constants.dart';
import 'package:member_app/common/image_assets.dart';
import 'package:member_app/common/size_constants.dart';

profileRoundImage(String imageUrl) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    key: UniqueKey(),
    height: SizeConstants.width * 0.26,
    width: SizeConstants.width * 0.26,
    fit: BoxFit.cover,
    placeholder: (context, url) {
      return Container(
        height: SizeConstants.width * 0.26,
        width: SizeConstants.width * 0.26,
        padding: EdgeInsets.all(SizeConstants.s3),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
                width: SizeConstants.s2,
                color: ColorConstants.kPrimaryColor.shade600)),
        child:  ClipOval(
                child: Image.asset(
              ImageAssets.imageProfilePic,
              fit: BoxFit.fill,
            )),
      );
    },
    errorWidget: (context, url, error) {
      return Container(
        height: SizeConstants.width * 0.26,
        width: SizeConstants.width * 0.26,
        padding: EdgeInsets.all(SizeConstants.s3),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
                width: SizeConstants.s2,
                color: ColorConstants.kPrimaryColor.shade600)),
        child: ClipOval(
                child: Image.asset(
              ImageAssets.imageProfilePic,
              fit: BoxFit.fill,
            )),
      );
    },
    imageBuilder: (context, imageProvider) => Container(
        height: SizeConstants.width * 0.26,
        width: SizeConstants.width * 0.26,
        padding: EdgeInsets.all(SizeConstants.s3),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              width: SizeConstants.s2,
                color: ColorConstants.kPrimaryColor.shade600)),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        )),
  );
}

rectangularImage(String imageUrl) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    key: UniqueKey(),
    height: SizeConstants.width * 0.26,
    // width: SizeConstants.width * 0.26,
    fit: BoxFit.cover,
    placeholder: (context, url) {
      return Container(
        height: SizeConstants.width * 0.26,
        padding: EdgeInsets.all(SizeConstants.s3),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
            color: Colors.white,
            shape: BoxShape.rectangle,
           ),
      );
    },
    errorWidget: (context, url, error) {
      return Container(
        height: SizeConstants.width * 0.26,
        // width: SizeConstants.width * 0.26,
        padding: EdgeInsets.all(SizeConstants.s3),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
            color: Colors.white,
            shape: BoxShape.rectangle,
          ),
      );
    },
    imageBuilder: (context, imageProvider) => Container(
        height: SizeConstants.width * 0.26,
        // width: SizeConstants.width * 0.26,
        padding: EdgeInsets.all(SizeConstants.s3),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
            color: Colors.white,
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        )),
  );
}
