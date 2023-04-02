/// Room model
class Room {
  final String id;
  final String title;
  final List<User> users;
  final int speakerCount;
  final String owner;

  Room({this.id, this.title, this.speakerCount, this.users, this.owner});

  factory Room.fromJson(json) {
    return Room(
      id: json.id,
      title: json['title'],
      users: json['users'].map<User>((user) {
        return User(
          name: user['name'],
          username: user['username'],
          profileImage: user['profileImage'],
        );
      }).toList(),
      owner: json['owner'],
      speakerCount: json['speakerCount'],
    );
  }

  Map<String, dynamic> toJson() => {
        id: this.id,
        title: this.title,
        "users": this.users.map((user) {
          return user.toJson();
        }).toList(),
        owner: this.owner,
        "speakerCount": this.speakerCount,
      };
}

/// User model
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
  Map<String, dynamic> toJson() => {
        "name": this.name,
        "username": this.username,
        "profileImage": this.profileImage,
      };
}
