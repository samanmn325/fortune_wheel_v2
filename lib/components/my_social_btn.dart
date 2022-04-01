import 'package:flutter/material.dart';

class MySocialBtn extends StatelessWidget {
  const MySocialBtn({Key? key, this.mIconColor, this.mIcon, this.mPress})
      : super(key: key);

  final VoidCallback? mPress;
  final IconData? mIcon;
  final Color? mIconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      child: IconButton(
        icon: Icon(
          mIcon,
          color: mIconColor,
          size: 30.0,
        ),
        onPressed: mPress,
      ),
    );
  }
}
