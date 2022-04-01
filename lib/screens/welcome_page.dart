import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fortune_wheel_v2/screens/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../constants.dart';
import '../models/user_model.dart';
import '../network.dart';
import '../screens/login_page.dart';

const spinkit = SpinKitDualRing(
  color: Color.fromARGB(255, 0, 0, 0),
  size: 80.0,
);

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);
  static String routeName = '/';
  static List<User> UserList = [];
  static late String telegramUrl;
  static late String youtubeUrl;
  static late String instagramUrl;
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  checkConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');

        ////////////////////////             ////////////////////////
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? phoneNumber = prefs.getString('phone number');

        await Network().getUsersList();
        if (phoneNumber != null) {
          var long1 = double.parse(phoneNumber);
          for (var temp in WelcomePage.UserList) {
            String a = kParseHtmlString(temp.phoneNumber!);
            // print(a.substring(0, 11));
            // var long2 = double.parse(a[0]);
            //     if (long1 == long2) {
            //       prefs.setInt('id', temp.id!);
            //       int? id = prefs.getInt('id');
            //       print("id is : $id");
            //     }
          }
        }
        // await Future.delayed(Duration(seconds: 10));
        Navigator.pushNamedAndRemoveUntil(
            context,
            phoneNumber == null ? LoginPage.routeName : HomePage.routeName,
            (route) => false);
      }
    } on SocketException catch (_) {
      print('not connected');
    }
  }

  @override
  void initState() {
    checkConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body: SafeArea(
        child: Container(
          decoration: kBoxDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Center(child: spinkit),
            ],
          ),
        ),
      )),
    );
  }
}
