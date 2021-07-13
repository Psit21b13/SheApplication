import 'dart:async';

import 'package:flutter/material.dart';
import 'package:womenCare/screens/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:womenCare/services/firebaseAuthService.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer _timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer(Duration(seconds: 3), () async {
      try {
        AuthenticationService.prefs = await SharedPreferences.getInstance();
        !AuthenticationService.prefs.getBool('login_status')
            ? Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginPage()))
            : Navigator.pushReplacementNamed(context, '/pageselect');
      } catch (e) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Hero(
        tag: 'mainLogo-tag',
        child: Container(
          height: 350,
          width: 350,
          child: Image.asset(
            "images/mainLogo.png",
            fit: BoxFit.cover,
          ),
        ),
      )),
    );
  }
}
