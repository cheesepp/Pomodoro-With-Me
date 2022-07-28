import 'package:flutter/animation.dart';

class Users {
  String userName;
  String email;
  String password;
  String avatar;
  String uuid;

  Users({
    required this.userName,
    required this.email,
    required this.password,
    required this.avatar,
    required this.uuid,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      userName: json['userName'],
      email: json['email'],
      password: json['password'],
      avatar: json['avatar'],
      uuid: json['uuid'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': userName,
        'email': email,
        'password': password,
        'avatar': avatar,
        'uuid': uuid
      };
}
