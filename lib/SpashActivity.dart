import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kosh/MainActivity.dart';
import 'package:kosh/SignUpActivity.dart';

class SplashActivity extends StatefulWidget {
  const SplashActivity({super.key});

  @override
  State<SplashActivity> createState() => _SplashActivityState();
}

class _SplashActivityState extends State<SplashActivity> {

  @override
  void initState() {
    super.initState();

    if(FirebaseAuth.instance.currentUser!=null){
      Timer(
          const Duration(seconds: 2),
              () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const MainActivity())));
    }
    else{

      Timer(
          const Duration(seconds: 2),
              () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const SignUpActivity())));
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xff3067A7),
        child: Center(


          child: Image.asset("assets/images/splashimage.png",height: 150,width: 150),
        ),
      ),
    );
  }
}
