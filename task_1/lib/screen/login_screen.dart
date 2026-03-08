import 'package:firebase_auth_app/screen/signout_screen.dart';
import 'package:firebase_auth_app/screen/signup_screen.dart';
import 'package:firebase_auth_app/service/auth_providers.dart';
import 'package:firebase_auth_app/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final passwordController=TextEditingController();
    final emailController=TextEditingController();
    final provider=Provider.of<AuthenticationProvider>(context);
    void login() async{
      provider.setLoading(true);
      if(!mounted) return;
      if(emailController.text.isEmpty||passwordController.text.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Fill all the fields"))
        );
      }
      final res=await AuthMethod().loginUser(email: emailController.text, password: passwordController.text);
      if(res=='success'){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login Successfully"))
        );
        Future.delayed(Duration(milliseconds: 300),(){
          if(!mounted) return;
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignoutScreen()));
        });


      }
    }
    double height=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: height/2.3,
            width: double.infinity,
            decoration: BoxDecoration(
              boxShadow:[
                BoxShadow(
                  color: Color.fromARGB(121, 56, 188, 241),
                  blurRadius: 15,
                  spreadRadius: 25
                )
              ]
            ),
             child:  Image.asset("assets/images/signup.jpg",fit: BoxFit.cover,)
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    contentPadding: EdgeInsets.all(15),
                    labelText: "Enter your email",
                    border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1)),

                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  autocorrect: false,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    contentPadding: EdgeInsets.all(15),
                    labelText: "Enter your password",
                    border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1)),

                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(onPressed: (){
                      login();
                    },style: ElevatedButton.styleFrom(

                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      )
                    ), child: Text("Sign In")),
                  ),
                ),
                Row(
                  children: [
                    Text("Don't have account?"),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupScreen()));
                      },
                      child: Text(" Sign Up",style: TextStyle(fontWeight: FontWeight.bold),),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
