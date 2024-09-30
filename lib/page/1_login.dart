import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pecel_pincuk/text_style_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../space_theme.dart';
import '../text_adaptive.dart';
import '../theme_color.dart';
import '../widget_component.dart';
import '2_Dashboard.dart';
import 'main_page.dart';
import 'register.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String email, password;
  String validator = "";
  final _key = GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    print(form);
    if (form!.validate()) {
      form.save();
    }
    login();
  }

  login() async {
    final response = await http.post(Uri.parse("$urlAPI/api/login"), body: {
      "email": email,
      "password": password,
    });
    debugPrint(response.statusCode.toString());
    var body = jsonDecode(response.body);
    switch (response.statusCode) {
      case 401:
        debugPrint("failed login");
        setState(() {
          validator = "Email or Password are incorrect.";
        });
        break;
      case 404:
        debugPrint("email not found");
        setState(() {
          validator = body["message"];
        });
        break;
      case 200:
        debugPrint("success login");
        var pref = await SharedPreferences.getInstance();
        pref.setString("token", body["token"]);
        pref.setBool("login", true);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MainPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: pWhiteColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: height * 0.5,
              color: pDarkBrownColor,
              child: Image.asset(
                "assets/bg-pecel.jpg",
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                Container(
                  height: height * 0.3,
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: pWhiteColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(width * 0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Form(
                        key: _key,
                        child: SizedBox(
                          width: width,
                          child: ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(16.0),
                            children: <Widget>[
                              Center(
                                child: Text(
                                  "Sign In",
                                  style: pBoldWhiteTextStyle.copyWith(
                                    fontSize: const AdaptiveTextSize()
                                        .getadaptiveTextSize(context, 36),
                                    color: pDarkBrownColor,
                                  ),
                                ),
                              ),
                              pSpaceBig(context),
                              SvgPicture.asset(
                                "assets/logo-warung.svg",
                                width: width * 0.5,
                              ),
                              pSpaceBig(context),
                              Flexible(
                                child: TextFormField(
                                  validator: (e) {
                                    if (e!.isEmpty) {
                                      return "Please insert an email";
                                    }
                                    return null;
                                  },
                                  onSaved: (e) => email = e!,
                                  style: pWhiteTextStyle.copyWith(
                                    fontSize: const AdaptiveTextSize()
                                        .getadaptiveTextSize(context, 14),
                                    color: pDarkBrownColor,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        10, 20, 10, 0),
                                    hintText: "Insert your email address",
                                    hintStyle: pWhiteTextStyle.copyWith(
                                        color: pSecondGreyColor),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1.0,
                                        color: pSecondGreyColor,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          width > height
                                              ? width * 0.5
                                              : height * 0.5),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1.0,
                                        color: pDarkBrownColor,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          width > height
                                              ? width * 0.5
                                              : height * 0.5),
                                    ),
                                  ),
                                ),
                              ),
                              pSpaceBig(context),
                              Flexible(
                                child: TextFormField(
                                  obscureText: _secureText,
                                  validator: (e) {
                                    if (e!.isEmpty) {
                                      return "Please insert an password";
                                    }
                                    return null;
                                  },
                                  onSaved: (e) => password = e!,
                                  style: pWhiteTextStyle.copyWith(
                                    fontSize: const AdaptiveTextSize()
                                        .getadaptiveTextSize(context, 14),
                                    color: pDarkBrownColor,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        10, 20, 10, 0),
                                    hintText: "Insert your password",
                                    hintStyle: pWhiteTextStyle.copyWith(
                                        color: pSecondGreyColor),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1.0,
                                        color: pSecondGreyColor,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          width > height
                                              ? width * 0.5
                                              : height * 0.5),
                                    ),
                                    suffixIcon: InkWell(
                                      onTap: showHide,
                                      child: _secureText
                                          ? SvgPicture.asset(
                                              "assets/eye-slash.svg")
                                          : SvgPicture.asset("assets/eye.svg"),
                                    ),
                                  ),
                                ),
                              ),
                              // pSpaceMedium(context),
                              // Container(
                              //   alignment: Alignment.centerRight,
                              //   child: InkWell(
                              //     onTap: () {},
                              //     child: Text(
                              //       "Forgot Password",
                              //       textAlign: TextAlign.center,
                              //       style: pBoldWhiteTextStyle.copyWith(
                              //         fontSize: const AdaptiveTextSize()
                              //             .getadaptiveTextSize(context, 14),
                              //         color: pDarkBrownColor,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              pSpaceBig(context),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.05,
                        width: width * 0.5,
                        child: pSecondaryButton(
                          text: "Sign In",
                          context: context,
                          width: width,
                          height: height,
                          onPressed: () {
                            check();
                          },
                        ),
                      ),
                      pSpaceMedium(context),
                      SizedBox(
                        height: height * 0.05,
                        width: width * 0.5,
                        child: pSecondaryButton(
                          text: "Register",
                          context: context,
                          width: width,
                          height: height,
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => Register()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
