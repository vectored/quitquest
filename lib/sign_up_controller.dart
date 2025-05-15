import 'package:firebase_auth/firebase_auth.dart';

class SignUpController {
  User? user;
  String? email;
  String? password;

  void setEmail(String email) {
    this.email = email;
  }

  void setPassword(String password) {
    this.password = password;
  }

  Future<void> completeSignUp(String email, String password) async {
    
    await createNewFireBaseUser();
    print("Sign up succesful");
    }

  Future<void> createNewFireBaseUser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email!, password: password!);
      user = userCredential.user; 
      print('user created with UID: ${user?.uid} and email: $user?.email');
    } on FirebaseAuthException catch (e) {
      print('Error saving useer data: $e');
    }
  }
}
