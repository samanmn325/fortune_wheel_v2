import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:fortune_wheel_v2/screens/login_page.dart';
import 'package:fortune_wheel_v2/screens/welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/my_btn1.dart';
import '../components/my_alert_btn.dart';
import '../components/my_drawer.dart';
import '../components/my_nav_bar.dart';
import '../components/point_container.dart';
import '../components/wheel_items.dart';
import '../constants.dart';
import '../network.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);
  static String routeName = "/my_home_page";
  static int? selectedItem;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamController<int> selected = StreamController<int>.broadcast();
  int sum = 0;
  int point = 0;
  int starPoint = 0;
  int? selectedItem2;
  final player = AudioCache();
  AudioPlayer player2 = AudioPlayer();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
// wheelFunction is fortune wheel function
  wheelFunction() async {
    print("پایان");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selected.stream.listen((event) {
      setState(() {
        selectedItem2 = event;
      });
    });
    if (selectedItem2 != null) {
      if (selectedItem2 == 0 ||
          selectedItem2 == 3 ||
          selectedItem2 == 6 ||
          selectedItem2 == 9) {
        sum += 100;
        player.play('sounds/win2.wav', mode: PlayerMode.LOW_LATENCY);

        kToastWin("تبریک! شما برنده 100 امتیاز شدید");
        setState(() {
          point += sum;
          sum = 0;
        });
      } else if (selectedItem2 == 1 ||
          selectedItem2 == 4 ||
          selectedItem2 == 7 ||
          selectedItem2 == 10) {
        player.play('sounds/lose.wav', mode: PlayerMode.LOW_LATENCY);

        kToastLose('متاسفانه شما امتیازی کسب نکردید');
      } else if (selectedItem2 == 2 ||
          selectedItem2 == 5 ||
          selectedItem2 == 8 ||
          selectedItem2 == 11) {
        sum += 10;
        player.play('sounds/win2.wav', mode: PlayerMode.LOW_LATENCY);

        kToastWin("تبریک ! شما برنده 10 امتیاز شدید");
        setState(() {
          point += sum;
          sum = 0;
        });
      }
      if (point >= 200) {
        setState(() {
          point -= 200;
          starPoint += 1;
          kToastWin("تبریک ! شما یک ستاره دریافت کردید");
        });
      }
      // here we update rate to woocommerce(server)
      int? id = prefs.getInt('id');
      if (id != null) {
        print('شروع بروزرسانی');
        Network().updateUser(
            id: id, rate: point.toString(), star: starPoint.toString());
      }
    } else {
      kToast('دوباره تلاش کنید');
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

  getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phoneNumber1 = prefs.getString('phone number');
    print(phoneNumber1);
    // if (phoneNumber1 != null) {
    //   var long1 = double.parse(phoneNumber1);
    //   for (var temp in WelcomePage.UserList) {
    //     String a = kParseHtmlString(temp.phoneNumber!);
    //     var long2 = double.parse(a);
    //     if (long1 == long2) {
    //       prefs.setInt('id', temp.id!);
    //       String b = kParseHtmlString(temp.rate!);
    //       int c = int.parse(b);
    //       String d = kParseHtmlString(temp.star!);
    //       int e = int.parse(d);
    //       setState(() {
    //         point = c;
    //         print(point);
    //         starPoint = e;
    //         print(starPoint);
    //       });
    //     }
    //   }
    // }
  }

  @override
  void initState() {
    getInfo();
    selected.stream.listen((event) {
      setState(() {
        selectedItem2 = event;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    selected.close();
    super.dispose();
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
        key: _scaffoldKey,
        drawer: const MyDrawer(),
        body: SafeArea(
          child: Container(
            decoration: kBoxDecoration,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// point container
                PointContainer(
                    starPoint: starPoint,
                    point: point,
                    scaffoldKey: _scaffoldKey),

                /// fortune wheel container
                Card(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.red, width: 10),
                    borderRadius: BorderRadius.circular(500),
                  ),
                  color: kButtonColor,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.42,
                    width: MediaQuery.of(context).size.width * 0.86,
                    // height: MediaQuery.of(context).size.height * 0.42,
                    // width: MediaQuery.of(context).size.width * 0.86,
                    // decoration: BoxDecoration(
                    //   border: Border.all(color: kButtonColor, width: 15),
                    //   borderRadius:
                    //       const BorderRadius.all(Radius.circular(500.0)),
                    // ),
                    child: FortuneWheel(
                        animateFirst: false,
                        selected: selected.stream,
                        duration: const Duration(milliseconds: 6500),
                        onAnimationEnd: wheelFunction,
                        indicators: const <FortuneIndicator>[
                          FortuneIndicator(
                            alignment: Alignment.topCenter,
                            child: TriangleIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ],
                        items: items2),
                  ),
                ),
                MyBtn1(
                  mLable: 'چرخش',
                  mColor: kButtonColor,
                  mPress: () {
                    player.play('sounds/s2.wav', mode: PlayerMode.LOW_LATENCY);
                    setState(() {
                      selected.add(
                        Fortune.randomInt(0, 8),
                      );
                    });
                  },
                ),
                MyNavBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
