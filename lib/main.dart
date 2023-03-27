import 'package:clubhouse/services/firebase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  return runApp(MyApp());
}

/// This widget is the root of application
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(), builder: FirebaseService().init());
  }
}
