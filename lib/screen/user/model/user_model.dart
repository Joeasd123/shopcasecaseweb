import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    this.id,
    this.email,
    this.password,
    this.name,
    this.role,
    this.enabled,
    this.address,
  });
  final int? id;
  final String? email;
  final String? password;
  final String? name;
  final String? role;
  final bool? enabled;
  final String? address;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      email: json["email"],
      password: json["password"],
      name: json["name"],
      role: json["role"],
      enabled: json["enabled"],
      address: json["address"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "password": password,
        "name": name,
        "role": role,
        "enabled": enabled,
        "address": address,
      };

  @override
  String toString() {
    return "$id, $email,$password,$name,$role,$enabled,$address ";
  }

  @override
  List<Object?> get props =>
      [id, email, password, name, role, enabled, address];
}
