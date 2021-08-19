import 'package:chitchat/Screens/WelcomePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'ChatScreen.dart';

String searchFound = '';
User loggedInUser;
final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

class SearchChatScreen extends StatefulWidget {
  static String id = 'searchChat_Screen';

  @override
  _SearchChatScreenState createState() => _SearchChatScreenState();
}

class _SearchChatScreenState extends State<SearchChatScreen> {
  String username;
  TextEditingController searchName = new TextEditingController();

  QuerySnapshot searchResult;
  TextEditingController UsernameC = new TextEditingController();

  

  initiateSearch() async {
    try {
      if (UsernameC.text == _auth.currentUser.email) {
        setState(() {
          Alert(
            context: context,
            type: AlertType.error,
            title: "Error",
            desc: "You cannot chat with yourself",
            buttons: [
              DialogButton(
                child: Text(
                  "Ok",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                width: 120,
              )
            ],
          ).show();
        });
      } else if (UsernameC.text.isNotEmpty) {
        await _firestore
            .collection('Users')
            .where('Username', isEqualTo: UsernameC.text)
            .get()
            .then((snapshot) {
          searchFound = snapshot.docs[0].data()['Username'].toString();
        });
      }
    } catch (e) {
      setState(() {
        Alert(
          context: context,
          type: AlertType.error,
          title: "Error",
          desc: "User not found",
          buttons: [
            DialogButton(
              child: Text(
                "Ok",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _auth.signOut();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()));
            },
          )
        ],
        title: Text('ChitChat'),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: UsernameC,
                    onChanged: (value) {
                      username = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter a username to search',
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    ),
                  ),
                ),
                VerticalDivider(
                  color: Colors.black,
                ),
                GestureDetector(
                  child: Icon(Icons.search),
                  onTap: () {
                    setState(() {
                      initiateSearch();
                    });
                  },
                ),
              ],
            ),
          ),
          searchList(
            foundUser: searchFound,
            isfound: searchFound != '',
          ),
        ],
      ),
    );
  }
}

class searchList extends StatelessWidget {
  searchList({this.foundUser, this.isfound});

  final bool isfound;
  final String foundUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              foundUser,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          isfound ? Material(
            elevation: 5.0,
            color: Colors.lightBlue,
            borderRadius: BorderRadius.circular(20.0),
            child: MaterialButton(
              onPressed: () {
                List<String> temp = [_auth.currentUser.email, foundUser];
                temp.sort();
                String ChatRoomId = '${temp[0]}_${temp[1]}';
                print(ChatRoomId);
                List<String> users = [foundUser, _auth.currentUser.email];
                print(users);
                if (ChatRoomId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        chatroomid: ChatRoomId,
                        chatusers: users,
                      ),
                    ),
                  );
                }
              },
              child: Text('Chat'),
            ),
          ) : Text('')
        ],
      ),
    );
  }
}
