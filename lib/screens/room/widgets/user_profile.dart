import 'package:clubhouse/models/models.dart';
import 'package:clubhouse/utils/app_color.dart';
import 'package:clubhouse/widgets/rounded_image.dart';
import 'package:flutter/material.dart';

/// Shows the user's account icon in the room

class UserProfile extends StatelessWidget {
  final User user;
  final double size;
  final bool isMute;
  final bool isModerator;

  const UserProfile(
      {Key key,
      this.user,
      this.size,
      this.isMute = true,
      this.isModerator = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                '/profile',
                arguments: user,
              ),
              child: RoundedImage(
                path: user.profileImage,
                width: size,
                height: size,
              ),
            ),
            mute(isMute),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            moderator(isModerator),
            Text(
              user.name.split(' ')[0],
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  ///Return if user is moderator

  Widget moderator(bool isModerator) {
    return isModerator
        ? Container(
            margin: const EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              color: AppColor.AccentGreen,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(Icons.star, color: Colors.white, size: 12),
          )
        : Container();
  }

  ///Return if user is mute

  Widget mute(bool isMute) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: isMute
          ? Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: Offset(0, 1),
                  )
                ],
              ),
              child: Icon(Icons.mic_off),
            )
          : Container(),
    );
  }
}
