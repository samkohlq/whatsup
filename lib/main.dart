import 'package:flutter/material.dart';
import 'package:whatsup/bottom_navbar.dart';
import 'package:whatsup/chats/chats.dart';
import 'package:whatsup/constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      // home holds the widget to render for the default route of the app
      home: Scaffold(
          appBar: AppBar(
            title: Text(AppConstants.appName),
          ),
          body: Center(
            child: Chats(),
          ),
          bottomNavigationBar: BottomNavBar()),
    );
  }
}
