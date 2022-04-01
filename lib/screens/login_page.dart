import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/logo_container.dart';
import '../components/my_alert_btn.dart';
import '../components/my_btn1.dart';
import '../constants.dart';
import '../network.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static String routeName = '/login_page';
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _phoneTextEditingController =
      TextEditingController();

  String phoneNumber = '0';
  String name = '';
  int isSignedup = 0;

  /// The onBackPressed is for Restrict Android backButton
  Future<bool?> onBackPressed() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('آیا میخواید از برنامه خارج شوید؟'),
            // content: Text('برای خروج از برنامه دکمه بستن را بزنید.'),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyAlertBtn(
                    mLabel: 'بله',
                    mIcon: FontAwesomeIcons.check,
                    mColor: Colors.green,
                    mPress: () {
                      exit(0);
                    },
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  MyAlertBtn(
                    mLabel: 'خیر',
                    mIcon: FontAwesomeIcons.multiply,
                    mColor: Colors.red,
                    mPress: () {
                      Navigator.of(context).pop(false);
                    },
                  )
                ],
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? result = await onBackPressed();
        result ??= false;
        return result;
      },
      child: Scaffold(
          body: SafeArea(
        child: Container(
          decoration: kBoxDecoration,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const LogoContainer(),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                      keyboardType: TextInputType.name,
                      controller: _nameTextEditingController,
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        counterStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Iransans',
                        ),
                        border: InputBorder.none,
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Iransans',
                        ),
                        label: Text(
                          "نام :",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Iransans',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          phoneNumber = value;
                        });
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(11),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.phone,
                      controller: _phoneTextEditingController,
                      textDirection: TextDirection.ltr,
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelStyle: TextStyle(
                            color: Colors.white, fontFamily: 'Iransans'),
                        label: Text("شماره تلفن همراه :",
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Iransans')),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: MyBtn1(
                  mLable: 'ورود',
                  mColor: kButtonColor,
                  mPress: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    try {
                      if (phoneNumber != '0' && name != '' && isSignedup == 0) {
                        Network()
                            .createUser(name: name, phoneNumber: phoneNumber);
                        prefs.setString('phone number', phoneNumber);
                        Navigator.pushNamedAndRemoveUntil(
                            context, HomePage.routeName, (route) => false);
                      } else if (isSignedup == 1) {
                        prefs.setString('phone number', phoneNumber);
                        Navigator.pushNamedAndRemoveUntil(
                            context, HomePage.routeName, (route) => false);
                      } else {
                        kToast(
                            "لطفا نام و شماره تلفن خود را به درستی وارد کنید");
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
