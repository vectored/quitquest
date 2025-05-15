// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (!mounted) {
        return;
      }
      Navigator.pushReplacementNamed(context, '/dashboard');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        print('Error: {$e.code}');
      }
    } //end exception catch
  } //end signIn

  @override
  dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Please log in'),
      ),
      body: Center(
          child:Column(
          children: [
            //Text for Title
            Text("Please log in"),
            //Text field for email
            TextField(controller: _emailController,
            decoration: InputDecoration(hintText: "Email")
              ), 
            //Text field for password
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(hintText: "Pasword")
            ),
            //Sizedbox for spacing
            SizedBox(height: 10),
            //GestureDetector for sign in button
            GestureDetector(onTap: signIn, 
              child: Container(
                  padding: EdgeInsets.all(25),
                  child: Center(child: Text("Log In"),)
            )
            )
          ],
      ),
      ),
    ); //end scaffold
  } //end build method
} //end _LoginP5ScreenState
