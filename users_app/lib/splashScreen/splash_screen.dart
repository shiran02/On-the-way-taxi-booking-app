import 'dart:async';

import 'package:flutter/material.dart';

import '../appConstants/app_colors.dart';
import '../assistants/assistant_methods.dart';
import '../authentication/login_screen.dart';
import '../global/global.dart';
import '../mainScreen/main_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
    fAuth.currentUser != null  ? AssistantMethods.readCurrentUserOnLineUserInfo(): null; 

    Timer(const Duration(seconds: 3), () async {
      //send user to home screen

      //   Navigator.pushReplacement(
      // context,
      // MaterialPageRoute(
      //     builder: (BuildContext context) => MainScreen()));

      if (await fAuth.currentUser != null) {
        currentFirebaseUer = fAuth.currentUser;

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: AppColors.darkGreen,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/splach_back_image.png"),
            ],
          ),
        ),
      ),
    );
  }
}
