import 'package:clubhouse/services/authentication.dart';
import 'package:clubhouse/utils/router.dart';
import 'package:clubhouse/screens/home/rooms_list.dart';
import 'package:flutter/material.dart';

/// The home screen of the app
/// Contains AppBar and list of Rooms
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(AuthService().getUser());
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            iconSize: 32,
            icon: Icon(Icons.notifications_outlined),
            tooltip: 'Notification',
            onPressed: () {
              Navigator.of(context).pushNamed(Routers.profile,
                  arguments: AuthService().getUser());
            },
          ),
          IconButton(
            iconSize: 32,
            icon: Icon(Icons.person_outline),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.of(context).pushNamed(Routers.profile,
                  arguments: AuthService().getUser());
            },
          ),
        ],
        title: Text(
          "Clubhouse".toUpperCase(),
          style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: "NewSpirit",
              fontWeight: FontWeight.bold),
        ),
      ),
      body: RoomsList(),
    );
  }
}
