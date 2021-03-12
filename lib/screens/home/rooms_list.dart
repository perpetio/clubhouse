import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubhouse/models/room.dart';
import 'package:clubhouse/screens/home/widgets/home_bottom_sheet.dart';
import 'package:clubhouse/screens/home/widgets/room_card.dart';
import 'package:clubhouse/screens/room/room_screen.dart';
import 'package:clubhouse/utils/app_color.dart';
import 'package:clubhouse/core/data.dart';
import 'package:clubhouse/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RoomsList extends StatefulWidget {
  @override
  _RoomsListState createState() => _RoomsListState();
}

class _RoomsListState extends State<RoomsList> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final collection = Firestore.instance.collection('rooms');

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SmartRefresher(
          enablePullDown: true,
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 80, left: 20, right: 20),
            itemBuilder: (context, index) {
              return buildRoomCard(rooms[index]);
            },
            itemCount: rooms.length,
          ),
        ),
        buildGradientContainer(),
        buildStartRoomButton(),
      ],
    );
  }

  Widget buildRoomCard(Room room) {
    return GestureDetector(
      onTap: () async {
        await Permission.microphone.request();
        openRoom(
          room: room,
          role: ClientRole.Audience,
          channelName: 'demo',
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
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
          colors: [AppColor.LightBrown.withOpacity(0.2), AppColor.LightBrown],
        ),
      ),
    );
  }

  Widget buildStartRoomButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: RoundButton(
          onPressed: () => showBottomSheet(),
          color: AppColor.AccentGreen,
          text: '+ Start a room'),
    );
  }

  openRoom({Room room, ClientRole role, String channelName}) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return RoomScreen(
          room: room,
          role: role,
          channelName: channelName,
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
                await Permission.microphone.request();
                Navigator.pop(context);
                openRoom(
                    room: Room(
                      title: '${myProfile.name}\'s Room',
                      users: [myProfile],
                      speakerCount: 1,
                    ),
                    role: ClientRole.Broadcaster,
                    channelName: 'demo');
                await collection.add({
                  'title': '${myProfile.name}\'s Room',
                });
              },
            ),
          ],
        );
      },
    );
  }
}
