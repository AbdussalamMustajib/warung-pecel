import 'package:flutter/material.dart';

class AdaptiveTextSize {
  const AdaptiveTextSize();

  getadaptiveTextSize(BuildContext context, dynamic value) {
    // 720 is medium screen height
    if (MediaQuery.of(context).size.height >
        MediaQuery.of(context).size.width) {
      return (value / 720) * MediaQuery.of(context).size.height;
    } else {
      return (value / 720) * MediaQuery.of(context).size.width;
    }
  }
}
