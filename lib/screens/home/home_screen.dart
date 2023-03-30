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
            icon: Image.asset('assets/images/profile.png'),
            tooltip: 'Show Snackbar',
            onPressed: () {
              Navigator.of(context).pushNamed(Routers.profile,
                  arguments: AuthService().getUser());
            },
          ),
        ],
        title: Text(
          "Clubhouse",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: RoomsList(),
    );
  }
}
