import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../model/model_profil.dart';
import '../theme_color.dart';
import '2_Dashboard.dart';
import 'history.dart';
import 'setting.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: [
            Dashboard(),
            History(),
            Setting(),
          ].elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: SizedBox(
        child: BottomNavigationBar(
          backgroundColor: pBrownColor,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                'assets/icons/nav-home-active.svg',
                height: height * 0.06,
              ),
              icon: SvgPicture.asset(
                'assets/icons/nav-home-nonactive.svg',
                height: height * 0.05,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                'assets/icons/nav-note-active.svg',
                height: height * 0.06,
              ),
              icon: SvgPicture.asset(
                'assets/icons/nav-note-nonactive.svg',
                height: height * 0.05,
              ),
              label: 'History',
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                'assets/icons/nav-setting-active.svg',
                height: height * 0.06,
              ),
              icon: SvgPicture.asset(
                'assets/icons/nav-setting-nonactive.svg',
                height: height * 0.05,
              ),
              label: 'Setting',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: pDarkBrownColor,
          unselectedItemColor: pLightBrownColor,
          onTap: onItemTapped,
        ),
      ),
    );
  }
}
