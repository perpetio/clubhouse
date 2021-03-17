import 'package:clubhouse/screens/home/home_screen.dart';
import 'package:clubhouse/screens/phone/phone_screen.dart';
import 'package:clubhouse/screens/profile/profile_screen.dart';
import 'package:clubhouse/screens/sms/sms_screen.dart';
import 'package:flutter/material.dart';

class Routers {
  static const String home = '/home';
  static const String phone = '/phone';
  static const String sms = '/sms';
  static const String profile = '/profile';
}

// ignore: missing_return
Route<dynamic> router(routeSetting) {
  switch (routeSetting.name) {
    case Routers.home:
      return new MaterialPageRoute(
        builder: (context) => HomeScreen(),
        settings: routeSetting,
      );
      break;
    case Routers.phone:
      return new MaterialPageRoute(
        builder: (context) => PhoneScreen(),
        settings: routeSetting,
      );
      break;
    case Routers.sms:
      return new MaterialPageRoute(
          builder: (context) => SmsScreen(
                verificationId: routeSetting.arguments,
              ),
          settings: routeSetting);
      break;
    case Routers.profile:
      return new MaterialPageRoute(
          builder: (context) => ProfileScreen(
                profile: routeSetting.arguments,
              ),
          settings: routeSetting);
      break;
  }
}
