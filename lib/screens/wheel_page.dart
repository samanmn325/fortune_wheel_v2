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
import 'package:fortune_wheel_v2/my_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/my_alert_btn.dart';
import '../components/my_btn1.dart';
import '../components/my_social_btn.dart';
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
  int scorelimit = 500;
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
            print('selectedItem2 is :${selectedItem2}');
          });
        });
        if (selectedItem2 != null) {
          if (Brain.itemsIntList[selectedItem2!] > 0) {
            sum += Brain.itemsIntList[selectedItem2!];
            player.play('sounds/win2.wav', mode: PlayerMode.LOW_LATENCY);
            kToastWin("تبریک! شما برنده $sum امتیاز شدید");
            setState(() {
              point += sum;

              sum = 0;
            });
          } else {
            player.play('sounds/lose.wav', mode: PlayerMode.LOW_LATENCY);

            kToastLose('متاسفانه شما امتیازی کسب نکردید');
          }
          if (point >= scorelimit) {
            setState(() {
              point -= scorelimit.toInt();
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
          scorelimit = Brain.scorelimit;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _launchInWeb(String url) async {
    if (!await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $url';
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
          drawer: MyDrawer(),
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
                    borderRadius: BorderRadius.circular(200),
                  ),
                  color: kButtonColor,
                  child: SizedBox(
                    // height: MediaQuery.of(context).size.height * 0.42,
                    // width: MediaQuery.of(context).size.width * 0.86,
                    height:
                        MediaQuery.of(context).size.height > 330 ? 330 : 290,
                    width: MediaQuery.of(context).size.width > 330 ? 330 : 290,
                    child: FortuneWheel(
                      animateFirst: false,
                      selected: selected.stream,
                      duration: const Duration(milliseconds: 6500),
                      onAnimationStart: () {
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

                      /// todo:
                      // items: createItems(),
                      items: finalList,
                    ),
                  ),
                ),
                isConnected
                    ? (disable
                        ? MyBtn1(
                            mLable: 'چرخش',
                            mColor: Colors.blueGrey,
                            mPress: () {
                              kToast(
                                  'لطفا بعد از اتمام چرخش دوباره تلاش کنید!');
                            },
                          )
                        : MyBtn1(
                            mLable: 'چرخش',
                            mColor: disable ? Colors.blueGrey : kButtonColor,
                            mPress: () {
                              player.play('sounds/s2.wav',
                                  mode: PlayerMode.LOW_LATENCY);
                              setState(() {
                                selected.add(
                                  Fortune.randomInt(
                                      0, Brain.itemsIntList.length),
                                );
                              });
                            },
                          ))
                    : TryAgain(callBack: () {
                        wheelFunction();
                      }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MySocialBtn(
                      mIcon: FontAwesomeIcons.instagram,
                      mIconColor: Colors.redAccent,
                      mPress: () {
                        // _launchInWeb(instagramUrl);
                        try {
                          if (Brain.instagramUrl != '') {
                            setState(() {
                              point = point + Brain.instagramPoint;
                            });
                            kToastWin(
                                "تبریک ! شما امتیاز شبکه های اجتماعی دریافت کردید");
                            if (point >= scorelimit) {
                              setState(() {
                                point -= scorelimit.toInt();
                                starPoint += 1;
                              });
                              kToastWin("تبریک ! شما یک ستاره دریافت کردید");
                            }

                            _launchInWeb(Brain.instagramUrl);
                          } else {
                            kToast('متاسفانه اینستاگرام فعلا آدرس دهی نشده');
                          }
                        } catch (e) {
                          print(e);
                          kToast('متاسفانه اینستاگرام فعلا آدرس دهی نشده');
                        }
                      },
                    ),
                    MySocialBtn(
                      mIcon: FontAwesomeIcons.telegram,
                      mIconColor: Colors.blue,
                      mPress: () {
                        // _launchInWeb(telegramUrl);
                        try {
                          if (Brain.telegramUrl != '') {
                            setState(() {
                              point = point + Brain.telegramPoint;
                            });
                            kToastWin(
                                "تبریک ! شما امتیاز شبکه های اجتماعی دریافت کردید");
                            if (point >= scorelimit) {
                              setState(() {
                                point -= scorelimit.toInt();
                                starPoint += 1;
                              });
                              kToastWin("تبریک ! شما یک ستاره دریافت کردید");
                            }
                            _launchInWeb(Brain.telegramUrl);
                          } else {
                            kToast('متاسفانه تلگرام فعلا آدرس دهی نشده');
                          }
                        } catch (e) {
                          print(e);
                          kToast('متاسفانه تلگرام فعلا آدرس دهی نشده');
                        }
                      },
                    ),
                    MySocialBtn(
                      mIcon: FontAwesomeIcons.youtube,
                      mIconColor: Colors.red,
                      mPress: () {
                        // _launchInWeb(youTubeUrl);
                        try {
                          if (Brain.youtubeUrl != '') {
                            setState(() {
                              point = point + Brain.youtubePoint;
                            });
                            kToastWin(
                                "تبریک ! شما امتیاز شبکه های اجتماعی دریافت کردید");
                            if (point >= scorelimit) {
                              setState(() {
                                point -= scorelimit.toInt();
                                starPoint += 1;
                              });
                              kToastWin("تبریک ! شما یک ستاره دریافت کردید");
                            }
                            _launchInWeb(Brain.youtubeUrl);
                          } else {
                            kToast('متاسفانه یوتیوب فعلا آدرس دهی نشده');
                          }
                        } catch (e) {
                          print(e);
                          kToast('متاسفانه یوتیوب فعلا آدرس دهی نشده');
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
