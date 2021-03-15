import 'package:clubhouse/models/user.dart';
import 'package:clubhouse/widgets/round_image.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  final User profile;
  final Function onProfileTab;

  const HomeAppBar({Key key, this.profile, this.onProfileTab})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: GestureDetector(
        onTap: onProfileTab,
        child: RoundImage(
          path: profile.profileImage,
          width: 40,
          height: 40,
        ),
      ),
    );
  }
}
