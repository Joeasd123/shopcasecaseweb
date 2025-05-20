class SupabaseUserModel {
  final String id;
  final String? email;
  final String? phone;
  final String? role;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? emailConfirmedAt;
  final bool? phoneConfirmedAt;
  final Map<String, dynamic>? userMetadata;

  SupabaseUserModel({
    required this.id,
    this.email,
    this.phone,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.emailConfirmedAt,
    this.phoneConfirmedAt,
    this.userMetadata,
  });

  factory SupabaseUserModel.fromJson(Map<String, dynamic> json) {
    return SupabaseUserModel(
      id: json['id'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      emailConfirmedAt: json['email_confirmed_at'] != null,
      phoneConfirmedAt: json['phone_confirmed_at'] != null,
      userMetadata: json['user_metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'role': role,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'email_confirmed_at': emailConfirmedAt,
      'phone_confirmed_at': phoneConfirmedAt,
      'user_metadata': userMetadata,
    };
  }
}
