class Status {
  int course;
  String status;
  Status(this.course, this.status);
  Status.generate(this.course, this.status);
  factory Status.fromJson(dynamic json) {
    return Status.generate(
      json["course"] as int,
      json["status"] as String,
    );
  }
}
