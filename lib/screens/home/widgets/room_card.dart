import 'package:clubhouse/models/models.dart';
import 'package:clubhouse/widgets/rounded_image.dart';
import 'package:flutter/material.dart';

/// Each element that fetch from Firestore return the RoomCard

class RoomCard extends StatelessWidget {
  final Room room;

  const RoomCard({Key key, this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              offset: Offset(0, 1),
            )
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            room.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              profileImages(),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  usersList(),
                  SizedBox(height: 5),
                  roomInfo(),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget profileImages() {
    return Stack(
      children: [
        RoundedImage(
          margin: const EdgeInsets.only(top: 15, left: 25),
          path: 'assets/images/profile.png',
        ),
        RoundedImage(path: 'assets/images/profile.png'),
      ],
    );
  }

  Widget usersList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < room.users.length; i++)
          Container(
            child: Row(
              children: [
                Text(
                  room.users[i].name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 5),
                Icon(Icons.chat, color: Colors.grey, size: 14),
              ],
            ),
          )
      ],
    );
  }

  Widget roomInfo() {
    return Row(
      children: [
        Text(
          '${room.users.length}',
          style: TextStyle(color: Colors.grey),
        ),
        Icon(Icons.supervisor_account, color: Colors.grey, size: 14),
        Text(
          '  /  ',
          style: TextStyle(color: Colors.grey, fontSize: 10),
        ),
        Text(
          '${room.speakerCount}',
          style: TextStyle(color: Colors.grey),
        ),
        Icon(Icons.chat_bubble_rounded, color: Colors.grey, size: 14),
      ],
    );
  }
}
