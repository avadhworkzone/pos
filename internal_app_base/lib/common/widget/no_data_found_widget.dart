import 'package:flutter/material.dart';
import 'package:internal_base/common/image_assets.dart';
import 'package:internal_base/common/message_constants.dart';
import 'package:internal_base/common/size_constants.dart';

class NoDataFoundWidget extends StatelessWidget {
  final bool isLoadedAndEmpty;

  const NoDataFoundWidget({
    Key? key,
    required this.isLoadedAndEmpty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: isLoadedAndEmpty ? Colors.white : Colors.transparent,
        child: Center(
            child: isLoadedAndEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                          height: SizeConstants.height * 0.4,
                          ImageAssets.errorLogo),
                      SizedBox(
                        height: SizeConstants.s1 * 10,
                      ),
                      Text(
                        MessageConstants.oops,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConstants.s1 * 20),
                      ),
                      SizedBox(
                        height: SizeConstants.s1 * 10,
                      ),
                      Text(
                        MessageConstants.noDataFound,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: SizeConstants.s1 * 16),
                      ),
                    ],
                  )
                : SizedBox()));
  }
}
