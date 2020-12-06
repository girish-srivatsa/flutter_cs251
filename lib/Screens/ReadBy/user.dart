class User {
  String username;
  int id;
  User({
    this.id,
    this.username,
  });
  User.generate(
    this.id,
    this.username,
  );
  factory User.fromJson(dynamic json) {
    return User.generate(
      json["id"] as int,
      json["username"] as String,
    );
  }
}
