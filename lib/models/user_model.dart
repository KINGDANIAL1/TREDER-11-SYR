
class UserModel {
  final String id;
  final String email;
  final bool isAdmin;

  UserModel({required this.id, required this.email, required this.isAdmin});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      email: json['email'],
      isAdmin: json['isAdmin'] ?? false,
    );
  }
}