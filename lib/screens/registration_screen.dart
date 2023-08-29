import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';


class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  const RegistrationScreen({super.key});
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
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
                    },
                    decoration: kInputDecoration,
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
                    },
                    decoration: kInputDecoration.copyWith(hintText: "Enter your password"),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),

                  RoundedButton(
                      onPressed: () async{
                        setState(() {
                          showSpinner = true;
                        });
                        try{
                          final navigator = Navigator.of(context);
                          final newUser =  await _auth.createUserWithEmailAndPassword(email: email, password: password);
                          navigator.pushNamed(ChatScreen.id);
                          setState(() {

                            showSpinner = false;
                          });
                        } catch(e){
                          print(e);
                        }

                      },
                      text: 'Register',
                      color: Colors.blueAccent),

                ],
              ),
        ),
          ),
    ),
      ),);
  }
}