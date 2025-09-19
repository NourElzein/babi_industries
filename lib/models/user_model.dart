class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String company;
  final String? profileImage;
  final String? token; // ✅ Added token field
  final DateTime? createdAt;
  final DateTime? lastLoginAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.company,
    this.profileImage,
    this.token, // ✅ Include token in constructor
    this.createdAt,
    this.lastLoginAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      company: json['company'],
      profileImage: json['profile_image'],
      token: json['token'], // ✅ Map token from API response
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      lastLoginAt: json['last_login_at'] != null 
          ? DateTime.parse(json['last_login_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'company': company,
      'profile_image': profileImage,
      'token': token, // ✅ Include token in JSON
      'created_at': createdAt?.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? company,
    String? profileImage,
    String? token, // ✅ Add token here
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      company: company ?? this.company,
      profileImage: profileImage ?? this.profileImage,
      token: token ?? this.token, // ✅ Copy token
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
}
