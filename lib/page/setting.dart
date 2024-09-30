import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../model/model_profil.dart';
import '../space_theme.dart';
import '../text_adaptive.dart';
import '../text_style_theme.dart';
import '../theme_color.dart';
import '1_login.dart';
import 'update_setting.dart';

class Setting extends StatefulWidget {
  const Setting({
    Key? key,
  }) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: FutureBuilder<ModelProfile>(
        future: ModelProfile.fetchProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              width: width,
              height: height,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Center(
                    child: body(
                      context: context,
                      profile: snapshot.data!,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: width * 0.12,
                      height: width * 0.12,
                      margin: EdgeInsets.all(width * 0.02),
                      child: CircleAvatar(
                          backgroundColor: pDarkBrownColor,
                          foregroundColor: pLightBrownColor,
                          child: IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => UpdateSetting(
                                          profile: snapshot.data!,
                                        )));
                              },
                              icon: const Icon(Icons.edit))),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

Widget body({required BuildContext context, required ModelProfile profile}) {
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;
  return Column(
    children: <Widget>[
      pSpaceBig(context),
      Container(
        height: width > height ? width * 0.2 : height * 0.2,
        width: width > height ? width * 0.2 : height * 0.2,
        decoration: BoxDecoration(
            color: pDarkBrownColor,
            borderRadius: BorderRadius.circular(
                width > height ? width * 0.1 : height * 0.1)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
              width > height ? width * 0.1 : height * 0.1),
          child: Image.network(
            "$urlAPI/storage/images/${profile.data![0].image ?? ""}",
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Image.asset(
              "assets/Ikon-User.png",
              width: width * 0.1,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      pSpaceMedium(context),
      Text(
        "Username",
        style: pBoldBlackTextStyle.copyWith(
            fontSize:
                const AdaptiveTextSize().getadaptiveTextSize(context, 18)),
      ),
      pSpaceBig(context),
      Container(
        width: width * 0.9,
        padding: EdgeInsets.only(
          top: width > height ? width * 0.025 : height * 0.025,
          left: width > height ? width * 0.02 : height * 0.02,
          bottom: width > height ? width * 0.025 : height * 0.025,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              width > height ? width * 0.03 : height * 0.03),
          color: pBrownColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profile.data![0].frontName ?? "-",
              style: pWhiteTextStyle.copyWith(
                  fontSize: const AdaptiveTextSize()
                      .getadaptiveTextSize(context, 18)),
            ),
            Divider(
              thickness: 1,
              color: pWhiteColor,
            ),
            Text(
              profile.data![0].backName ?? "backName",
              style: pWhiteTextStyle.copyWith(
                  fontSize: const AdaptiveTextSize()
                      .getadaptiveTextSize(context, 18)),
            ),
            Divider(
              thickness: 1,
              color: pWhiteColor,
            ),
            Text(
              profile.data![0].dateOfBirth ?? "-",
              style: pWhiteTextStyle.copyWith(
                  fontSize: const AdaptiveTextSize()
                      .getadaptiveTextSize(context, 18)),
            ),
          ],
        ),
      ),
      pSpaceBig(context),
      logoutButton("LOGOUT", context),
      pSpaceBig(context)
    ],
  );
}

Widget logoutButton(text, context, {VoidCallback? onPressed}) {
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;
  return SizedBox(
    width: width * 0.9,
    height: height * 0.05,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: pDarkBrownColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              width > height ? width * 0.02 : height * 0.02),
        ),
      ),
      onPressed: () async {
        var pref = await SharedPreferences.getInstance();
        pref.setBool("login", false);
        pref.setString("token", "");

        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => Login(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );
      },
      child: Text(
        text,
        style: pWhiteTextStyle.copyWith(fontWeight: bold),
      ),
    ),
  );
}
