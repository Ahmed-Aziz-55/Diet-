import 'package:flutter/material.dart';
class Scroll extends StatefulWidget {
  const Scroll({super.key});

  @override
  State<Scroll> createState() => _ScrollState();
}

class _ScrollState extends State<Scroll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff444444),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          SizedBox(
            height:20,
          ),
          Center(child: Text('Welcome to',style: TextStyle(
              color: Colors.white,
              fontSize: 23),
          ),
          ),
          Center(child: Text('Calorigram',style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: 'DancingScript'),
          ),
          ),

              Center(
                    child: Image(
                      height: 60,
                        width: 60,
                        color: Colors.white,
                        image:
                        AssetImage('assets/apple.png'),
                  ),
              )
        ],
      )
    );
  }
}
