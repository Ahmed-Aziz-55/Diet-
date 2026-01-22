import 'dart:async';

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

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        showButton = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff444444),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),

          const Center(
            child: Text(
              'Welcome to',
              style: TextStyle(color: Colors.white, fontSize: 23),
            ),
          ),

          const Center(
            child: Text(
              'Calorigram',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'DancingScript',
              ),
            ),
          ),

          const SizedBox(height: 100),

          const Center(
            child: Image(
              height: 70,
              width: 70,
              color: Colors.white,
              image: AssetImage('assets/apple.png'),
            ),
          ),
          SizedBox(height: 100),
          showButton
              ? InkWell(
            onTap: (){},
                child: Container(
                            height: 30,
                            width: 100,
                            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.green,

                            ),
                            child: Center(child: Text('Continue')),
                          ),
              )
              : Lottie.asset('assets/Loading Dots Blue.json'),
        ],
      ),
    );
  }
}

