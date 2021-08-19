import 'package:flutter/material.dart';
import 'package:chitchat/utils/roundedButtion.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'ChatListScreen.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'Login_Screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameC = TextEditingController();
  final passwordC = TextEditingController();
  bool showspinner = false;
  final _auth = FirebaseAuth.instance;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showspinner,
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 110.0),
          child: ListView(
            children: <Widget>[
              Center(
                child: Text(
                  'Chit Chat',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 50.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 60.0,
              ),
              Center(
                child: Text(
                  'Log In',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w300),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              TextField(
                controller: usernameC,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter your E-mail id',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              TextField(
                controller: passwordC,
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              RoundedButton(
                textLabel: 'Login',
                onpress: () async {
                  setState(
                    () {
                      showspinner = true;
                    },
                  );
                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (user != null) {
                      Navigator.pushNamed(context, ChatListScreen.id);
                    }
                    setState(
                      () {
                        usernameC.clear();
                        passwordC.clear();
                        showspinner = false;
                      },
                    );
                  } catch (e) {
                    showspinner = false;
                    usernameC.clear();
                    passwordC.clear();
                    setState(() {
                      Alert(
                        context: context,
                        type: AlertType.error,
                        title: "Error",
                        desc: "Enter Valid username and password",
                        buttons: [
                          DialogButton(
                            child: Text(
                              "Ok",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () => Navigator.pop(context),
                            width: 120,
                          )
                        ],
                      ).show();
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
