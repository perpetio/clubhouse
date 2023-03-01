import 'package:clubhouse/screens/phone/phone_screen.dart';
import 'package:clubhouse/utils/router.dart';
import 'package:clubhouse/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../utils/app_color.dart';

class AuthService {
  /// returns the initial screen depending on the authentication results
  handleAuth() {
    return (BuildContext context, snapshot) {
      print(snapshot.data);
      if (snapshot.hasData) {
        return MaterialApp(
          title: 'Clubhouse',
          debugShowCheckedModeBanner: false,
          onGenerateRoute: router,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColor.LightBrown,
            appBarTheme: AppBarTheme(
              color: AppColor.LightBrown,
              elevation: 0.0,
              brightness: Brightness.light,
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
            ),
          ),
          home: HomeScreen(),
        );
      } else {
        return MaterialApp(
          title: 'Clubhouse',
          debugShowCheckedModeBanner: false,
          onGenerateRoute: router,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColor.LightBrown,
            appBarTheme: AppBarTheme(
              color: AppColor.LightBrown,
              elevation: 0.0,
              brightness: Brightness.light,
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
            ),
          ),
          home: PhoneScreen(),
        );
        ;
      }
    };
  }

  /// This method is used to logout the `FirebaseUser`
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  /// This method is used to login the user
  ///  `AuthCredential`(`_phoneAuthCredential`) is needed for the signIn method
  /// After the signIn method from `AuthResult` we can get `FirebaserUser`(`_firebaseUser`)
  signIn(BuildContext context, AuthCredential authCreds) async {
    UserCredential result =
        await FirebaseAuth.instance.signInWithCredential(authCreds);

    if (result.user != null) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Routers.home, (route) => false);
    } else {
      print("Error");
    }
  }

  /// get the `smsCode` from the user
  /// when used different phoneNumber other than the current (running) device
  /// we need to use OTP to get `phoneAuthCredential` which is inturn used to signIn/login
  signInWithOTP(BuildContext context, smsCode, verId) {
    AuthCredential authCreds =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    signIn(context, authCreds);
  }
}
