import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whatsup/chat_messages/message_bubble.dart';

class ChatMessages extends StatelessWidget {
  final messagesReference = Firestore.instance
      .collection('messages')
      .orderBy('createdAt', descending: true);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: messagesReference.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                return new MessageBubble(
                  document['messageContent'],
                  document['createdAt'],
                );
              }).toList(),
            );
        }
      },
    );
  }
}
