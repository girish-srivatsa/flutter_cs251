class Course {
  int id;
  String code;
  String name;
  Course(this.name, this.code);
  Course.generate(this.id, this.name, this.code);
  factory Course.fromJson(dynamic json) {
    return Course.generate(
        json["id"] as int, json["name"] as String, json["code"] as String);
  }
}
