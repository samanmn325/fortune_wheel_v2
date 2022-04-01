import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fortune_wheel_v2/components/try_again.dart';
import 'package:fortune_wheel_v2/constants.dart';

import '../models/user_model.dart';

class Brain extends StatefulWidget {
  const Brain({Key? key}) : super(key: key);
  static List<User> UserList = [];
  static late String telegramUrl;
  static late String youtubeUrl;
  static late String instagramUrl;
  static late User user;
  static late bool isSignedup;
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
    return Scaffold(
      body: SafeArea(
          child: Container(
        decoration: kBoxDecoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: isConnected
                  ? kSpinkit
                  : TryAgain(callBack: () {
                      checkConnection();
                    }),
            ),
          ],
        ),
      )),
    );
  }
}
