import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:clubhouse/models/room.dart';
import 'package:clubhouse/models/user.dart';
import 'package:clubhouse/screens/room/widgets/room_profile.dart';
import 'package:clubhouse/core/data.dart';
import 'package:clubhouse/utils/app_color.dart';
import 'package:clubhouse/utils/settings.dart';
import 'package:clubhouse/widgets/round_button.dart';
import 'package:clubhouse/widgets/round_image.dart';
import 'package:flutter/material.dart';

class RoomScreen extends StatefulWidget {
  final Room room;
  final String channelName;
  final ClientRole role;

  const RoomScreen({Key key, this.room, this.channelName, this.role})
      : super(key: key);

  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  RtcEngine _engine;

  @override
  void dispose() {
    _users.clear();
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await _engine.enableWebSdkInteroperability(true);
    await _engine.joinChannel(Token, widget.channelName, null, 0);
  }

  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(APP_ID);
    await _engine.enableAudio();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role);
  }

  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        setState(() {
          final info = 'onError: $code';
          _infoStrings.add(info);
        });
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        setState(() {
          final info = 'onJoinChannel: $channel, uid: $uid';
          _infoStrings.add(info);
        });
      },
      leaveChannel: (stats) {
        setState(() {
          _infoStrings.add('onLeaveChannel');
          _users.clear();
        });
      },
      userJoined: (uid, elapsed) {
        setState(() {
          final info = 'userJoined: $uid';
          _infoStrings.add(info);
          _users.add(uid);
        });
      },
      userOffline: (uid, elapsed) {
        setState(() {
          final info = 'userOffline: $uid';
          _infoStrings.add(info);
          _users.remove(uid);
        });
      },
    ));
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
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text(
              'All rooms',
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamed('/profile', arguments: myProfile);
              },
              child: RoundImage(
                path: myProfile.profileImage,
                width: 40,
                height: 40,
              ),
            ),
          ],
        ),
      ),
      body: Container(
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
              padding: const EdgeInsets.only(
                bottom: 80,
                top: 20,
              ),
              child: Column(
                children: [
                  buildTitle(widget.room.title),
                  SizedBox(
                    height: 30,
                  ),
                  buildSpeakers(
                      widget.room.users.sublist(0, widget.room.speakerCount)),
                  buildOthers(
                      widget.room.users.sublist(widget.room.speakerCount)),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: buildBottom(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTitle(String title) {
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

  Widget buildSpeakers(List<User> users) {
    return GridView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: users.length,
      itemBuilder: (gc, index) {
        return RoomProfile(
          user: users[index],
          isModerator: index == 0,
          isMute: index == 3,
          size: 80,
        );
      },
    );
  }

  Widget buildOthers(List<User> users) {
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
            return RoomProfile(
              user: users[index],
              size: 60,
            );
          },
        ),
      ],
    );
  }

  Widget buildBottom(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          RoundButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: AppColor.LightGrey,
            child: Text(
              '✌️ Leave quietly',
              style: TextStyle(
                color: AppColor.AccentRed,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Spacer(),
          RoundButton(
            onPressed: () {},
            color: AppColor.LightGrey,
            isCircle: true,
            child: Icon(
              Icons.add,
              size: 15,
              color: Colors.black,
            ),
          ),
          RoundButton(
            onPressed: () {},
            color: AppColor.LightGrey,
            isCircle: true,
            child: Icon(
              Icons.thumb_up,
              size: 15,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
