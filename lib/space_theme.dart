import 'package:flutter/material.dart';

Widget pSpaceSmall(context) {
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;
  return SizedBox(
    height: width > height ? width * 0.01 : height * 0.01,
    width: width > height ? width * 0.01 : height * 0.01,
  );
}

Widget pSpaceMedium(context) {
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;
  return SizedBox(
    height: width > height ? width * 0.02 : height * 0.02,
    width: width > height ? width * 0.02 : height * 0.02,
  );
}

Widget pSpaceBig(context) {
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;
  return SizedBox(
    height: width > height ? width * 0.04 : height * 0.04,
    width: width > height ? width * 0.04 : height * 0.04,
  );
}
