import 'dart:convert';
import 'dart:ui';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubhouse/models/models.dart';
import 'package:clubhouse/screens/room/widgets/user_profile.dart';
import 'package:clubhouse/services/authentication.dart';
import 'package:clubhouse/services/firebase.dart';
import 'package:clubhouse/utils/app_color.dart';
import 'package:clubhouse/core/settings.dart';
import 'package:clubhouse/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/data.dart';
import '../../widgets/rounded_image.dart';

class RoomScreen extends StatefulWidget {
  final Room room;
  final ClientRoleType role;

  const RoomScreen({Key key, this.room, this.role}) : super(key: key);

  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  bool muted = false;

  RtcEngine agoraEngine;
  String token = Token;

  int uid = 0;
  bool loading = false;

  int volume = 50;
  bool _isMuted = false;

  onMuteChecked(bool value) {
    setState(() {
      _isMuted = value;
      agoraEngine.muteLocalAudioStream(_isMuted);
    });
  }

  @override
  void initState() {
    super.initState();
    setupVideoSDKEngine();
  }

  void join() async {
    await agoraEngine.startPreview();
    ChannelMediaOptions options = ChannelMediaOptions(
      // ignore: sdk_version_eq_eq_operator_in_const_context
      clientRoleType: widget.role,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    await agoraEngine.joinChannel(
      token: token,
      channelId: channelName,
      options: options,
      uid: uid,
    );
    joinAfterUpdate();
  }

  void joinAfterUpdate() {
    final fire =
        FirebaseFirestore.instance.collection("rooms").doc(widget.room.id);

    widget.room.users.add(User.fromJson({
      "name": AuthService().getUser().name,
      "username": AuthService().getUser().username,
      "profileImage": AuthService().getUser().profileImage,
    }));

    List<User> filteredUsers = widget.room.users.where(
        (element) => element.username == AuthService().getUser().usename);

    fire.update({...widget.room.toJson(), "users": filteredUsers});
  }

  leaveAfterUpdate() async {
    final fire =
        FirebaseFirestore.instance.collection("rooms").doc(widget.room.id);

    final room = await fire.get();
    List<User> filteredUsers = room["users"].where(
        (element) => element.username != AuthService().getUser().usename);
    print(filteredUsers);

    fire.update({...widget.room.toJson(), "users": filteredUsers});
  }

  leave() async {
    if (loading) return;
    setState(() {
      loading = true;
    });
    leaveAfterUpdate();
    await agoraEngine.leaveChannel();
  }

  @override
  void dispose() async {
    await agoraEngine.leaveChannel();
    agoraEngine.release();
    super.dispose();
  }

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  Future<void> setupVideoSDKEngine() async {
    await [Permission.microphone].request();

    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(appId: APP_ID));
    await agoraEngine.enableVideo();

    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          showMessage(
              "Local user uid:${connection.localUid} joined the channel");
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          showMessage("Remote user uid:$remoteUid joined the channel");
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          showMessage("Remote user uid:$remoteUid left the channel");
        },
      ),
    );
    join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              iconSize: 30,
              icon: Icon(Icons.keyboard_arrow_down),
              onPressed: () => Navigator.pop(context),
            ),
            Text(
              'All rooms',
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            Spacer(),
            GestureDetector(
              onTap: () => Navigator.of(context)
                  .pushNamed('/profile', arguments: myProfile),
              child: RoundedImage(
                path: myProfile.profileImage,
                width: 40,
                height: 40,
              ),
            ),
            Checkbox(
                value: _isMuted,
                onChanged: (_isMuted) => {onMuteChecked(_isMuted)}),
            const Text("Mute"),
          ],
        ),
      ),
      body: body(),
    );
  }

  Widget body() {
    return Container(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80, top: 20),
            child: Column(
              children: [
                title(widget.room.title),
                SizedBox(height: 30),
                speakers(
                  widget.room.users.sublist(0, widget.room.speakerCount),
                ),
                others(
                  widget.room.users.sublist(widget.room.speakerCount),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: bottom(context),
          ),
        ],
      ),
    );
  }

  Widget title(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          child: IconButton(
            onPressed: () {},
            iconSize: 30,
            icon: Icon(Icons.more_horiz),
          ),
        ),
      ],
    );
  }

  Widget speakers(List<User> users) {
    return GridView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: users.length,
      itemBuilder: (gc, index) {
        return UserProfile(
          user: users[index],
          isModerator: index == 0,
          isMute: false,
          size: 80,
        );
      },
    );
  }

  Widget others(List<User> users) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Others in the room',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.grey.withOpacity(0.6),
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemCount: users.length,
          itemBuilder: (gc, index) {
            return UserProfile(user: users[index], size: 60);
          },
        ),
      ],
    );
  }

  Widget bottom(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          RoundedButton(
            onPressed: loading
                ? null
                : () async {
                    await leave();
                    Navigator.pop(context);
                  },
            color: AppColor.LightGrey,
            child: Text(
              loading ? "..." : '✌️ Leave quietly',
              style: TextStyle(
                  color: AppColor.AccentRed,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Spacer(),
          RoundedButton(
            onPressed: null,
            color: AppColor.LightGrey,
            isCircle: true,
            child: Icon(Icons.hail, size: 15, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
