import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';

///The parseHtmlString is here for convert htmlString to String
String kParseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body!.text).documentElement!.text;
  return parsedString;
}

kToast(String massage) {
  Fluttertoast.showToast(
      msg: massage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blueGrey,
      textColor: Colors.black,
      fontSize: 16.0);
}

kToastWin(String massage) {
  Fluttertoast.showToast(
      msg: massage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 23, 145, 43),
      textColor: const Color.fromARGB(255, 255, 255, 255),
      fontSize: 16.0);
}

kToastLose(String massage) {
  Fluttertoast.showToast(
      msg: massage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 177, 47, 64),
      textColor: const Color.fromARGB(255, 255, 255, 255),
      fontSize: 16.0);
}

const kButtonTextStyle =
    TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white);

const kTextStyle =
    TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white);
const kPointTextStyle =
    TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white);
const kButtonColor = Color(0xFFF14D4C);
const kBoxDecoration = BoxDecoration(
  image: DecorationImage(
    image: AssetImage('assets/images/bg5.jpg'),
    fit: BoxFit.cover,
  ),
);

const kSpinkit = SpinKitDualRing(
  color: Color.fromARGB(255, 0, 0, 0),
  size: 80.0,
);
