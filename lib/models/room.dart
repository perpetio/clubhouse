import 'package:clubhouse/models/user.dart';

class Room {
  final String title;
  final List<User> users;
  final int speakerCount;

  Room({
    this.title,
    this.speakerCount,
    this.users,
  });

  factory Room.fromJson(json) {
    return Room(
      title: json['title'],
      users: json['users'],
      speakerCount: json['speakerCount'],
    );
  }
}
