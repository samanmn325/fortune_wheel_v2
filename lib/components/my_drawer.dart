import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
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
          const DrawerHeader(
            decoration: BoxDecoration(
              color: kButtonColor,
            ),
            child: Center(
              child: Text(
                'چرخ شانس',
                style: kButtonTextStyle,
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
                    mIcon: FontAwesomeIcons.multiply,
                    mColor: Colors.red,
                    mPress: () {
                      Navigator.of(context).pop(false);
                    },
                  )
                ],
              ),
            ],
          ),
          const ExpansionTile(
            title: Text(
              'ارتباط با ما',
              style: TextStyle(fontSize: 18),
            ),
            leading: Icon(FontAwesomeIcons.message),
            children: <Widget>[
              Align(
                child: Text(' ایمیل :  example@gmail.com  '),
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 5.0,
              ),
              Divider(
                endIndent: 30,
                indent: 30,
                height: 1,
                thickness: 1,
              ),
              Align(
                child: Text(' شماره تماس :  09124589652'),
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 5.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
