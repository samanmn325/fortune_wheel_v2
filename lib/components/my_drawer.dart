import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../screens/brain.dart';
import '../screens/login_page.dart';
import 'my_alert_btn.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: kButtonColor,
            ),
            child: Center(
              child: Column(
                children: const [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Image(
                      image: AssetImage('assets/images/logo3.png'),
                    ),
                  ),
                  Text(
                    'HIT',
                    style: kButtonTextStyle,
                  ),
                ],
              ),
            ),
          ),
          ExpansionTile(
            leading: const Icon(FontAwesomeIcons.leftLong),
            title: const Text('خروج از حساب کاربری',
                style: TextStyle(fontSize: 18)),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyAlertBtn(
                    mLabel: 'بله',
                    mIcon: FontAwesomeIcons.check,
                    mColor: Colors.green,
                    mPress: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.remove('phone number');
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginPage.routeName, (route) => false);
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
          ),
          ExpansionTile(
            title: const Text(
              'ارتباط با ما',
              style: TextStyle(fontSize: 18),
            ),
            leading: const Icon(FontAwesomeIcons.message),
            children: <Widget>[
              Align(
                child: Text(Brain.connectUs),
                alignment: Alignment.center,
              ),
              const SizedBox(
                height: 5.0,
              ),
              const Divider(
                endIndent: 30,
                indent: 30,
                height: 1,
                thickness: 1,
              ),
              const SizedBox(
                height: 5.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
