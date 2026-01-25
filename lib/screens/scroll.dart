import 'dart:async';

import 'package:diet/screens/gender_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Scroll extends StatefulWidget {
  const Scroll({super.key});

  @override
  State<Scroll> createState() => _ScrollState();
}

class _ScrollState extends State<Scroll> {
  bool showButton = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        showButton = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff444444),
        body: SafeArea(
      child: Center(
        child: Container(
        color: const Color(0xff444444),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 40),

            Text(
              'Welcome to',
              style: TextStyle(color: Colors.white, fontSize: 27),
            ),
            Text(
              'Calorigram',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'DancingScript',
              ),
            ),

            const SizedBox(height: 200),

            const Image(
              height: 100,
              width: 100,
              color: Colors.white,
              image: AssetImage('assets/apple.png'),
            ),
            const Spacer(),

            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: showButton
                  ? InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>GenderPage(userId: 'userId')));
                },
                child: Container(
                  height: 45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.green,
                  ),
                  child: const Center(
                    child: Text(
                      'Continue',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              )
                  : Lottie.asset(
                'assets/Loading Dots Blue.json',
              ),
            ),
          ],
        ),
            ),
      ),
    ),

    ),
    );
  }
}

