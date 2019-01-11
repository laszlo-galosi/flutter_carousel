library flutter_carousel.styles;

import 'package:flutter/material.dart';

TextStyle textStyleNormal = new TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.normal,
);

TextStyle textStyleMenu = new TextStyle(
    fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.black38);

TextStyle textStyleLabel = new TextStyle(
  fontSize: 12.0,
  fontWeight: FontWeight.normal,
);

TextStyle textStyleNormalDark = new TextStyle(
  color: Colors.white,
  fontSize: 16.0,
  fontWeight: FontWeight.normal,
);

TextStyle textStyleTitle = new TextStyle(
  color: Colors.black38,
  fontSize: 20.0,
  fontWeight: FontWeight.normal,
);

TextStyle textStyleTitleDark = new TextStyle(
  color: Colors.white,
  fontSize: 20.0,
  fontWeight: FontWeight.normal,
);

EdgeInsets edgeInsetsH16 =
    EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0);

EdgeInsets edgeInsetsItemH16V8 =
    EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);

BorderDirectional borderBottom1 = new BorderDirectional(
    bottom: BorderSide(width: 1.0, color: Colors.black26));

IconData backIcon(BuildContext context) {
  switch (Theme
      .of(context)
      .platform) {
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
      return Icons.arrow_back;
    case TargetPlatform.iOS:
      return Icons.arrow_back_ios;
  }
  assert(false);
  return null;
}
