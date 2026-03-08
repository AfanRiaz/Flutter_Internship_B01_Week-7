import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class AuthMethod{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  final FirebaseAuth _auth=FirebaseAuth.instance;

  Future<String> signUpUser({
    required String email,
    required String password,
    required String name
}) async{
    try{
      if(email.isEmpty||password.isEmpty||name.isEmpty){
        return "Please enter all the credentials";
      }
      UserCredential cred=await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password);

      //store created user
      await _firestore.collection("users").doc(cred.user!.uid).set({
        "name": name,
        "email":email,
        "password": password,
        "uid": cred.user!.uid,
        "createdAt":FieldValue.serverTimestamp(),
          });
      return "success";
    }
    catch (e){
      throw Exception(e.toString());
    }
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async{
    try{
      if(email.isEmpty||password.isEmpty){
        return "Please enter all the credentials";
      }
      await _auth.signInWithEmailAndPassword(
          email: email,
          password: password);
      return "success";
    }
    catch (e){
      throw Exception(e.toString());
    }
  }
  Future<void> signOut() async{
    await _auth.signOut();
  }
}