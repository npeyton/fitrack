class User {
  final int? id;
  final String firstName;
  final String lastName;
  final String userName;
  final String? password;
  final String? profilePhotoUrl;
  final String email;
  final DateTime? createdAt;
  final DateTime? lastLogin;

  // Constructor
  User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.userName,
    this.password,
    this.profilePhotoUrl,
    required this.email,
    this.createdAt,
    this.lastLogin,
  });

  // Factory method for creating a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      userName: json['userName'] as String,
      password: json['password'] as String?,
      profilePhotoUrl: json['profilePhotoUrl'] as String?,
      email: json['email'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'] as String)
          : null,
    );
  }

  // Method to convert a User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'password': password,
      'profilePhotoUrl': profilePhotoUrl,
      'email': email,
      'createdAt': createdAt?.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }
}
