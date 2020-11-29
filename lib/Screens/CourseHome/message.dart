class Message {
  int id;
  String sent;
  String message;
  String to;
  int course;
  int by;
  List<int> read_by;
  String from_username;
  bool is_proffessor;
  Message({
    this.id,
    this.sent,
    this.message,
    this.to,
    this.course,
    this.by,
    this.read_by,
    this.from_username,
    this.is_proffessor,
  });
  Message.generate(
    this.id,
    this.sent,
    this.message,
    this.to,
    this.course,
    this.by,
    this.read_by,
    this.from_username,
    this.is_proffessor,
  );
  factory Message.fromJson(dynamic json) {
    return Message.generate(
      json["id"] as int,
      json["sent"] as String,
      json["message"] as String,
      json["to"] as String,
      json["course"] as int,
      json["by"] as int,
      json["read_by"].cast<int>() as List<int>,
      json["from_username"] as String,
      json["is_professor"] as bool,
    );
  }
}
