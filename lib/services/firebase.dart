import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubhouse/services/authentication.dart';
import 'package:clubhouse/utils/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/loading.dart';
import '../utils/app_color.dart';

class FirebaseService {
  /// returns the initial screen depending on the authentication results
  init() {
    return (BuildContext context, snapshot) {
      return MaterialApp(
          title: 'Clubhouse',
          debugShowCheckedModeBanner: false,
          onGenerateRoute: router,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColor.LightBrown,
            appBarTheme: AppBarTheme(
              color: AppColor.LightBrown,
              elevation: 0.0,
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
            ),
          ),
          home: snapshot.hasData
              ? StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: AuthService().handleAuth(),
                )
              : LoadingScreen());
    };
  }
}
