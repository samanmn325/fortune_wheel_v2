import 'package:flutter/material.dart';

/// the TryAgain is create to show TryAgain button when device disconnected
class TryAgain extends StatelessWidget {
  const TryAgain({Key? key, required this.callBack}) : super(key: key);
  final VoidCallback callBack;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: [
          const Text(
            'تلاش مجدد',
            style: TextStyle(fontSize: 15),
          ),
          IconButton(
            icon: const Icon(
              Icons.refresh,
              size: 40.0,
            ),
            onPressed: callBack,
          ),
        ],
      ),
      onTap: callBack,
    );
  }
}
