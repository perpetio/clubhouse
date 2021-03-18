import 'package:clubhouse/screens/phone/phone_screen.dart';
import 'package:clubhouse/utils/router.dart';
import 'package:clubhouse/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  /// returns the initial screen depending on the authentication results
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return HomeScreen();
        } else {
          return PhoneScreen();
        }
      },
    );
  }

  /// This method is used to logout the `FirebaseUser`
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  /// This method is used to login the user
  ///  `AuthCredential`(`_phoneAuthCredential`) is needed for the signIn method
  /// After the signIn method from `AuthResult` we can get `FirebaserUser`(`_firebaseUser`)
  signIn(BuildContext context, AuthCredential authCreds) async {
    AuthResult result =
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
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    signIn(context, authCreds);
  }
}
