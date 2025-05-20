import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    this.id,
    this.email,
    this.username,
    this.firstname,
    this.lastname,
    this.address,
    this.imageprofile,
  });
  final String? id;
  final String? email;
  final String? username;
  final String? firstname;
  final String? lastname;
  final String? imageprofile;
  final String? address;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      email: json["email"],
      username: json["username"],
      firstname: json["firstname"],
      lastname: json["lastname"],
      imageprofile: json["imageprofile"],
      address: json["address"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "username": username,
        "firstname": firstname,
        "lastname": lastname,
        "imageprofile": imageprofile,
        "address": address,
      };

  @override
  String toString() {
    return "$id, $email,$username,$firstname,$lastname,$imageprofile,$address ";
  }

  @override
  List<Object?> get props =>
      [id, email, username, firstname, lastname, imageprofile, address];
}
