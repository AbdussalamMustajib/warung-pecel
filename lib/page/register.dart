import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../theme_color.dart';
import '../space_theme.dart';
import '../widget_component.dart';
import '1_login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late String email, password, nama;
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
      save();
    }
  }

  save() async {
    final response = await http.post(Uri.parse("$urlAPI/api/register"), body: {
      "email": email,
      "password": password,
      "name": nama,
    });
    print(jsonDecode(response.body));
    final data = jsonDecode(response.body);
    bool value = false;
    value = data['success'] != null ? true : false;
    String pesan = data['message'];
    if (value) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
    } else {
      _showMyDialog(pesan);
    }
  }

  Future<void> _showMyDialog(String pesan) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
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
              child: const Text('Back'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: Form(
          key: _key,
          child: SizedBox(
            width: width * 0.8,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: <Widget>[
                TextFormField(
                  validator: (e) {
                    if (e!.isEmpty) {
                      return "Please insert an email email";
                    }
                    return null;
                  },
                  onSaved: (e) => email = e!,
                  decoration: InputDecoration(
                    labelText: "email",
                    filled: true,
                    fillColor: pWhiteColor,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(
                          width > height ? width * 0.02 : height * 0.02),
                    ),
                  ),
                ),
                pSpaceMedium(context),
                TextFormField(
                  obscureText: _secureText,
                  validator: (e) {
                    if (e!.isEmpty) {
                      return "Please insert an password";
                    }
                    return null;
                  },
                  onSaved: (e) => password = e!,
                  decoration: InputDecoration(
                    labelText: "Password",
                    filled: true,
                    fillColor: pWhiteColor,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(
                          width > height ? width * 0.02 : height * 0.02),
                    ),
                    suffixIcon: IconButton(
                      onPressed: showHide,
                      icon: Icon(_secureText
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                  ),
                ),
                pSpaceMedium(context),
                TextFormField(
                  validator: (e) {
                    if (e!.isEmpty) {
                      return "Please insert first name";
                    }
                    return null;
                  },
                  onSaved: (e) => nama = e!,
                  decoration: InputDecoration(
                    labelText: "First Name",
                    filled: true,
                    fillColor: pWhiteColor,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(
                          width > height ? width * 0.02 : height * 0.02),
                    ),
                  ),
                ),
                pSpaceMedium(context),
                SizedBox(
                  height: height * 0.07,
                  child: pButton(
                    "SIGN UP",
                    context,
                    onPressed: check,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
