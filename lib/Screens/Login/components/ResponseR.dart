class Course {
  int id;
}

class ResponseR {
  final String tokenForm;
  final bool isProfessor;
  final String token;

  ResponseR({this.tokenForm, this.isProfessor, this.token});

  factory ResponseR.fromJson(Map<String, dynamic> json) {
    return ResponseR(
      tokenForm: json["token_form"],
      isProfessor: json["is_professor"],
      token: json["tokens"],
    );
  }
}
