import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

import '../constants.dart';
import '../screens/brain.dart';

List<FortuneItem> finalList = createItems();
List<FortuneItem> createItems() {
  List<FortuneItem> items4 = [];
  try {

    int c = 0;
    for (var ite in Brain.itemsIntList) {
        items4.add(
          FortuneItem(
            child: Text(
              '${ite}',
              style: kPointTextStyle,
            ),
            style: FortuneItemStyle(
              //  custom circle slice fill color
              color: colorList[c],
              //  custom circle slice stroke color
              //  custom circle slice stroke width
              borderWidth: 3,
            ),
          ),
        );
      c  = c+1;
    }
  } catch (e) {
    print(e);
  }
  return items4;
}

List<Color> colorList = [
  Color(0xFF9dc564),
  Color(0xFF64b56d),
  Color(0xFF2bb1f0),
  Color(0xFF2180ef),
  Color(0xFF5B65BE),
  Color(0xFF7C50BF),
  Color(0xFFA446B6),
  Color(0xFFE63E72),
  Color(0xFFDF564B),
  Color(0xFFEC534B),
  // Color(0xFFF9A221),
  // Color(0xFFF9C629),
];

// List<FortuneItem> items2 = const [
//   FortuneItem(
//     child: Text(
//       '100',
//       style: kPointTextStyle,
//     ),
//     style: FortuneItemStyle(
//       //  custom circle slice fill color
//       color: Color(0xFF9dc564),
//       //  custom circle slice stroke color
//       //  custom circle slice stroke width
//       borderWidth: 3,
//     ),
//   ),
//   FortuneItem(
//     child: Text(
//       '0',
//       style: kPointTextStyle,
//     ),
//     style: FortuneItemStyle(
//       color: Color(0xFF64b56d),
//       borderWidth: 3,
//     ),
//   ),
//   FortuneItem(
//     child: Text(
//       '10',
//       style: kPointTextStyle,
//     ),
//     style: FortuneItemStyle(
//       color: Color(0xFF2bb1f0),
//       borderWidth: 3,
//     ),
//   ),
//   FortuneItem(
//     child: Text(
//       '100',
//       style: kPointTextStyle,
//     ),
//     style: FortuneItemStyle(
//       color: Color(0xFF2180ef),
//       borderWidth: 3,
//     ),
//   ),
//   FortuneItem(
//     child: Text(
//       '0',
//       style: kPointTextStyle,
//     ),
//     style: FortuneItemStyle(
//       color: Color(0xFF5B65BE),
//       borderWidth: 3,
//     ),
//   ),
//   FortuneItem(
//     child: Text(
//       '10',
//       style: kPointTextStyle,
//     ),
//     style: FortuneItemStyle(
//       color: Color(0xFF7C50BF),
//       borderWidth: 3,
//     ),
//   ),
//   FortuneItem(
//     child: Text(
//       '100',
//       style: kPointTextStyle,
//     ),
//     style: FortuneItemStyle(
//       color: Color(0xFFA446B6),
//       borderWidth: 3,
//     ),
//   ),
//   FortuneItem(
//     child: Text(
//       '0',
//       style: kPointTextStyle,
//     ),
//     style: FortuneItemStyle(
//       color: Color(0xFFE63E72),
//       borderWidth: 3,
//     ),
//   ),
//   FortuneItem(
//     child: Text(
//       '10',
//       style: kPointTextStyle,
//     ),
//     style: FortuneItemStyle(
//       color: Color(0xFFDF564B),
//       borderWidth: 3,
//     ),
//   ),
//   FortuneItem(
//     child: Text(
//       '100',
//       style: kPointTextStyle,
//     ),
//     style: FortuneItemStyle(
//       color: Color(0xFFEC534B),
//       borderWidth: 3,
//     ),
//   ),
//   FortuneItem(
//     child: Text(
//       '0',
//       style: kPointTextStyle,
//     ),
//     style: FortuneItemStyle(
//       color: Color(0xFFF9A221),
//       borderWidth: 3,
//     ),
//   ),
//   FortuneItem(
//     child: Text(
//       '10',
//       style: kPointTextStyle,
//     ),
//     style: FortuneItemStyle(
//       color: Color(0xFFF9C629),
//       borderWidth: 3,
//     ),
//   ),
// ];


