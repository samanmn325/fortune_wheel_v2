import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fortune_wheel_v2/components/try_again.dart';
import 'package:fortune_wheel_v2/screens/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../constants.dart';
import '../models/user_model.dart';
import '../network.dart';
import '../screens/login_page.dart';
import 'brain.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);
  static String routeName = '/';

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool isConnected = false;

  checkConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        setState(() {
          isConnected = true;
        });
        ////////////////////////             ////////////////////////
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? phoneNumber = prefs.getString('phone number');
        await Network().getUsersList();
        Network().getUserId(phoneNumber);
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
            children: <Widget>[
              Center(
                child: isConnected
                    ? kSpinkit
                    : TryAgain(callBack: () {
                        checkConnection();
                      }),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
