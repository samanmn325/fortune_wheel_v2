import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fortune_wheel_v2/components/try_again.dart';
import 'package:fortune_wheel_v2/constants.dart';
import 'package:fortune_wheel_v2/screens/wheel_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../network.dart';
import 'login_page.dart';

class Brain extends StatefulWidget {
  const Brain({
    Key? key,
  }) : super(key: key);
  static String routeName = '/brain';
  static List<User> UserList = [];
  static late String telegramUrl;
  static late String youtubeUrl;
  static late String instagramUrl;
  static late User user;
  static bool isSignedup = false;
  @override
  State<Brain> createState() => _BrainState();
}

class _BrainState extends State<Brain> {
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
        await Future.delayed(const Duration(seconds: 3));
        await Network().getUsersList();
        Network().getUserId(phoneNumber: phoneNumber);
        Navigator.pushNamedAndRemoveUntil(
            context,
            phoneNumber == null ? LoginPage.routeName : WheelPage.routeName,
            (route) => false);
      }
    } on SocketException catch (_) {
      print('not connected');
      kToast('اشکال در اتصال به اینترنت!');
      kToast('لطفاً از اتصال به اینترنت مطمئین شوید و دوباره تلاش کنید!');
      setState(() {
        isConnected = false;
      });
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
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: kBoxDecoration,
          child: Center(
            child: isConnected
                ? kSpinkit
                : TryAgain(callBack: () {
                    checkConnection();
                  }),
          ),
        )),
      ),
    );
  }
}
