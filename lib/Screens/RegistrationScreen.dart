import 'package:chitchat/Screens/ChatListScreen.dart';
import 'package:flutter/material.dart';
import 'package:chitchat/utils/roundedButtion.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  static String id = 'Register_Screen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final usernameC = TextEditingController();
  final passwordC = TextEditingController();
  String email;
  String password;
  bool showspinner = false;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

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
                  'Register',
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
                textLabel: 'Register',
                onpress: () async {
                  setState(
                    () {
                      showspinner = true;
                    },
                  );
                  try {
                    final newuser = await _auth.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    _firestore.collection('Users').add({'Username': email});
                    if (newuser != null) {
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
