import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'WelcomePage.dart';

User loggedInUser;

class ChatScreen extends StatefulWidget {
  ChatScreen({this.chatroomid, this.chatusers});

  final String chatroomid;
  final chatusers;
  static String id = 'Chat_Screen';

  @override
  _ChatScreenState createState() =>
      _ChatScreenState(ChatRoomId: chatroomid, ChatUsers: chatusers);
}

class _ChatScreenState extends State<ChatScreen> {
  _ChatScreenState({this.ChatRoomId, this.ChatUsers});

  final String ChatRoomId;
  final ChatUsers;
  final messageTextController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String message;

  @override
  void initState() {
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
        leading: null,
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
        title: Text(ChatUsers[0]),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder(
              stream: _firestore
                  .collection('Messages')
                  .doc(ChatRoomId)
                  .collection('Chats')
                  .limit(20)
                  .orderBy('Time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }
                final chats = snapshot.data.docs;
                List<chatbubble> chatWidgets = [];
                for (var chat in chats) {
                  final messageText = chat.data()['Text'];
                  final messsageHour = chat.data()['TimeHour'];
                  final messageMinute = chat.data()['TimeMinute'];
                  final currentUser = chat.data()['Sender'];
                  final chatWidget = chatbubble(
                    text: messageText,
                    hour: messsageHour,
                    minute: messageMinute,
                    isMe: currentUser == loggedInUser.email,
                  );
                  chatWidgets.add(chatWidget);
                }
                return Expanded(
                  child: ListView(
                    reverse: true,
                    children: chatWidgets,
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                top: BorderSide(color: Colors.blue, width: 2.0),
              )),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        message = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter a message',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                      ),
                    ),
                  ),
                  VerticalDivider(
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: FlatButton(
                        onPressed: () {
                          messageTextController.clear();
                          _firestore
                              .collection('Messages')
                              .doc(ChatRoomId)
                              .collection('Chats')
                              .add({
                            'Text': message,
                            'TimeHour': DateTime.now().hour.toString(),
                            'TimeMinute': DateTime.now().minute.toString(),
                            'Time': DateTime.now(),
                            'Sender': loggedInUser.email,
                          });
                        },
                        child: Text('SEND')),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class chatbubble extends StatelessWidget {
  chatbubble({this.text, this.sender, this.hour, this.minute, this.isMe});

  final String text;
  final String sender;
  final String hour;
  final String minute;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(25.0),
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0),
                  ),
            elevation: 6.0,
            color: isMe ? Colors.blue.shade900 : Colors.blue.shade700,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 15.0),
              ),
            ),
          ),
          Text(
            '$hour : $minute',
            style: TextStyle(fontSize: 12.0, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
