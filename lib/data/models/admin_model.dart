class AdminModel {
  final int id;
  final String username;
  final String token;

  AdminModel({required this.id, required this.username, required this.token});

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json['admin']['id'],
      username: json['admin']['username'],
      token: json['token'],
    );
  }
}
