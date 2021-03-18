import 'package:clubhouse/utils/router.dart';
import 'package:clubhouse/screens/home/rooms_list.dart';
import 'package:clubhouse/screens/home/widgets/home_app_bar.dart';
import 'package:clubhouse/core/data.dart';
import 'package:flutter/material.dart';

/// The home screen of the app
/// Contains AppBar and list of Rooms

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HomeAppBar(
          profile: myProfile,
          onProfileTab: () {
            Navigator.of(context)
                .pushNamed(Routers.profile, arguments: myProfile);
          },
        ),
      ),
      body: RoomsList(),
    );
  }
}
