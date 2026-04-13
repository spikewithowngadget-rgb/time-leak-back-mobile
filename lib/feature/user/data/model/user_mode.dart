class UserModel {
  final String userId;
  final String email;
  final String phone;
  final String userLanguage;
  final DateTime createdAt;

  UserModel({
    required this.userId,
    required this.email,
    required this.phone,
    required this.userLanguage,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      email: json['email'],
      phone: json['phone'],
      userLanguage: json['userLanguage'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}