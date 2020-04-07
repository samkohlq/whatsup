import 'package:flutter/material.dart';
import 'package:whatsup/bottom_navbar.dart';
import 'package:whatsup/chat_messages/chat_messages.dart';
import 'package:whatsup/constants.dart';
import 'package:whatsup/input_text_area.dart';
import 'package:whatsup/sign_in_with_google.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      // home holds the widget to render for the default route of the app
      home: SignInWithGoogle(),
    );
  }
}

class MainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppConstants.appName),
        ),
        body: Column(
          children: [
            Expanded(child: ChatMessages()),
            Align(alignment: Alignment.bottomCenter, child: InputTextArea())
          ],
        ),
        bottomNavigationBar: BottomNavBar());
  }
}
