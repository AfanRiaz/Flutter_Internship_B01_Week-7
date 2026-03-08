import 'package:firebase_auth_app/model/auth_model.dart';
import 'package:flutter/foundation.dart';

class AuthenticationProvider with ChangeNotifier{
  AuthModel _authModel  =AuthModel();
  void toggleIsLoadingTrue(){
    _authModel=_authModel.copyWith(
        isLoading: _authModel.isLoading
    );
    notifyListeners();
  }
  void setName(String name){
    _authModel=_authModel.copyWith(
        name: name
    );
    notifyListeners();
  }
  void setEmail(String email){
    _authModel=_authModel.copyWith(
        email: email
    );
    notifyListeners();
  }
  void setPassword(String password){
    _authModel=_authModel.copyWith(
        password: password
    );
    notifyListeners();
  }
  void setLoading(bool isLoading){
    _authModel=_authModel.copyWith(
        isLoading: isLoading
    );
    notifyListeners();
  }
  void setPasswordHidden(bool isPasswordHidden){
    _authModel=_authModel.copyWith(
        isPasswordHidden: isPasswordHidden
    );
    notifyListeners();
  }
}