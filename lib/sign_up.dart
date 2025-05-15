import 'package:flutter/material.dart';
import 'package:myapp/log_in.dart';
import 'package:myapp/sign_up_controller.dart';


class SignUpScreen extends StatefulWidget{
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen>{
  final TextEditingController _emailControler = TextEditingController(); 
  final TextEditingController _passwordControler = TextEditingController(); 
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SignUpController _signUpController = SignUpController();

  bool _passwordVisible = false; 

  String? _validateEmail(String? value){
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // regular expression for email validation 
    const String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$";
    final RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QuitQuest - Sign Up ヾ(•ω•`)o "),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), 
        child: Form(
          key: _formKey, 
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailControler,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(),
                ),
                validator: _validateEmail,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordControler,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if(_formKey.currentState!.validate()){
                      _signUpController.completeSignUp(_emailControler.text, _passwordControler.text);
                      Navigator.pushReplacementNamed(context, '/login');
                  }else{
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill in all fields")));
                    }
                },
                child: const Text("Complete sign up")
                ),
               const SizedBox(height: 20),
                ElevatedButton(
                onPressed: () {
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                }, child: const Text('Log in'),
                ),
                SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }
}
