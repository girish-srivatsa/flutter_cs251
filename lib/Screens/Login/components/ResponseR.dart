class Course {
  int id;
}

class ResponseR {
  final token;

  ResponseR({this.token});

  factory ResponseR.fromJson(Map<String, dynamic> json) {
    return ResponseR(
      token: json["token"],
    );
  }
}
