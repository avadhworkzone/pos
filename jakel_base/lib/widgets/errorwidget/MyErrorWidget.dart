import 'package:flutter/cupertino.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:easy_localization/easy_localization.dart';

class MyErrorWidget extends StatelessWidget {
  final String message;
  final Function tryAgain;

  const MyErrorWidget({Key? key, required this.message, required this.tryAgain})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        children: [
          Text(
            message,
            style: TextStyle(color: getPrimaryColor(context), fontSize: 12),
          ),
          MyOutlineButton(text: tr('try_again'), onClick: tryAgain)
        ],
      ),
    );
  }
}
