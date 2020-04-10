import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whatsup/chat_messages/input_text_area.dart';
import 'package:whatsup/chat_messages/message_bubble.dart';

class ChatMessages extends StatelessWidget {
  // creates a reference to messages collection
  // after sorting documents by createdAt in descending order
  final messagesReference = Firestore.instance
      .collection('messages')
      .orderBy('createdAt', descending: true);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: StreamBuilder<QuerySnapshot>(
          stream: messagesReference.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              // show loading spinner until messages have been retrieved
              case ConnectionState.waiting:
                return Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );
              default:
                return new ListView(
                  // show latest messages at the bottom
                  reverse: true,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return new Message(
                      document.documentID,
                      document['userName'],
                      document['userUid'],
                      document['messageContent'],
                      document['createdAt'],
                    );
                  }).toList(),
                );
            }
          },
        )),
        Align(alignment: Alignment.bottomCenter, child: InputTextArea())
      ],
    );
  }
}
