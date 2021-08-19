import 'package:chitchat/Screens/ChatListScreen.dart';
import 'package:flutter/material.dart';
import 'Screens/WelcomePage.dart';
import 'Screens/LoginPage.dart';
import 'Screens/RegistrationScreen.dart';
import 'Screens/ChatScreen.dart';
import 'Screens/SearchChatScreen.dart';
import 'Screens/ChatListScreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChitChat());
}

class ChitChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        ChatListScreen.id: (context) => ChatListScreen(),
        SearchChatScreen.id: (context) => SearchChatScreen(),
      },
    );
  }
}
