import 'package:firebase_auth_app/screen/login_screen.dart';
import 'package:firebase_auth_app/service/auth_service.dart';
import 'package:flutter/material.dart';
class SignoutScreen extends StatelessWidget {
  const SignoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:ElevatedButton(
          onPressed: () async {
            await AuthMethod().signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          child: Text("Sign Out"),
        )

      ),
    );
  }
}
