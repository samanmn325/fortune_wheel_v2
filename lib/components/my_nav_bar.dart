import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fortune_wheel_v2/constants.dart';
import 'package:fortune_wheel_v2/screens/welcome_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/brain.dart';
import 'my_social_btn.dart';

class MyNavBar extends StatelessWidget {
  const MyNavBar({Key? key}) : super(key: key);
  final String instagramUrl =
      'https://instagram.com/sobisadeghi?utm_medium=copy_link';
  final String youTubeUrl =
      'https://instagram.com/sobisadeghi?utm_medium=copy_link';
  final String telegramUrl =
      'https://instagram.com/sobisadeghi?utm_medium=copy_link';
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
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MySocialBtn(
            mIcon: FontAwesomeIcons.instagram,
            mIconColor: Colors.redAccent,
            mPress: () {
              // _launchInWeb(instagramUrl);
              if (Brain.instagramUrl != '') {
                _launchInWeb(Brain.instagramUrl);
              } else {
                kToast('متاسفانه اینستاگرام فعلا آدرس دهی نشده');
              }
            },
          ),
          MySocialBtn(
            mIcon: FontAwesomeIcons.telegram,
            mIconColor: Colors.blue,
            mPress: () {
              // _launchInWeb(telegramUrl);
              if (Brain.telegramUrl != '') {
                _launchInWeb(Brain.telegramUrl);
              } else {
                kToast('متاسفانه تلگرام فعلا آدرس دهی نشده');
              }
            },
          ),
          MySocialBtn(
            mIcon: FontAwesomeIcons.youtube,
            mIconColor: Colors.red,
            mPress: () {
              // _launchInWeb(youTubeUrl);
              if (Brain.youtubeUrl != '') {
                _launchInWeb(Brain.youtubeUrl);
              } else {
                kToast('متاسفانه یوتیوب فعلا آدرس دهی نشده');
              }
            },
          ),
        ],
      ),
    );
  }
}
