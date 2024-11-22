import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class ChatRoomScreen extends StatefulWidget {
  String chatRoomName;
  String chatRoomId;
  ChatRoomScreen({super.key,
    required this.chatRoomName,
    required this.chatRoomId});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  TextEditingController messageText = TextEditingController();
  var db = FirebaseFirestore.instance;

  Future<void> sendMessage() async {
    //send message to chat room
    if (messageText.text.isEmpty) {
      return;
    }
    Map<String, dynamic> messageToSend = {
      "text": messageText.text,
      "sender": Provider.of<UserProvider>(context, listen: false).userName,
      "sender_id": Provider.of<UserProvider>(context, listen: false).userId,
      "chatroom_id": widget.chatRoomId,
      "timestamp": FieldValue.serverTimestamp()
    };
    print('Message to send: $messageToSend');
    try {
      await db.collection("messages").add(messageToSend);
      messageText.clear();
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  Widget singleChatItem({required String sender_name, required String text}) {
    return Column(
      crossAxisAlignment: Provider.of<UserProvider>(context, listen: false).userName == sender_name ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(sender_name, style: TextStyle(color: Colors.blue[600], fontWeight: FontWeight.bold, fontSize: 16),),
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Provider.of<UserProvider>(context, listen: false).userName == sender_name ? Colors.blue[600] : Colors.deepPurple[800],
            ),
            child: Padding(
              padding: const EdgeInsets.only(left:6 , right: 6, top: 4, bottom: 4),
              child: Text(text, style: TextStyle(fontSize: 18),),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.chatRoomName),
        ),
        body: Column(
          children: [
            Expanded(
                child: StreamBuilder(
                    stream: db.collection("messages")
                        .where("chatroom_id", isEqualTo: widget.chatRoomId)
                        .orderBy("timestamp", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print('Error fetching messages: ${snapshot.error}');
                        return Center(child: Text('Error fetching messages'));
                      }
                      var allmessages = snapshot.data?.docs ?? [];
                      if(allmessages.isEmpty){
                        return Center(child: Text('No messages yet'));
                      }
                      return ListView.builder(
                          reverse: true,
                          itemCount: allmessages.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: singleChatItem(sender_name: allmessages[index]["sender"], text: allmessages[index]["text"]),
                              ),
                            );
                          }
                      );
                    }
                )
            ),
            SingleChildScrollView(
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageText,
                        decoration: InputDecoration(
                            hintText: 'Type a message',
                            hintStyle: TextStyle(color: Colors.grey[300]),
                            contentPadding: EdgeInsets.all(10),
                            border: InputBorder.none
                        ),
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          sendMessage();
                        },
                        child: Icon(Icons.send, color: Colors.blue[600],)
                    )
                  ],
                ),
              ),
            )
          ],
        )
    );
  }
}