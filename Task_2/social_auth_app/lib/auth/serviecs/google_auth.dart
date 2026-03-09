import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
class GoogleAuth {
  FirebaseAuth auth=FirebaseAuth.instance;

  Future SignInWithGoogle() async{
    String webId='453006389944-t514vnhosq7kui7jk6p7ihi7mse849ao.apps.googleusercontent.com';
    try{
      GoogleSignIn signIn=GoogleSignIn.instance;
      await signIn.initialize(serverClientId: webId);
      GoogleSignInAccount account=await signIn.authenticate();
      GoogleSignInAuthentication googleAuth=account.authentication;
      final credential=GoogleAuthProvider.credential(idToken: googleAuth.idToken);
      await auth.signInWithCredential(credential);


    }
    // try{
    //   GoogleSignIn signIn=GoogleSignIn.instance;
    //   await signIn.initialize(serverClientId: webId);
    //   GoogleSignInAccount account=await signIn.authenticate();
    //   GoogleSignInAuthentication googleAuth=account.authentication;
    //   final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);
    //   await auth.signInWithCredential(credential);
    // }
    catch (e){
      throw Exception(e.toString());
    }
  }
}