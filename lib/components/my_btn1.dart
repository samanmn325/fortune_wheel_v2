import 'package:flutter/material.dart';

import '../constants.dart';

class MyBtn1 extends StatelessWidget {
  const MyBtn1({Key? key, this.mLable, this.mColor, this.mPress})
      : super(key: key);

  final String? mLable;
  final VoidCallback? mPress;
  final Color? mColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: mColor,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      height: 50,
      width: 100,
      child: GestureDetector(
        child: Center(
            child: Text(
          '$mLable',
          style: kButtonTextStyle,
        )),
        onTap: mPress,
      ),
    );
  }
}
