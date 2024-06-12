import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';

class MyNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? height, width;

  const MyNetworkImage(
      {Key? key, required this.imageUrl, this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Icon(
          Icons.wallet,
          size: height,
          color: Theme
              .of(context)
              .colorScheme
              .tertiary
      );
      //return MyLogoWidget(height: height, width: width);
    }

    if (imageUrl!.contains(".svg")) {
      return SvgPicture.network(
          imageUrl!,
          color: Theme
              .of(context)
              .colorScheme
              .tertiary,
          semanticsLabel: '',
          height: height,
          width: width,
          placeholderBuilder: (BuildContext context) =>
              Icon(
                  Icons.wallet,
                  size: height,
                  color: Theme
                      .of(context)
                      .colorScheme
                      .tertiary
              )
      );
    }

    return CachedNetworkImage(
      fit: BoxFit.fitWidth,
      imageUrl: imageUrl!,
      height: height,
      width: width,
      placeholder: (context, url) =>
      const Image(
          image: ExactAssetImage(
            "assets/images/ariani_logo.png",
          ),
          fit: BoxFit.scaleDown),
      errorWidget: (context, url, error) {
        return Icon(
          Icons.wallet,
          size: height,
          color: getTertiaryColor(context),
        );
      },
    );
  }
}
