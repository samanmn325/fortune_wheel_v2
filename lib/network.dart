import 'dart:convert';
import 'dart:math';

import '../constants.dart';
import '../screens/brain.dart';
import 'package:http/http.dart' as http;

import 'models/user_model.dart';

/// inforgram.
const baseUrl = 'https://inforgram.ir/';
const consumerKey = 'ck_94b2fcdd11cdb0248e588519df54690e6ae7d29e';
const consumerSecret = 'cs_8551f878f795370bc7b186bfce958e4a219f2ec3';
const token =
    'Basic Y2tfOTRiMmZjZGQxMWNkYjAyNDhlNTg4NTE5ZGY1NDY5MGU2YWU3ZDI5ZTpjc184NTUxZjg3OGY3OTUzNzBiYzdiMTg2YmZjZTk1OGU0YTIxOWYyZWMz';

class Network {
  /// . get Users List ///////////////////////////////////////////////////////////////////

  getUsersList() async {
    http.Response response = await http.get(
      Uri.parse(baseUrl + 'wp-json/wc/v3/products'),
      headers: <String, String>{'Authorization': token},
    );
    if (response.statusCode == 200) {
      var x = json.decode(utf8.decode(response.bodyBytes));
      var list = x;

      int t = 0;
      List<User> users = [];

      /// this for's block is for add users to list

      for (var i in list) {
        users.add(User(
            id: list[t]['id'],
            name: list[t]['name'],
            phoneNumber: list[t]['description'],
            rate: list[t]['price'],
            star: list[t]['short_description']));
        t++;
      }

      /// this for's block is for add social link
      for (var temp in users) {
        if (temp.name == "youtube") {
          Brain.youtubeUrl = kParseHtmlString(temp.phoneNumber!);
          Brain.youtubePoint =
              int.parse(kParseHtmlString(temp.star!), onError: (source) => 10);

          print('youtube Url is :${Brain.youtubeUrl}');
        } else if (temp.name == "telegram") {
          Brain.telegramUrl = kParseHtmlString(temp.phoneNumber!);
          Brain.telegramPoint =
              int.parse(kParseHtmlString(temp.star!), onError: (source) => 10);
          print('telegram Url is :${Brain.telegramUrl}');
        } else if (temp.name == "instagram") {
          Brain.instagramUrl = kParseHtmlString(temp.phoneNumber!);
          Brain.instagramPoint =
              int.parse(kParseHtmlString(temp.star!), onError: (source) => 10);
          print('instagram Url is :${Brain.instagramUrl}');
        } else if (temp.name == "scorelimit") {
          var sl = kParseHtmlString(temp.phoneNumber!);
          Brain.scorelimit = int.parse(sl, onError: (source) => 500);
          print('score limit is: ${Brain.scorelimit}');
        } else if (temp.name == "contactUs") {
          Brain.connectUs = kParseHtmlString(temp.phoneNumber!);
          print('connect us message is: ${Brain.connectUs}');
        }
      }
      Brain.UserList = users;
      // print("products are : ${users}");
    } else {
      print(response.reasonPhrase);
    }
  }

  /// . create User ///////////////////////////////////////////////////////////////////

  createUser({
    String? name,
    String? phoneNumber,
  }) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': token
      };
      var request =
          http.Request('POST', Uri.parse(baseUrl + 'wp-json/wc/v3/products'));
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

  /// . get User ///////////////////////////////////////////////////////////////////
  getUserId({String? phoneNumber}) async {
    if (phoneNumber != null) {
      double num1 = double.parse(phoneNumber);
      for (User tempUser in Brain.UserList) {
        String charNum1 = kParseHtmlString(tempUser.phoneNumber!);

        /// replaceAll() is for remove all whitespaces
        charNum1 = charNum1.replaceAll(RegExp(r"\s+"), "");
        if (charNum1.length == 11) {
          print('اینجا');
          double num2 = double.parse(charNum1);
          if (num1 == num2) {
            String tempName = kParseHtmlString(tempUser.name!);
            String tempRate = kParseHtmlString(tempUser.rate!);
            String tempStar = kParseHtmlString(tempUser.star!);
            tempRate = tempRate.replaceAll(RegExp(r"\s+"), "");
            // int _rate = int.parse(tempRate);
            tempStar = tempStar.replaceAll(RegExp(r"\s+"), "");
            // int _star = int.parse(tempStar);
            Brain.user = User(
                id: tempUser.id!,
                name: tempName,
                phoneNumber: phoneNumber,
                star: tempStar,
                rate: tempRate);

            print(Brain.user);
            Brain.isSignedup = true;
          }
        }
      }
    }
  }

  /// . update User ///////////////////////////////////////////////////////////////////
  updateUser({required int id, String? rate, String? star}) async {
    print("id is $id");
    var headers = {'Content-Type': 'application/json', 'Authorization': token};
    var request =
        http.Request('PUT', Uri.parse(baseUrl + 'wp-json/wc/v3/products/$id'));
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

  /// . get items numbre ///////////////////////////////////////////////////////////////////
  getItemsList() async {
    try {
      http.Response response = await http.get(
        Uri.parse(baseUrl + 'wp-json/wc/v3/products/categories'),
        headers: <String, String>{'Authorization': token},
      );

      if (response.statusCode == 200) {
        var x = json.decode(utf8.decode(response.bodyBytes));
        var list2 = x;

        /// this for's block is for add Items to list
        List<String> myList = [];
        for (var it in list2) {
          if (isNumeric(it['name'])) {
            myList.add(it['name']);
          }
        }

        myList = shuffle(myList);
        print("list2 is : $myList");

        List<String> myList3 = myList.toSet().toList();
        for (int i = 0; i < myList3.length; i++) {
          if (i < 10) {
            int m = int.parse(myList3[i], onError: (source) => 0);
            Brain.itemsIntList.add(m);
          }
        }

        print('itrms are : ${Brain.itemsIntList}');
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e);
    }
  }

  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  //
  List<String> shuffle(List<String> items) {
    var random = new Random();

    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }
}
