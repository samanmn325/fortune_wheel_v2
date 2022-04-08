import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fortune_wheel_v2/my_provider.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class PointContainer extends StatelessWidget {
  const PointContainer({
    Key? key,
    required this.starPoint,
    required this.point,
    required GlobalKey<ScaffoldState> scaffoldKey,
  })  : _scaffoldKey = scaffoldKey,
        super(key: key);

  final int starPoint;
  final int point;
  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Consumer<MyProvider>(builder: (context, data, child) {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(
              10,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.45,
              decoration: BoxDecoration(
                color: kButtonColor,
                border: Border.all(color: kButtonColor, width: 5),
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 30,
                        child: Icon(
                          FontAwesomeIcons.solidStar,
                          color: Colors.amber.shade300,
                        ),
                      ),
                      Text(' : $starPoint',
                          style: const TextStyle(
                              fontSize: 20.0, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const Text(
                        "امتیاز : ",
                        style: kTextStyle,
                      ),
                      Text('$point',
                          style: const TextStyle(
                              fontSize: 20.0, color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                decoration: BoxDecoration(
                  color: kButtonColor,
                  border: Border.all(color: kButtonColor, width: 5),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                ),
                child: IconButton(
                    onPressed: () {
                      _scaffoldKey.currentState!.openDrawer();
                    },
                    icon: const Icon(FontAwesomeIcons.list,
                        color: Colors.white))),
          )
        ],
      );
    });
  }
}
