import 'package:flutter/material.dart';

class SwipeIndicator extends StatelessWidget {
  const SwipeIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
