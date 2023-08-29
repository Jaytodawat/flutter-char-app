import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

import '../components/message_bubble.dart';
final _firestore = FirebaseFirestore.instance;

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //late FirebaseUser loggedInUser;

  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  late String messageText;
  var controller = TextEditingController();

  @override
  void initState(){
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    }catch(e){
      print(e);
    }
  }

  User getLoggedInUser(){
    return loggedInUser;
  }

  void getMessage() async{
    // final messages = await _firestore.collection('messages').get();
    // for(var message in messages.docs){
    //   print(message.data());
    // }
  }

  void messagesStream() async{
    await for(var snapshot in _firestore.collection('messages').snapshots()){
      for(var message in snapshot.docs){
        print(message.data());
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(loggedInUser: getLoggedInUser(),),
            Container(
              alignment: Alignment.bottomCenter,
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      style: const TextStyle(
                        color: Colors.black
                      ),
                      controller: controller,
                      onChanged: (value) {
                        setState(() {
                          messageText = value;
                        });
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        controller.clear();
                      });
                      try{
                        _firestore.collection('messages').add({
                         'text':messageText,
                          'sender':loggedInUser.email,
                          'timestamp':FieldValue.serverTimestamp(),
                        });
                      } catch(e){
                        print(e);
                      }

                      //Implement send functionality.
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({Key? key, required this.loggedInUser}) : super(key: key);
  final User loggedInUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:_firestore.collection('messages').orderBy('timestamp').snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        List<MessageBubble> messageWidgets = [];
        if(snapshot.hasData){
          final messages = snapshot.data?.docs;
          for(var message in messages!){
            final messageText = message.data()['text'];
            final messageSender = message.data()['sender'];
            final messageWidget = MessageBubble(sender: messageSender, text: messageText, loggedInUser: loggedInUser,);
            messageWidgets.add(messageWidget);
          }
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageWidgets.reversed.toList(),
          ),
        );
      },
    );
  }
}



