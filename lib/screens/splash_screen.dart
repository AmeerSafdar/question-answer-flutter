import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instaclone/Responsive/SizeConfig.dart';
import 'package:instaclone/initial_root/initial_root.dart';
import 'package:instaclone/screens/login_screen.dart';
import 'package:instaclone/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return initScreen(context);
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = Duration(seconds: 5);
    return new Timer(duration, route);
  }

  route() {
    // Navigator.pushReplacement(context, MaterialPageRoute(
    //     builder: (context) => LoginScreen()
    //   )
    // );
    Get.offAll(InitialRoot(), //  LoginScreen(),
        transition: Transition.rightToLeftWithFade);
  }

  initScreen(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Image.asset(
            "assets/images/1.png",
            color: primaryColor,
            height: SizeConfig.heightMultiplier * 20,
            width: SizeConfig.widthMultiplier * 40,
          ),
        ),
      ),
    );
  }
}
