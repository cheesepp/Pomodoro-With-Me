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
  Users get userDetails => _userDetails!;

  void setUserDetails(Users users) {
    _userDetails = users;
    notifyListeners();
  }
}