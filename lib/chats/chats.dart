import 'package:flutter/material.dart';
import 'package:whatsup/chats/chat_bubble.dart';

class Chats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.all(18),
        children: <Widget>[ChatBubble(), ChatBubble()]);
  }
}
