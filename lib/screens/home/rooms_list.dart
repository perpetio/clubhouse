import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubhouse/models/models.dart';
import 'package:clubhouse/screens/home/widgets/home_bottom_sheet.dart';
import 'package:clubhouse/screens/home/widgets/room_card.dart';
import 'package:clubhouse/screens/room/room_screen.dart';
import 'package:clubhouse/utils/app_color.dart';
import 'package:clubhouse/core/data.dart';
import 'package:clubhouse/widgets/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RoomsList extends StatefulWidget {
  @override
  _RoomsListState createState() => _RoomsListState();
}

class _RoomsListState extends State<RoomsList> {
  final collection = Firestore.instance.collection('rooms');
  final FirebaseAuth auth = FirebaseAuth.instance;

  RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  void _onRefresh() async {
    await Future.delayed(
      Duration(milliseconds: 1000),
    );
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(
      Duration(milliseconds: 1000),
    );
    _refreshController.loadComplete();
  }

  Widget buildRoomCard(Room room) {
    return GestureDetector(
      onTap: () async {
        await Permission.microphone.request();
        openRoom(
          room: room,
          role: ClientRole.Audience,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        child: RoomCard(room: room),
      ),
    );
  }

  Widget buildGradientContainer() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColor.LightBrown.withOpacity(0.2),
            AppColor.LightBrown,
          ],
        ),
      ),
    );
  }

  Widget buildStartRoomButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: RoundedButton(
          onPressed: () => showBottomSheet(),
          color: AppColor.AccentGreen,
          text: '+ Start a room'),
    );
  }

  openRoom({Room room, ClientRole role}) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return RoomScreen(
          room: room,
          role: role,
        );
      },
    );
  }

  showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (context) {
        return Wrap(
          children: [
            HomeBottomSheet(
              onButtonTap: () async {
                await collection.add(
                  {
                    'title': '${myProfile.name}\'s Room',
                    'users': [profileData],
                    'speakerCount': 1
                  },
                );
                await Permission.microphone.request();
                Navigator.pop(context);
                openRoom(
                  room: Room(
                    title: '${myProfile.name}\'s Room',
                    users: [myProfile],
                    speakerCount: 1,
                  ),
                  role: ClientRole.Broadcaster,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: collection.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');

            return snapshot.hasData
                ? SmartRefresher(
                    enablePullDown: true,
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: ListView(
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return Dismissible(
                          key: ObjectKey(document.data.keys),
                          onDismissed: (direction) {
                            collection.document(document.documentID).delete();
                          },
                          child: buildRoomCard(
                            Room.fromJson(document),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
        buildGradientContainer(),
        buildStartRoomButton(),
      ],
    );
  }
}
