import 'package:flutter/material.dart';

class EmotionText extends StatelessWidget {
  final String emotion;

  const EmotionText({Key? key, required this.emotion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      emotion,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}

