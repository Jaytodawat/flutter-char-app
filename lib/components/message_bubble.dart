import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class MessageBubble extends StatelessWidget {
  const MessageBubble({Key? key, required this.sender, required this.text, required this.loggedInUser}) : super(key: key);
  final User loggedInUser;
  final String sender;
  final String text;



  @override
  Widget build(BuildContext context) {
    //print(loggedInUser.toString());
    String? loggedInUserEmail = loggedInUser.email;
    Color messageBoxColor = sender == loggedInUserEmail ? Colors.lightBlueAccent : Colors.grey.shade700;
    CrossAxisAlignment messageBoxAlignment = sender == loggedInUserEmail ? CrossAxisAlignment.end:CrossAxisAlignment.start;
    Radius topRight = const Radius.circular(0);
    Radius topLeft = const Radius.circular(0);
    if(sender == loggedInUserEmail){
      topLeft = const Radius.circular(30);
    } else {
      topRight = const Radius.circular(30);
    }
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: messageBoxAlignment,
        children: [
          Text(
            sender,
            style: const TextStyle(fontSize: 9),
          ),
          Material(
            borderRadius: BorderRadius.only(
              topRight: topRight,
              topLeft: topLeft,
              bottomLeft: const Radius.circular(30),
              bottomRight: const Radius.circular(30),
            ),
            elevation: 5,
            color: messageBoxColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15
                  ),
                  ),
            ),
          ),

        ],
      ),
    );
  }
}