import 'package:flutter/material.dart';

import 'screens/brain.dart';

class MyProvider extends ChangeNotifier {
  int point = 0;
  int star = 0;

  int get getPoint => point;
  int get getStar => star;
  setPoint(int p) {
    point = point + p;
    if (point >= Brain.scorelimit) {
      star = star + 1;
      point = point - Brain.scorelimit;
    }
    notifyListeners();
  }

  setStar(int s) {
    star = s;
    notifyListeners();
  }
}
