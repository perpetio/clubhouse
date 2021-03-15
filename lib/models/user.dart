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
