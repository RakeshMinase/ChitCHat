import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ChatScreen.dart';
import 'SearchChatScreen.dart';
import 'WelcomePage.dart';

final _auth = FirebaseAuth.instance;

class ChatListScreen extends StatefulWidget {
  static String id = 'ChatList_Screen';
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final _firestore = FirebaseFirestore.instance;

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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.pushNamed(context, SearchChatScreen.id);
        },
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            StreamBuilder(
              stream: _firestore
                  .collection('Users')
                  .limit(20)
                  .orderBy('Username')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }
                final users = snapshot.data.docs;
                List<chatlist> chatListWidgets = [];
                for (var user in users) {
                  final username = user.data()['Username'];
                  if (username == _auth.currentUser.email.toString()) {
                    continue;
                  }
                  final chatWidget = chatlist(
                    usern: username,
                  );
                  chatListWidgets.add(chatWidget);
                }
                return Expanded(
                  child: ListView(
                    children: chatListWidgets,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class chatlist extends StatelessWidget {
  chatlist({this.usern});

  final String usern;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  usern,
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              Material(
                elevation: 5.0,
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(10.0),
                child: MaterialButton(
                  onPressed: () {
                    List<String> temp = [_auth.currentUser.email, usern];
                    temp.sort();
                    String ChatRoomId = '${temp[0]}_${temp[1]}';
                    print(ChatRoomId);
                    List<String> users = [usern, _auth.currentUser.email];
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
              )
            ],
          ),
          Divider(color: Colors.white60,)
        ],
      ),
    );
  }
}
