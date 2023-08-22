import 'package:flutter/cupertino.dart';

// ignore: must_be_immutable
class TextWidget extends StatelessWidget {
  final text1st;
  bool colorCheck;

  TextWidget({
    super.key,
    required this.text1st,
    this.colorCheck = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          text1st,
          style: TextStyle(
              color: colorCheck
                  ? Color.fromARGB(255, 28, 129, 212)
                  : Color(0xFF6D6D6D)),
        ),
      ],
    );
  }
}
