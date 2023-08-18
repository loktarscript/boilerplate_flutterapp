import 'package:flutter/material.dart';
import 'package:tareas/models/User.dart';

class UserProvider extends ChangeNotifier {
  late User _user = User(id: 0, name: '', email: '', colorSettings: '', is_active: 0);

  User get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}