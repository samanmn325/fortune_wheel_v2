import 'package:flutter/material.dart';

import 'screens/brain.dart';
import 'screens/wheel_page.dart';
import 'screens/login_page.dart';

Map<String, Widget Function(BuildContext)> routes = {
  Brain.routeName: (context) => Brain(),
  LoginPage.routeName: (context) => LoginPage(),
  WheelPage.routeName: (context) => WheelPage(),
};
