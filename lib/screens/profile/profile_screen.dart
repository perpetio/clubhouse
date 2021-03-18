import 'package:clubhouse/utils/router.dart';
import 'package:clubhouse/models/models.dart';
import 'package:clubhouse/services/authenticate.dart';
import 'package:clubhouse/core/data.dart';
import 'package:clubhouse/widgets/rounded_image.dart';
import 'package:flutter/material.dart';

/// Contain information about current user profile

class ProfileScreen extends StatelessWidget {
  final User profile;

  const ProfileScreen({Key key, this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Button that logout user
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              AuthService().signOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(Routers.phone, (route) => false);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            profileBody(),
          ],
        ),
      ),
    );
  }

  Widget profileBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RoundedImage(
            path: profile.profileImage,
            width: 100,
            height: 100,
            borderRadius: 35),
        SizedBox(height: 20),
        Text(
          profile.name,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Text(
          profile.username,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            profileText,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }
}
