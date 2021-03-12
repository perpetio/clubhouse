import 'dart:math';
import 'package:clubhouse/models/room.dart';
import 'package:clubhouse/models/user.dart';

Random random = Random();

String dummyText = 'What do you do to protect the environment? ❤';

// User
List names = [
  'Maine Coon',
  'Scottish Fold',
  'Selkirk Rex',
];

List userData = List.generate(
  3,
  (index) => {
    'name': names[index],
    'username': '@${names[index].toString().split(' ')[0].toLowerCase()}',
    'profileImage': 'assets/images/profile.png',
  },
);

// MyProfile
dynamic profileData = {
  'name': 'Nick Edmands',
  'username': '@dog',
  'profileImage': 'assets/images/profile.png',
};

// Room
List roomData = List.generate(
  1,
  (index) => {
    'title':
        'Do you consider artificial beauty (cosmetic surgery) to still be beauty? Why/why not??❤',
    "users": [User.fromJson(userData[0]), User.fromJson(profileData)],
    'speakerCount': 1,
  },
);

List<Room> rooms = List.generate(
  1,
  (index) => Room.fromJson(roomData[index]),
);

List lobbyBottomSheets = [
  {
    'image': 'assets/images/open.png',
    'text': 'Open',
    'selectedMessage': 'Start a room open to everyone',
  },
  {
    'image': 'assets/images/social.png',
    'text': 'Social',
    'selectedMessage': 'Start a room with people I follow',
  },
  {
    'image': 'assets/images/closed.png',
    'text': 'Closed',
    'selectedMessage': 'Start a room for people I choose',
  },
];

User myProfile = User.fromJson(profileData);
