class LoginResponse {
  final String title;

  LoginResponse({
    required this.title,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      title: json["title"],
    );
  }
}
