import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:clubhouse/models/models.dart';
import 'package:clubhouse/screens/room/widgets/user_profile.dart';
import 'package:clubhouse/services/authentication.dart';
import 'package:clubhouse/utils/app_color.dart';
import 'package:clubhouse/core/settings.dart';
import 'package:clubhouse/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/data.dart';
import '../../widgets/rounded_image.dart';

/// Detail screen of selected room
/// Initialize Agora SDK

class RoomScreen extends StatefulWidget {
  final Room room;
  final ClientRoleType role;

  const RoomScreen({Key key, this.room, this.role}) : super(key: key);

  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  final List _users = [];

  bool muted = false;
  RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    // Initialize Agora SDK
    setupVideoSDKEngine();
  }

  void join() async {
    await agoraEngine.startPreview();
    print("clicked");

    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = ChannelMediaOptions(
      // ignore: sdk_version_eq_eq_operator_in_const_context
      clientRoleType: (AuthService().getUser().username == "guest")
          ? ClientRoleType.clientRoleAudience
          : ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    await agoraEngine.joinChannel(
      token: token,
      channelId: channelName,
      options: options,
      uid: uid,
    );
  }

  void leave() {
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    agoraEngine.leaveChannel();
  }

  @override
  void dispose() async {
    await agoraEngine.leaveChannel();
    agoraEngine.release();
    super.dispose();
  }

  /// Create Agora SDK instance and initialize
  Future<void> initialize() async {
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await [Permission.microphone, Permission.camera].request();
    await _engine.joinChannel(
        token: Token,
        channelId: channelName,
        uid: 0,
        options: ChannelMediaOptions(autoSubscribeAudio: true));
  }

  Future<void> _initAgoraRtcEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: APP_ID,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    await _engine.enableVideo();
    await _engine.enableAudio();
    await _engine.setClientRole(role: widget.role);
  }

  /// Add Agora event handlers

  void _addAgoraEventHandlers() {
    _engine.registerEventHandler(RtcEngineEventHandler(
      onError: (ErrorCodeType code, err) async {
        setState(() {
          print('onError: $code $err');
        });
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        setState(() {
          print('onLeaveChannel');
          _users.clear();
        });
      },
      onUserJoined: (RtcConnection connection, uid, elapsed) {
        print('userJoined: $uid');
        setState(() {
          _users.add(uid);
        });
      },
    ));
  }

  String token = Token;

  int uid = 0; // uid of the local user

  int _remoteUid; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  RtcEngine agoraEngine; // Agora engine instance

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold

  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  Future<void> setupVideoSDKEngine() async {
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(appId: APP_ID));

    await agoraEngine.enableVideo();

    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          showMessage(
              "Local user uid:${connection.localUid} joined the channel");
          setState(() {
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          showMessage("Remote user uid:$remoteUid joined the channel");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          showMessage("Remote user uid:$remoteUid left the channel");
          setState(() {
            _remoteUid = null;
          });
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
          ],
        ),
      ),
      body: body(),
    );
  }

// Display local video preview
  // Widget _localPreview() {
  //   if (_isJoined) {
  //     return AgoraVideoView(
  //       controller: VideoViewController(
  //         rtcEngine: agoraEngine,
  //         canvas: VideoCanvas(uid: 0),
  //       ),
  //     );
  //   } else {
  //     return const Text(
  //       'Join a channel',
  //       textAlign: TextAlign.center,
  //     );
  //   }
  // }

// Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: channelName),
        ),
      );
    } else {
      String msg = '';
      if (_isJoined) msg = 'Waiting for a remote user to join';
      return Text(
        msg,
        textAlign: TextAlign.center,
      );
    }
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
                // _localPreview(),
                _remoteVideo()
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
            onPressed: () {
              leave();
              Navigator.pop(context);
            },
            color: AppColor.LightGrey,
            child: Text(
              '✌️ Leave quietly',
              style: TextStyle(
                  color: AppColor.AccentRed,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Spacer(),
          RoundedButton(
            onPressed: () {
              Navigator.of(context).pop();
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return RoomScreen(
                    room: widget.room,
                    role: ClientRoleType.clientRoleBroadcaster,
                  );
                },
              );
            },
            color: AppColor.LightGrey,
            isCircle: true,
            child: Icon(Icons.hail, size: 15, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
