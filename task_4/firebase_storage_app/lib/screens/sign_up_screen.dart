import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage_app/auth/auth_service.dart';
import 'package:firebase_storage_app/screens/login_screen.dart';
import 'package:firebase_storage_app/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height= MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Center( child: Text("Sign Up Screen")),
        elevation: 8,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: height/2.7,
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(
                      color: Color.fromARGB(100, 5, 4, 75),
                      blurRadius: 15,
                      spreadRadius: 12
                    )
                    ]
                  ),
                  child: Image.asset('assets/images/signup.jpg',fit: BoxFit.cover,)),
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  autocorrect: false,
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "name is required";
                    }
                    if (value.length <4) {
                      return "Please enter more than 3 characters";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    labelText: "Name",
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  autocorrect: false,
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    if (!value.contains('@')) {
                      return "Please enter valid email";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    labelText: "Email",
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  autocorrect: false,
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    if (value.length < 6) {
                      return "Password must be 6+ characters";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      labelText: "Password",
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text("Already have an account."),
                   GestureDetector(
                     onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context){
                         return LoginScreen(message: '',showtoast: false,);
                       }));
                     },
                       child: Text(" login ?",style: TextStyle(fontWeight: FontWeight.bold),),
                   )
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Consumer<AuthenticationProvider> (
                builder: (context, provider, child ){
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Color.fromARGB(218, 255, 255, 255)
                    ),
                      onPressed: provider.isLoading ? null : () async {
                        AuthService _authService = AuthService();
                        try {
                          provider.setLoading(true);
                          if (_formKey.currentState!.validate()) {
                            provider.setLoading(true);
                            provider.setName(nameController.text);
                            provider.setEmail(
                                emailController.text.toLowerCase());
                            provider.setPassword(passwordController.text);

                            final result = await _authService.signIn(
                                name: provider.name,
                                email: provider.email,
                                password: provider.password
                            );
                            if (result == "successfully Signed In") {

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return LoginScreen(message: "Successfully Signed In, now log in",showtoast: true,);
                                  })).onError((error, StackTrace) {
                                Fluttertoast.showToast(msg: "Failed to log in");
                              });
                              await _authService.signOut();
                            }
                            else {
                              Fluttertoast.showToast(msg: result);
                            }
                          }
                          provider.setLoading(false);
                        }
                        on FirebaseAuthException catch (e){
                          if(e.code == 'email-already-in-use'){
                            provider.setLoading(false);
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return LoginScreen(message: "Email already Registered",showtoast: true,);
                            }));
                            await _authService.signOut();
                          }
                        }
                      }
                      , child: provider.isLoading ?
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator()
                          ],
                        ),
                      )
                      :
                  Text("   Sign In   ",style: TextStyle(fontSize: 20),)
                  );
                },
              )

            ],
          ),
        ),
      ),
    );
  }
}
