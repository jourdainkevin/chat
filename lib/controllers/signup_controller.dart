import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat/screens/dashboard_screen.dart';

class SignupController{

  static Future<void> createAccount({required String email, required String password, required BuildContext context}) async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password);
      print('Account created');
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context){
            return DashboardScreen();
          }), (route) => false);
    }catch(e){
      SnackBar messageSnackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(messageSnackBar);

    }
  }



}