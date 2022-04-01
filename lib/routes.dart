import 'package:flutter/material.dart';

import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'screens/welcome_page.dart';

Map<String,Widget Function(BuildContext)> routes ={
        WelcomePage.routeName: (context) => WelcomePage(),
        LoginPage.routeName: (context) => LoginPage(),
        HomePage.routeName: (context) => HomePage(),
      };