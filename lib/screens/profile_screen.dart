import 'package:chat/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<void> _userDetailsFuture;

  @override
  void initState() {
    super.initState();
    _userDetailsFuture = Provider.of<UserProvider>(context, listen: false).getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder(
        future: _userDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching user details'));
          } else {
            return Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          child: Text(userProvider.userName.isNotEmpty ? userProvider.userName[0].toUpperCase() : "",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("${userProvider.userName}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        Text("${userProvider.userEmail}"),
                        Text("${userProvider.userCountry}"),
                        Text("${userProvider.userId}"),
                        SizedBox(height: 10),
                        ElevatedButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context){
                                    return EditProfileScreen();
                                  }));
                            },
                            child: Text("Edit Profile"))
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}