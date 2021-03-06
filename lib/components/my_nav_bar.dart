import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fortune_wheel_v2/constants.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../my_provider.dart';
import '../screens/brain.dart';
import 'my_social_btn.dart';

class MyNavBar extends StatelessWidget {
  const MyNavBar({Key? key}) : super(key: key);
  final String instagramUrl = 'https://instagram.com/';
  final String youTubeUrl = 'https://youtube.com/';
  final String telegramUrl = 'https://telegram.com/';
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
  Widget build(BuildContext context) {
    return Consumer<MyProvider>(
      builder: (context, data, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MySocialBtn(
              mIcon: FontAwesomeIcons.instagram,
              mIconColor: Colors.redAccent,
              mPress: () {
                // _launchInWeb(instagramUrl);
                try {
                  if (Brain.instagramUrl != '') {
                    data.setPoint(Brain.instagramPoint);
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
                    data.setPoint(Brain.telegramPoint);

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
                    data.setPoint(Brain.youtubePoint);

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
        );
      },
    );
  }
}
