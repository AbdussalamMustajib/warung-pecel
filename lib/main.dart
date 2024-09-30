import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'page/splash_screen.dart';
import 'theme_color.dart';

String urlAPI = "http://192.168.2.103:8000";
var formatter =
    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: createCustomSwatch(pDarkBrownColor),
        scaffoldBackgroundColor: pLightBrownColor,
      ),
      home: SplashScreen(),
    );
  }
}

MaterialColor createCustomSwatch(Color color) {
  Map<int, Color> colorCodes = {
    50: color.withOpacity(0.1),
    100: color.withOpacity(0.2),
    200: color.withOpacity(0.3),
    300: color.withOpacity(0.4),
    400: color.withOpacity(0.5),
    500: color.withOpacity(0.6),
    600: color.withOpacity(0.7),
    700: color.withOpacity(0.8),
    800: color.withOpacity(0.9),
    900: color,
  };

  return MaterialColor(color.value, colorCodes);
}
