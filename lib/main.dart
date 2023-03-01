import 'package:clubhouse/utils/router.dart';
import 'package:clubhouse/services/authenticate.dart';
import 'package:clubhouse/utils/app_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;

void main() {
  return runApp(MyApp());
}

/// This widget is the root of application
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(), builder: AuthService().handleAuth());
  }
}
