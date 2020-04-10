import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final messagesReference = Firestore.instance.collection('messages');

class SentMessageBubble extends StatelessWidget {
  final String documentId;
  final String userName;
  final String userUid;
  final String messageContent;
  final int createdAt;

  SentMessageBubble(this.documentId, this.userName, this.userUid,
      this.messageContent, this.createdAt);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: Key(documentId),
        direction: DismissDirection.endToStart,
        background: Container(
            color: Colors.red[800],
            margin: const EdgeInsets.only(top: 10),
            child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(Icons.cancel, color: Colors.white)))),
        onDismissed: (direction) {
          messagesReference.document(documentId).delete();
        },
        child: Align(
            alignment: Alignment.topRight,
            child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.grey[350],
                    border: Border.all(
                      color: Colors.grey[350],
                    ),
                    borderRadius: BorderRadius.all(const Radius.circular(5))),
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(userName,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                    fontWeight: FontWeight.bold)))),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(messageContent))),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                                DateFormat('dd MMM yy HH:mm a').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        createdAt)),
                                style: TextStyle(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300)))),
                  ],
                ))));
  }
}

class ReceivedMessageBubble extends StatelessWidget {
  final String userName;
  final String userUid;
  final String messageContent;
  final int createdAt;

  ReceivedMessageBubble(
      this.userName, this.userUid, this.messageContent, this.createdAt);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topLeft,
        child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.grey[350],
                border: Border.all(
                  color: Colors.grey[350],
                ),
                borderRadius: BorderRadius.all(const Radius.circular(5))),
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(userName,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontWeight: FontWeight.bold)))),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(messageContent))),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                            DateFormat('dd MMM yy HH:mm a').format(
                                DateTime.fromMillisecondsSinceEpoch(createdAt)),
                            style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w300)))),
              ],
            )));
  }
}

class MessageBubble extends StatelessWidget {
  final String documentId;
  final String userName;
  final String userUid;
  final String messageContent;
  final int createdAt;

  MessageBubble(this.documentId, this.userName, this.userUid,
      this.messageContent, this.createdAt);

  @override
  Widget build(BuildContext context) {
    final currentUserFuture = _auth.currentUser();
    return FutureBuilder(
        future: currentUserFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final currentUserUid = snapshot.data.uid;
            return currentUserUid == this.userUid
                ? SentMessageBubble(
                    documentId, userName, userUid, messageContent, createdAt)
                : ReceivedMessageBubble(
                    userName, userUid, messageContent, createdAt);
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
