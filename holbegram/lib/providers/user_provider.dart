import 'package:flutter/material.dart';
import '../models/user.dart';
import '../screens/auth/methods/auth_methods.dart';

class UserProvider with ChangeNotifier{
  Users? _user;
  final AuthMethode _authMethode = AuthMethode();

  Users? get getUser => _user;

  Future<void> refreshUser() async {
    try {
    Users user = await _authMethode.getUserDetails();
    _user = user;
    notifyListeners();
    } catch (err) {
      debugPrint(err.toString());
    }
  }
}