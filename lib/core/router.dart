import 'package:clubhouse/screens/home/home_screen.dart';
import 'package:clubhouse/screens/profile/profile_screen.dart';
import 'package:clubhouse/screens/phone_number/phone_number_screen.dart';
import 'package:clubhouse/screens/sms/sms_screen.dart';
import 'package:flutter/material.dart';

class Routers {
  static String home = '/home';
  static String phone = '/phone';
  static String sms = '/sms';
  static String profile = '/profile';
}

// ignore: missing_return
Route<dynamic> router(routeSetting) {
  if (routeSetting.name == Routers.home)
    return new MaterialPageRoute(
      builder: (context) => HomeScreen(),
      settings: routeSetting,
    );

  if (routeSetting.name == Routers.phone)
    return new MaterialPageRoute(
      builder: (context) => PhoneNumberScreen(),
      settings: routeSetting,
    );

  if (routeSetting.name == Routers.sms)
    return new MaterialPageRoute(
        builder: (context) => SmsScreen(
              verificationId: routeSetting.arguments,
            ),
        settings: routeSetting);

  if (routeSetting.name == Routers.profile)
    return new MaterialPageRoute(
        builder: (context) => ProfileScreen(
              profile: routeSetting.arguments,
            ),
        settings: routeSetting);
}
