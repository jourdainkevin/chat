import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/user_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Map<String,dynamic>? userData = {};
  TextEditingController nameText = TextEditingController();
  var db = FirebaseFirestore.instance;

  @override
  void initState() {
    nameText.text = Provider.of<UserProvider>(context, listen: false).userName;
    super.initState();
  }

  void updateUserDetails(){
    Map<String, dynamic> dataToUpdate = {
      "name": nameText.text,
    };
    db.collection("users").doc(Provider.of<UserProvider>(context, listen: false).userId).update(dataToUpdate);
    Provider.of<UserProvider>(context, listen: false).getUserDetails();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    var formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit profile'),
        actions: [
          IconButton(
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.check),
            ),
            onPressed: (){
              if(formKey.currentState!.validate()){
                updateUserDetails();
              }
              else{

              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value){
                          if(value == null || value.isEmpty || value.length < 3){
                            return "Name is required and should be at least 3 characters long";
                          }
                        },
                        controller: nameText,
                        onChanged: (value){
                          userProvider.userName = value;
                        },
                        decoration: InputDecoration(
                          labelText: "Name",
                          border: OutlineInputBorder()
                        ),
                      )
                    ],
                  ),
                ),
              ),
              //Text(userProvider.userId),
            ],
          )
        ),
      )
    );
  }
}
