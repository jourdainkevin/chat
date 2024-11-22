import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProvider extends ChangeNotifier {
  String userName = "";
  String userEmail = "";
  String userCountry = "";
  String userId = "";

  var db = FirebaseFirestore.instance;

  Future<void> getUserDetails() async {
    var user = FirebaseAuth.instance.currentUser;
    var data = await db.collection("users").doc(user!.uid).get().then((dataSnapshot){
      userName = dataSnapshot.data()?["name"] ?? "";
      userEmail = dataSnapshot.data()?["email"] ?? "";
      userCountry = dataSnapshot.data()?["country"] ?? "";
      userId = dataSnapshot.data()?["id"] ?? "";
      notifyListeners();
    });
  }

}