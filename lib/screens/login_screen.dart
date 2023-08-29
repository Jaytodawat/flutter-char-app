import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';

import 'package:flash_chat/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  late String email;
  late String password;
  @override
  _displayDialog(BuildContext context, String e) async{
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Error', style: TextStyle(color: Colors.black),),
            content: SingleChildScrollView(
              child: Text(e,
                style: const TextStyle(color: Colors.black, fontSize: 13),),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Approve', style: TextStyle(color: Colors.lightBlueAccent),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child:SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Hero(
                  tag: kHeroTag,
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                const SizedBox(
                  height: 48.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  onChanged: (value) {
                    email = value;
                    //Do something with the user input.
                  },
                  decoration: kInputDecoration
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                  onChanged: (value) {
                    password = value;
                    //Do something with the user input.
                  },
                  decoration: kInputDecoration.copyWith(hintText: "Enter Password Here")
                ),
                const SizedBox(
                  height: 24.0,
                ),

                RoundedButton(
                    onPressed: () async{
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        final navigator = Navigator.of(context);
                        final user = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        navigator.pushNamed(ChatScreen.id);
                        setState(() {
                          showSpinner = false;
                        });
                      } catch(e){
                        setState(() {
                          showSpinner = false;
                          _displayDialog(context, e.toString());
                        });

                      }

                    },
                    text: 'Log In',
                    color: Colors.lightBlueAccent),

              ],
            ),
          ),
        ),
    ),
      ),
    );
  }
}


