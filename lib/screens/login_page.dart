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
import 'brain.dart';

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
  bool isConnected = false;
  bool disable = false;

  logInFunction() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        setState(() {
          isConnected = true;
          disable = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        try {
          if (phoneNumber.length == 11) {
            Network().getUserId(phoneNumber: phoneNumber);

            if (phoneNumber != '0' && name != '' && Brain.isSignedup == false) {
              Network().createUser(name: name, phoneNumber: phoneNumber);
              prefs.setString('phone number', phoneNumber);

              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Brain()));
              // Navigator.pushNamedAndRemoveUntil(
              //     context, WheelPage.routeName, (route) => false);
            } else if (Brain.isSignedup == true) {
              prefs.setString('phone number', phoneNumber);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Brain()));
              // Navigator.pushNamedAndRemoveUntil(
              //     context, WheelPage.routeName, (route) => false);
            }
          } else {
            kToast("لطفا نام و شماره تلفن خود را به درستی وارد کنید");
            setState(() {
              disable = false;
            });
          }
        } catch (e) {
          print(e);
          setState(() {
            disable = false;
          });
        }
      }
    } on SocketException catch (_) {
      print('not connected');
      kToast('اشکال در اتصال به اینترنت!');
      kToast('برای ورود باید به اینترنت متصل باشید!');
      setState(() {
        isConnected = false;
        disable = false;
      });
    }
  }

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
                  const SizedBox(
                    width: 30,
                  ),
                  MyAlertBtn(
                    mLabel: 'خیر',
                    mIcon: FontAwesomeIcons.xmark,
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
  void deactivate() {
    Brain.isSignedup = false;
    super.deactivate();
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
                child: isConnected
                    ? (disable
                        ? MyBtn1(
                            mLable: 'ورود',
                            mColor: Colors.blueGrey,
                            mPress: () {
                              kToast('لطفاً صبر کنید!');
                            },
                          )
                        : MyBtn1(
                            mLable: 'ورود',
                            mColor: kButtonColor,
                            mPress: logInFunction,
                          ))
                    : MyBtn1(
                        mLable: 'ورود',
                        mColor: kButtonColor,
                        mPress: logInFunction,
                      ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
