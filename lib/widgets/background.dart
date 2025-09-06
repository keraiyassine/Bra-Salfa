import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          child: Image.asset("assets/img/question-mark.png", fit: BoxFit.cover),
        ),
        Container(
          height: double.infinity,
          width: double.infinity,
          color: const Color.fromARGB(219, 21, 31, 35),
        ),
      ],
    );
  }
}
