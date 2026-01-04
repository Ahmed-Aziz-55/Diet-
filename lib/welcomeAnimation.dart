import 'package:diet/scroll.dart';
import 'package:flutter/material.dart';

class Welcomeanimation extends StatefulWidget {
  const Welcomeanimation({super.key});

  @override
  State<Welcomeanimation> createState() => _WelcomeanimationState();
}

class _WelcomeanimationState extends State<Welcomeanimation> {
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/animation.jpg'),
            fit: BoxFit.cover, // Full screen cover
          ),
        ),
      ),
    );
  }
}