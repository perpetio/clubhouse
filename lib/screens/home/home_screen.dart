import 'package:clubhouse/services/authentication.dart';
import 'package:clubhouse/utils/router.dart';
import 'package:clubhouse/screens/home/rooms_list.dart';
import 'package:clubhouse/screens/home/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';

/// The home screen of the app
/// Contains AppBar and list of Rooms

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(AuthService().getUser());
    return Scaffold(
      appBar: AppBar(
        title: HomeAppBar(
          profile: AuthService().getUser(),
          onProfileTab: () {
            Navigator.of(context)
                .pushNamed(Routers.profile, arguments: AuthService().getUser());
          },
        ),
      ),
      body: RoomsList(),
    );
  }
}
