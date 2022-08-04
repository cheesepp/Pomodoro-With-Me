import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/users.dart';

class AuthNotifier extends ChangeNotifier {
  User? _user;
  User? get user => _user;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  Users? _userDetails;
  Users get userDetails =>
      _userDetails ??
      Users(
          avatar:
              "https://i1.sndcdn.com/avatars-000214125831-5q6tdw-t500x500.jpg",
          email: '',
          password: '',
          userName: 'Hehe boy',
          uuid: '');

  void setUserDetails(Users users) {
    _userDetails = users;
    print('${_userDetails!.avatar} / ${_userDetails!.userName}');
  }
}
