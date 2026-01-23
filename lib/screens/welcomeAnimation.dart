import 'package:diet/screens/scroll.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Welcomeanimation extends StatefulWidget {
  const Welcomeanimation({super.key});

  @override
  State<Welcomeanimation> createState() => _WelcomeanimationState();
}

class _WelcomeanimationState extends State<Welcomeanimation> {
  bool showButton=false;
  @override
  void initState() {
    super.initState();

    // 2 second ke baad next screen par navigate
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Scroll()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff444444),
      body: 
        Center(
          child: Container(
            height: 350,
              width: double.infinity,
              child: Center(child: Lottie.asset('assets/Food animation.json'))),
        ),

    );
  }
}