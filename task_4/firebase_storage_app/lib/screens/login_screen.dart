import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage_app/auth/auth_service.dart';
import 'package:firebase_storage_app/provider/auth_provider.dart';
import 'package:firebase_storage_app/screens/post_screen.dart';
import 'package:firebase_storage_app/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final String? message;
  final bool? showtoast;
  LoginScreen({
    super.key,
    required this.message,
    required this.showtoast
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      if (widget.message != null && widget.showtoast == true ){
        Fluttertoast.showToast(msg: widget.message!,gravity: ToastGravity.BOTTOM,toastLength: Toast.LENGTH_LONG);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    double height= MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Center( child: Text("Login Screen")),
        elevation: 8,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
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
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Image.asset('assets/images/signin.jpg',fit: BoxFit.cover,),
                  )),
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
                    Text("Don't have an account."),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                          return SignUpScreen();
                        }));
                      },
                      child: Text(" sign In?",style: TextStyle(fontWeight: FontWeight.bold),),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  AuthService().signInWithGoogle();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                    return PostScreen();
                  })
                  );
                },
                child: SizedBox(
                  height: 60,
                    width: height/4,
                    child: Image.asset('assets/images/Login.png')
                ),
              ),
              SizedBox(height: 20,),
              Consumer<AuthenticationProvider>(
                  builder: (context, provider, child){
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Color.fromARGB(218, 255, 255, 255)
                      ),
                      onPressed: provider.isLoading ? null  :
                    () async{
                      if(_formKey.currentState!.validate()){
                      try{
                        provider.setLoading(true);
                          provider.setEmail(emailController.text);
                          provider.setPassword(passwordController.text);
                          provider.setLoading(false);

                        AuthService _authService = AuthService();
                        final result =await _authService.login(
                            email: provider.email,
                            password: provider.password);
                        provider.setLoading(false);
                        if(result == "Successfully Logged In"){
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context){
                                return PostScreen();
                              }
                              )
                          );
                          provider.setLoading(false);
                        }
                        provider.setLoading(false);
                      }
                      on FirebaseAuthException catch (e){
                        if(e.code == 'user-not-found'){
                          Fluttertoast.showToast(msg: "No account found, please sign up");
                        }
                        else if(e.code == 'wrong-password'){
                          Fluttertoast.showToast(msg: 'Wrong Password');
                        }
                        else{
                          Fluttertoast.showToast(msg: e.code);
                        }
                      }
                    }},
                        child: provider.isLoading? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator()
                            ],
                          ),
                        ) : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: SizedBox(
                            height: 50,
                              width: height/4,
                              child: Center(child: Text("Log in",style: TextStyle(fontSize: 18),))),
                        ),);
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
