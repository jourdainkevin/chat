import 'package:chat/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Signup'),
        ),
        body: Column(
          children: [
            Text("Don't have an account ? "),
            ElevatedButton(onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return SignupScreen();
                  }));
            }, child: Text('Signup now'))
          ],
        )
    );
  }
}
