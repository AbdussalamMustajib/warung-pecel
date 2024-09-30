import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '1_login.dart';
import 'main_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  checkConnectivity() async {
    var pref = await SharedPreferences.getInstance();
    var login = pref.getBool("login");
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      _showMyDialog("Internet Connection None");
    } else {
      Timer(const Duration(seconds: 5), () {
        login == true
            ? Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainPage()),
              )
            : Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
      });
    }
  }

  Future<void> _showMyDialog(String pesan) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(pesan),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SplashScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          "assets/splash-screen.svg",
          width: width * 0.6,
        ),
      ),
    );
  }
}
