import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signIn({
    required String name,
    required String email,
    required String password
  }) async {
    if (email.isEmpty || name.isEmpty || password.isEmpty) {
      return "please fill all the fields";
    }
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    await _firestore.collection('Users').doc(credential.user!.uid).set({
      "name": name,
      "email": email,
      "password": password,
      "uid": credential.user!.uid,
      "CreatedAt": FieldValue.serverTimestamp(),
    });
    return "successfully Signed In";
  }

  Future<String> login({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      return "please fill all the fields";
    }
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    return "Successfully Logged In";
  }

  User? get currentUser => _auth.currentUser;

  Future<bool> isLoggedIn() async {
    return _auth.currentUser != null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
  Future<void> signInWithGoogle()async{
    try{
      final appId = '453006389944-t514vnhosq7kui7jk6p7ihi7mse849ao.apps.googleusercontent.com';
      GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(serverClientId: appId);
      GoogleSignInAccount account = await googleSignIn.authenticate();
      if (account == null) {
        return null;
      }
      GoogleSignInAuthentication googleSignInAuthentication = account
          .authentication;
      final credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken
      );

      await _auth.signInWithCredential(credential);
    }
    catch (e){
      Text(e.toString());
    }
  }
}