import 'package:clubhouse/utils/router.dart';
import 'package:clubhouse/services/authenticate.dart';
import 'package:clubhouse/utils/app_color.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

/// This widget is the root of application
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      home: AuthService().handleAuth(),
    );
  }
}
