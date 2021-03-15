import 'package:clubhouse/models/models.dart';

String dummyText = 'What do you do to protect the environment? ❤';

User myProfile = User.fromJson(
  {
    'name': 'Nick Edmands',
    'username': '@dog',
    'profileImage': 'assets/images/profile.png',
  },
);

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
