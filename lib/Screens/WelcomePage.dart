import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'RegistrationScreen.dart';
import 'package:chitchat/utils/roundedButtion.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'Welcome_Screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Icon(
                  Icons.chat_outlined,
                  size: 250.0,
                  color: Colors.yellow.shade600,
                ),
              ),
              Center(
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Chit Chat',
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 50.0,
                          fontWeight: FontWeight.w500),
                      speed: Duration(milliseconds: 100),
                    )
                  ],
                  totalRepeatCount: 1,
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              RoundedButton(
                textLabel: 'Log In',
                onpress: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              RoundedButton(
                textLabel: 'Register',
                onpress: () {
                  Navigator.pushNamed(context, RegisterScreen.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
