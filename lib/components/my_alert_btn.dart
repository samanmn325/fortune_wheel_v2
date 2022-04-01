import 'package:flutter/material.dart';

class MyAlertBtn extends StatelessWidget {
  const MyAlertBtn({Key? key, this.mLabel, this.mIcon, this.mColor, this.mPress})
      : super(key: key);
  final String? mLabel;
  final IconData? mIcon;
  final Color? mColor;
  final VoidCallback? mPress;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade300,
      child: GestureDetector(
        onTap: mPress,
        child: Row(
          children: [
            Icon(
              mIcon,
              color: mColor,
            ),
            Text('  $mLabel '),
          ],
        ),
      ),
    );
  }
}
