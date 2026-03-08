import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/screen/login_screen.dart';
import 'package:firebase_auth_app/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth_app/service/auth_providers.dart';
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final nameController=TextEditingController();
    final emailController=TextEditingController();
    final passwordController=TextEditingController();
    final provider = Provider.of<AuthenticationProvider>(context);
    void signup() async{
      provider.setLoading(true);
      final result=await AuthMethod().signUpUser(
          email: emailController.text,
          password: passwordController.text,
          name: nameController.text);
      provider.setLoading(false);
      if(!mounted) return;
      if(emailController.text.isEmpty||nameController.text.isEmpty||passwordController.text.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Fill all the fields"))
        );
        return;
      }

      if(result=='success'){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signup Successful! Login Please")));
        Future.delayed(Duration(milliseconds: 300),(){

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
        });



      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result))
        );
      }
    }

    double height=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
              height: height/2.7,
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
              child:  Image.asset("assets/images/signin.jpg",fit: BoxFit.cover,)
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: nameController,
                  autocorrect: false,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    contentPadding: EdgeInsets.all(15),
                    labelText: "Enter your name",
                    border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1)),

                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
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
                  keyboardType: TextInputType.visiblePassword,
                  controller: passwordController,
                  autocorrect: false,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    contentPadding: EdgeInsets.all(15),
                    labelText: "Enter your password",
                    border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                    suffixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.remove_red_eye))

                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(onPressed: (){
                      signup();
                    },style: ElevatedButton.styleFrom(

                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                        )
                    ), child: Text("Sign Up")),
                  ),
                ),
                Row(
                  children: [
                    Text("Already have an account?"),
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Text(" Sign In",style: TextStyle(fontWeight: FontWeight.bold),),
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
