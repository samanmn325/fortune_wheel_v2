import 'dart:convert';
import 'package:fortune_wheel_v2/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'models/user_model.dart';
import 'screens/welcome_page.dart';

/// test.
// const baseUrl = 'https://test.epicsite.ir/';
// const consumerKey = 'ck_e329b45d8c8360e6956d967a3baeb94362c6eefd';
// const consumerSecret = 'cs_99569f4006a3e936be9c6c0c22739dabf57d9e7e';
/// betashop.
const baseUrl = 'https://betashop.epicsite.ir/';
const consumerKey = 'ck_fde918323b48f9f6e8d5d41f8c4a71a1724c6829';
const consumerSecret = 'cs_d05f03b151b73373be1de9065747a406f394cb2b';

class Network {
  getUsersList() async {
    http.Response response = await http.get(
      Uri.parse('https://betashop.epicsite.ir/wp-json/wc/v3/products'),
      headers: <String, String>{
        'Authorization':
            'Basic Y2tfZmRlOTE4MzIzYjQ4ZjlmNmU4ZDVkNDFmOGM0YTcxYTE3MjRjNjgyOTpjc19kMDVmMDNiMTUxYjczMzczYmUxZGU5MDY1NzQ3YTQwNmYzOTRjYjJi'
      },
    );
    if (response.statusCode == 200) {
      var x = json.decode(utf8.decode(response.bodyBytes));
      var list = x;

      int t = 0;
      List<User> users = [];
      for (var i in list) {
        users.add(User(
            id: list[t]['id'],
            name: list[t]['name'],
            phoneNumber: list[t]['description'],
            rate: list[t]['price'],
            star: list[t]['short_description']));
        t++;
      }
      for (var temp in users) {
        if (temp.name == "youtube") {
          WelcomePage.youtubeUrl = kParseHtmlString(temp.phoneNumber!);
          print(WelcomePage.instagramUrl);
        } else if (temp.name == "telegram") {
          WelcomePage.telegramUrl = kParseHtmlString(temp.phoneNumber!);
        } else if (temp.name == "instagram") {
          WelcomePage.instagramUrl = kParseHtmlString(temp.phoneNumber!);
        }
      }
      WelcomePage.UserList = users;
      print("products are : ");
      print(users);
    } else {
      print(response.reasonPhrase);
    }
  }

  createUser({
    String? name,
    String? phoneNumber,
  }) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic Y2tfZmRlOTE4MzIzYjQ4ZjlmNmU4ZDVkNDFmOGM0YTcxYTE3MjRjNjgyOTpjc19kMDVmMDNiMTUxYjczMzczYmUxZGU5MDY1NzQ3YTQwNmYzOTRjYjJi'
      };
      var request = http.Request('POST',
          Uri.parse('https://betashop.epicsite.ir/wp-json/wc/v3/products'));
      request.body = json.encode({
        "name": name,
        "description": phoneNumber,
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e);
    }
  }

  getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _phone = prefs.getString('phone number');
    prefs.remove('id');
    if (_phone != null) {
      var long1 = double.parse(_phone);
      for (User temp in WelcomePage.UserList) {
        String a = kParseHtmlString(temp.phoneNumber!);
        var long2 = double.parse(a);
        print(long1);
        print(long2);
        if (long1 == long2) {
          prefs.setInt('id', temp.id!);
          int _id = prefs.getInt('id')!;
          String b = kParseHtmlString(temp.rate!);
          int _rate = int.parse(b);
          String d = kParseHtmlString(temp.star!);
          int _star = int.parse(d);
          // WelcomePage.user = User(
          //     id: _id,
          //     phoneNumber: _phone,
          //     star: _star.toString(),
          //     rate: _rate.toString());
        }
        return;
      }
    }
    return;
  }

  updateUser({required int id, String? rate, String? star}) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Basic Y2tfZmRlOTE4MzIzYjQ4ZjlmNmU4ZDVkNDFmOGM0YTcxYTE3MjRjNjgyOTpjc19kMDVmMDNiMTUxYjczMzczYmUxZGU5MDY1NzQ3YTQwNmYzOTRjYjJi'
    };
    var request = http.Request('PUT',
        Uri.parse('https://betashop.epicsite.ir/wp-json/wc/v3/products/$id'));
    request.body =
        json.encode({"short_description": rate, "regular_price": star});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}

  // getUser() async {
  //   var headers = {
  //     'Authorization':
  //         'Basic Y2tfZmRlOTE4MzIzYjQ4ZjlmNmU4ZDVkNDFmOGM0YTcxYTE3MjRjNjgyOTpjc19kMDVmMDNiMTUxYjczMzczYmUxZGU5MDY1NzQ3YTQwNmYzOTRjYjJi'
  //   };
  //   var request = http.Request('GET',
  //       Uri.parse('https://betashop.epicsite.ir/wp-json/wc/v3/products'));

  //   request.headers.addAll(headers);

  //   http.StreamedResponse response = await request.send();

  //   if (response.statusCode == 200) {
  //     print(await response.stream.bytesToString());
  //   } else {
  //     print(response.reasonPhrase);
  //   }
  // }