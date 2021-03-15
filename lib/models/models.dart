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
      users: json['users'].map<User>((user) {
        return User(
          name: user['name'],
          username: user['username'],
          profileImage: user['profileImage'],
        );
      }).toList(),
      speakerCount: json['speakerCount'],
    );
  }
}

class User {
  final String name;
  final String username;
  final String profileImage;

  User({
    this.name,
    this.username,
    this.profileImage,
  });

  factory User.fromJson(json) {
    return User(
      name: json['name'],
      username: json['username'],
      profileImage: json['profileImage'],
    );
  }
}
