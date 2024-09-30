import 'package:flutter/material.dart';

import 'space_theme.dart';
import 'text_adaptive.dart';
import 'text_style_theme.dart';
import 'theme_color.dart';

Widget pButton(text, context, {VoidCallback? onPressed}) {
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;
  return SizedBox(
    width: width * 0.3,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: pDarkBrownColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              width > height ? width * 0.02 : height * 0.02),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: pBoldWhiteTextStyle.copyWith(
          fontSize: const AdaptiveTextSize().getadaptiveTextSize(context, 14),
          color: pLightBrownColor,
        ),
      ),
    ),
  );
}

Widget pSecondaryButton(
    {required text,
    required context,
    required width,
    required height,
    required VoidCallback onPressed}) {
  return SizedBox(
    width: width,
    height: height,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: pDarkBrownColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              width > height ? width * 0.05 : height * 0.05),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: pWhiteTextStyle.copyWith(
          fontSize: const AdaptiveTextSize().getadaptiveTextSize(context, 14),
          fontWeight: bold,
          color: pWhiteColor,
        ),
      ),
    ),
  );
}

PreferredSize pAppBar({
  required BuildContext context,
  required String title,
  required Widget widget,
  Color? color,
}) {
  double height = MediaQuery.of(context).size.height;

  return PreferredSize(
    preferredSize: Size.fromHeight(height * 0.1),
    child: AppBar(
      foregroundColor: pWhiteColor,
      backgroundColor: color ?? pDarkBrownColor,
      title: widget,
    ),
  );
}

Future<void> validationPopUp({
  String? title,
  required String pesan,
  required BuildContext context,
  required VoidCallback? onPressed,
  String? buttonLabel,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      double height = MediaQuery.of(context).size.height;
      double width = MediaQuery.of(context).size.width;
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              title != null
                  ? Text(
                      title,
                      textAlign: TextAlign.center,
                      style: pBoldBlackTextStyle.copyWith(
                        fontSize: const AdaptiveTextSize()
                            .getadaptiveTextSize(context, 16),
                      ),
                    )
                  : Container(),
              title != null ? pSpaceMedium(context) : Container(),
              Text(
                pesan,
                textAlign: TextAlign.center,
                style: pBlackTextStyle.copyWith(
                    fontSize: const AdaptiveTextSize()
                        .getadaptiveTextSize(context, 14)),
              ),
              pSpaceMedium(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  pButton(
                    "Tidak",
                    context,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  pButton(
                    "Ya",
                    context,
                    onPressed: onPressed,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
