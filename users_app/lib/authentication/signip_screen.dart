
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:users_app/splashScreen/splash_screen.dart';

import '../appConstants/app_colors.dart';
import '../global/global.dart';
import '../widgets/progress_dialog.dart';
import '../widgets/text_widget.dart';
import 'login_screen.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm() {
    if (nameTextEditingController.text.length < 3) {
      Fluttertoast.showToast(msg: "name must be atleast 3 character");
    }
    if (!emailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "email is not valide");
    }
    if (phoneTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Phone number is required");
    } else if (passwordTextEditingController.text.length < 3) {
      Fluttertoast.showToast(msg: "password must be atleast 3 character");
    } else {
      saveUserInfoNow();
    }
  }

  saveUserInfoNow() async {  
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(message: "Processing ,Please wait");
        });

    final User? firebaseUser = (await fAuth
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text.trim(),
                password: passwordTextEditingController.text.trim())
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error :" + msg.toString());
    }))
        .user;

    if (firebaseUser != null) {
      Map userMap = {
        "id": firebaseUser.uid,
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      DatabaseReference driverRef =
          FirebaseDatabase.instance.ref().child("users");
      driverRef.child(firebaseUser.uid).set(userMap);

      currentFirebaseUer = firebaseUser;
        Fluttertoast.showToast(msg: "Account has  been Created .");
      Navigator.push(
          context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Account has not been Created .");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGreen,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                //    color: AppColors.darkGreen,
                width: Get.width,
                height: Get.height * 0.4,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("images/registerback.png"),
                      alignment: Alignment.topCenter),
                ),
              ),
              Container(
                color: AppColors.darkGreen,
                width: Get.width,
                height: Get.height * 0.6,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    MyTextField(
                        hintText: "Enter Name",
                        label: "Name",
                        textController: nameTextEditingController,
                        finaleType: TextInputType.name,
                        fontColor: AppColors.lightBlue
                        ),
                    MyTextField(
                        hintText: "Enter Email",
                        label: "Email",
                        textController: emailTextEditingController,
                        finaleType: TextInputType.emailAddress,
                        fontColor: AppColors.lightBlue),
                    MyTextField(
                        hintText: "Enter Phone",
                        label: "Phone",
                        textController: phoneTextEditingController,
                        finaleType: TextInputType.phone,
                        fontColor: AppColors.lightBlue),
                    MyTextField(
                        hintText: "Enter Password",
                        label: "Password",
                        textController: passwordTextEditingController,
                        finaleType: TextInputType.name, 
                        fontColor: AppColors.lightBlue),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          validateForm();
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (c) => const CarInfoScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                            primary: AppColors.lightBlue),
                        child: const Text(
                          "Create Account",
                          style: TextStyle(
                              color: AppColors.darkGreen, fontSize: 18),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => const LoginScreen()));
                        },
                        child: Text(
                          "Already  an account ? Login",
                          style: TextStyle(
                              color: AppColors.lightBlue,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
