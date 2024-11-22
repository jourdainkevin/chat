import 'package:chat/screens/spalsh_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat/screens/dashboard_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupController{

  static Future<void> createAccount({
    required String email,
    required String password,
    required String name,
    required String country,
    required BuildContext context}) async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password);

      var userId = FirebaseAuth.instance.currentUser!.uid;
      var db = FirebaseFirestore.instance;

      Map<String, dynamic> data = {
        "name": name,
        "email": email,
        "country": country,
        "id": userId.toString()
      };

      try{
        await db.collection("users").doc(userId.toString()).set(data);
        print('Account created + data ADDED');
      }catch(e){
        SnackBar messageSnackBar = SnackBar(
            backgroundColor: Colors.red,
            content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(messageSnackBar);
      }

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context){
            return SplashScreen();
          }), (route) => false);
    }catch(e){
      SnackBar messageSnackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(messageSnackBar);

    }
  }



}