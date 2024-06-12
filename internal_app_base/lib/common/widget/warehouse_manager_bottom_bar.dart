import 'package:flutter/material.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/size_constants.dart';

class WarehouseManagerBottomBar extends StatelessWidget {
  final CallbackModel mCallbackModel;
  final Function returnValueChanged;

  const WarehouseManagerBottomBar(
      {super.key, required this.mCallbackModel, required this.returnValueChanged});


  @override
  Widget build(BuildContext context) {
    int selectValue = mCallbackModel.sValue as int;
    // TODO: implement build
    return Container(
        padding: EdgeInsets.only(
            left: SizeConstants.s1 * 15, right: SizeConstants.s1 * 15),
        margin: EdgeInsets.all(SizeConstants.s1 * 15),
        height: SizeConstants.s1 * 65,

        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.all(
              Radius.circular(SizeConstants.s1 * 60)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            view(selectValue, selectValue == 0, 0),
            view(selectValue, selectValue == 1, 1),
            view(selectValue, selectValue == 2, 2)
          ],
        )
    );
  }

  view(int selectValue, bool bSelect, int viewPogisition) {
    return GestureDetector(
        onTap: () {
          returnValueChanged(viewPogisition);
        },
        child: Container(
          height: SizeConstants.s1 * 45,
          width: SizeConstants.s1 * 55,
          padding: EdgeInsets.all(SizeConstants.s1 * 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
                Radius.circular(SizeConstants.s1 * 60)),
          ),
          child: Image(
            image: AssetImage(bSelect
                ? mCallbackModel.levyArrearsVOList[selectValue +
                (mCallbackModel.levyArrearsVOList.length ~/ 2)]
                : mCallbackModel.levyArrearsVOList[viewPogisition]),
          ),)
    );
  }

}