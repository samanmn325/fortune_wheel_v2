import 'package:flutter/material.dart';

import '../constants.dart';

class LogoContainer extends StatelessWidget {
  const LogoContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 200.0, bottom: 50.0),
      child: SizedBox(
          height: 150,
          child: Image(
            image: AssetImage('assets/images/logo3.png'),
          )),
    );
  }
}
// Text(
//           'LOGO',
//           style: TextStyle(
//               color: kButtonColor, fontWeight: FontWeight.bold, fontSize: 40),
//         ),