import 'package:chat/screens/chatroom_screen.dart';
import 'package:chat/screens/profile_screen.dart';
import 'package:chat/screens/spalsh_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var user = FirebaseAuth.instance.currentUser;
  var db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> chatroomsList = [];
  List<String> chatroomIds = [];
  var scaffoldKey = GlobalKey<ScaffoldState>();


  void getChatrooms() {
    db.collection("chatrooms").get().then((dataSnapshot) {
      chatroomsList.clear(); // clear the list before adding new items
      for (var item in dataSnapshot.docs) {
        chatroomsList.add(item.data());
        chatroomIds.add(item.id);
      }
      setState(() {
        chatroomsList = chatroomsList;
      });
    }).catchError((error) {
      print('Error getting chatrooms: $error');
      // Handle the error here, e.g. display a message to the user
    });
  }

  @override
  void initState() {
    getChatrooms();
    Provider.of<UserProvider>(context, listen: false).getUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            scaffoldKey.currentState!.openDrawer();
          },
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              radius: 20,
              child: Text(
                userProvider.userName.isNotEmpty ? userProvider.userName[0].toUpperCase() : "",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ),
        title: const Text('Dashboard'),
      ),
      drawer: Drawer(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 40),
              ListTile(
                onTap: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProfileScreen();
                  }));
                },
                leading: CircleAvatar(
                  child: Text(
                    userProvider.userName.isNotEmpty ? userProvider.userName[0].toUpperCase() : "",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                title: Text(userProvider.userName),
                subtitle: Text(userProvider.userEmail),
              ),
              ListTile(
                onTap: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProfileScreen();
                  }));
                },
                leading: Icon(Icons.people),
                title: Text('Profile'),
              ),
              ListTile(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                    return SplashScreen();
                  }), (route) => false);
                },
                leading: Icon(Icons.logout),
                title: Text('Logout'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      body: Center(
        child: chatroomsList.isEmpty
            ? Text('No chatrooms available')
            : ListView.builder(
          itemCount: chatroomsList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ChatRoomScreen(
                    chatRoomName: chatroomsList[index]["chatroom_name"].toString(),
                    chatRoomId: chatroomIds[index].toString(),
                  );
                  //chatroom: chatroomsList[index]
                }));
              },
              leading: CircleAvatar(
                backgroundColor: Colors.blue[600],
                child: Text(
                  chatroomsList[index]["chatroom_name"].isNotEmpty ? chatroomsList[index]["chatroom_name"][0].toUpperCase() : "",
                ),
              ),
              title: Text(chatroomsList[index]["chatroom_name"]),
              subtitle: Text(chatroomsList[index]["description"]),
            );
          },
        ),
      ),
    );
  }
}
