import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';

  const WelcomeScreen({super.key});
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation animation;

  @override
  void initState(){
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
      upperBound:1,
    );
    //animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    animation = ColorTween(begin: Colors.transparent, end: Colors.teal).animate(controller);

    //controller.reverse(from: 1.0);
    controller.forward();

    /*animation.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        controller.reverse(from: 1.0);
      } else if(status == AnimationStatus.dismissed){
        controller.forward();
      }
    });*/
    controller.addListener(() {
      setState((){});
    });
  }
  @override
  void dispose(){
    controller.dispose();
    super.dispose();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: kHeroTag,
                    child: Container(
                      height:60,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                AnimatedTextKit(
                  //pause: const Duration(seconds: 5), duration ofpause between 2 round
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Flash Chat',
                      speed: Duration(milliseconds: 80),
                      textStyle: const TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.w900,
                    ),)
                  ],
                ),
              ],
            ),

            const SizedBox(
              height: 48.0,
            ),

            RoundedButton(
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                text: 'Log In',
                color: Colors.lightBlueAccent,
            ),

            RoundedButton(
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
                text: 'Register',
                color: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}






