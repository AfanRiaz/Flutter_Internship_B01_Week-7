
import 'package:firebase_storage_app/models/auth_model.dart';
import 'package:flutter/material.dart';

class AuthenticationProvider with ChangeNotifier{
  AuthModel _authModel = AuthModel();
  void setName(String name){
    _authModel = _authModel.copyWith(
      name: name
    );
    notifyListeners();
  }

  void setEmail(String email){
    _authModel = _authModel.copyWith(
      email: email
    );
    notifyListeners();
  }

  void setPassword(String password){
    _authModel = _authModel.copyWith(
        password: password
    );
    notifyListeners();
  }

  void setLoading(bool value) {
    _authModel = _authModel.copyWith(isLoading: value);
    notifyListeners();
  }
  bool get isLoading =>_authModel.isLoading;

  String get name => _authModel.name;
  String get email => _authModel.email;
  String get password => _authModel.password;
}