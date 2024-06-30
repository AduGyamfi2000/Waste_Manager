import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flag/flag_enum.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

import '../main.dart';
import 'login.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  WelcomePageState createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 15), () {
      if (FirebaseAuth.instance.currentUser == null) {
        Navigator.of(context).push(PageTransition(
            child: const LoginPage(),
            type: PageTransitionType.leftToRight,
            ctx: context,
            inheritTheme: true));
      } else {
        Navigator.of(context).pushReplacement(PageTransition(
            child: const MyApp(),
            type: PageTransitionType.fade,
            ctx: context,
            inheritTheme: true));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          const Center(
              child: Text(
            "E-Recycler",
            textScaleFactor: 2.0,
            style: TextStyle(
                color: Colors.green, fontWeight: FontWeight.bold, fontSize: 36),
          )),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              height: 200, // adjust the height to your liking
              width: 200, // adjust the width to your liking
              child: Icon(
                Icons.delete_outline, // bin icon
                size: 100, // adjust the size to your liking
                color: Colors.green, // adjust the color to your liking
              ),
            ),
          ),
          const SizedBox(
            height: 220,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Made in Ghana",
                  textScaleFactor: 1.2,
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 24)),
              const SizedBox(
                width: 10,
              ),
              Flag.fromCode(
                FlagsCode.IN,
                height: 15,
                width: 20,
                fit: BoxFit.fill,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
