import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swaysafeguardapp/Screens/home_screen.dart';
import 'package:swaysafeguardapp/Screens/user_main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {



  @override
  void initState(){
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });


  }




  @override
  Widget build(BuildContext context) {
    final _height= MediaQuery.sizeOf(context).height*1;
    final _width= MediaQuery.sizeOf(context).width*1;
    return  Scaffold(
      body: Container(
        child: Column(
          children: [


            Image.asset('assets/images/splashscreen.PNG',
              fit: BoxFit.cover,
              height: _height,
              width: _width,
            ),



          ],
        ),
      ),
    );
  }
}
