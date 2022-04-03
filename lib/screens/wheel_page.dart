import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fortune_wheel_v2/components/my_drawer.dart';
import 'package:fortune_wheel_v2/components/my_nav_bar.dart';
import 'package:fortune_wheel_v2/components/point_container.dart';
import 'package:fortune_wheel_v2/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/my_alert_btn.dart';
import '../components/my_btn1.dart';
import '../components/try_again.dart';
import '../components/wheel_items.dart';
import '../models/user_model.dart';
import '../network.dart';
import 'brain.dart';

class WheelPage extends StatefulWidget {
  const WheelPage({Key? key}) : super(key: key);
  static String routeName = '/wheel_page';
  @override
  State<WheelPage> createState() => _WheelPageState();
}

class _WheelPageState extends State<WheelPage> {
  StreamController<int> selected = StreamController<int>.broadcast();
  int sum = 0;
  int point = 0;
  int starPoint = 0;
  int? selectedItem2;
  bool isConnected = true;
  bool disable = false;

  final player = AudioCache();
  AudioPlayer player2 = AudioPlayer();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// wheelFunction run when animation ends up.
  wheelFunction() async {
    print("پایان");
    setState(() {
      disable = false;
    });
    // here we update rate to woocommerce(server)
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        setState(() {
          isConnected = true;
        });
        /////////////////////////////////////////////////////
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
          ///////////////////////////////////////////////////
          if (Brain.user.id != null) {
            print('شروع بروزرسانی');
            Network().updateUser(
                id: Brain.user.id!,
                rate: point.toString(),
                star: starPoint.toString());
          }

        } else {
          kToast('دوباره تلاش کنید');

        }
      }
    } on SocketException catch (_) {
      print('not connected');
      kToast("برای ثبت امتیاز باید به اینترنت متصل باشید!");
      setState(() {
        isConnected = false;
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

  getInfo() async {
    try {
      if (Brain.user.star != '') {
        String? rate2 = Brain.user.star;
        String? star2 = Brain.user.rate;
        int r = int.parse(rate2!, onError: (source) => 0);
        int s = int.parse(star2!, onError: (source) => 0);
        setState(() {
          point = r;
          starPoint = s;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    selected.stream.listen((event) {
      setState(() {
        selectedItem2 = event;
      });
    });
    super.initState();
    getInfo();
  }

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }
  @override
  void deactivate() {
    Brain.user = User();
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
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          drawer: const MyDrawer(),
          body: Container(
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
                    child: FortuneWheel(
                        animateFirst: false,
                        selected: selected.stream,
                        duration: const Duration(milliseconds: 6500),
                        onAnimationStart: (){
                          setState(() {
                            disable = true;
                          });
                        },
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
                isConnected
                    ? (disable ? MyBtn1(
                  mLable: 'چرخش',
                  mColor: Colors.blueGrey,
                  mPress: () {
                    kToast('لطفا بعد از اتمام چرخش دوبازه تلاش کنید!');
                  },
                ): MyBtn1(
                  mLable: 'چرخش',
                  mColor: disable ? Colors.blueGrey:kButtonColor,
                  mPress: () {
                    player.play('sounds/s2.wav',
                        mode: PlayerMode.LOW_LATENCY);
                    setState(() {
                      selected.add(
                        Fortune.randomInt(0, 8),
                      );

                    });
                  },
                ))
                    : TryAgain(callBack: () {
                        wheelFunction();
                      }),
                const MyNavBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
