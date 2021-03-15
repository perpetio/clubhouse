import 'package:clubhouse/models/models.dart';

String profileText = 'What do you do to protect the environment? ❤';

// MyProfile
Map profileData = {
  'name': 'Nick Edmands',
  'username': '@nick',
  'profileImage': 'assets/images/profile.png',
};

User myProfile = User.fromJson(profileData);

// Room

List bottomSheetData = [
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
