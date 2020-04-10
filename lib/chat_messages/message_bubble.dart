import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Message extends StatelessWidget {
  final String documentId;
  final String userName;
  final String userUid;
  final String messageContent;
  final int createdAt;

  Message(this.documentId, this.userName, this.userUid, this.messageContent,
      this.createdAt);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final currentUserFuture = _auth.currentUser();
    return FutureBuilder(
        future: currentUserFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final currentUserUid = snapshot.data.uid;
            // set messageType as sent if message belongs to user that is currently logged in
            final messageType =
                (currentUserUid == this.userUid) ? "sent" : "received";
            return currentUserUid == this.userUid
                ? DismissibleWrapper(messageType, documentId, userName, userUid,
                    messageContent, createdAt)
                : MessageBubble(
                    messageType, userName, userUid, messageContent, createdAt);
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}

class MessageBubble extends StatelessWidget {
  final String messageType;
  final String userName;
  final String userUid;
  final String messageContent;
  final int createdAt;

  MessageBubble(this.messageType, this.userName, this.userUid,
      this.messageContent, this.createdAt);

  @override
  Widget build(BuildContext context) {
    Alignment alignment;
    Color bubbleColor;
    // color message bubble blue and align it to the right
    // if message belongs to user that is currently logged in
    if (messageType == "sent") {
      alignment = Alignment.topRight;
      bubbleColor = Colors.lightBlue[100];
    } else {
      alignment = Alignment.topLeft;
      bubbleColor = Colors.grey[350];
    }
    return Align(
        alignment: alignment,
        child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: bubbleColor,
                border: Border.all(
                  color: bubbleColor,
                ),
                borderRadius: BorderRadius.all(const Radius.circular(5))),
            child: Column(
              children: [
                // show who the message belongs to
                Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(userName,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontWeight: FontWeight.bold)))),
                // show the message
                Align(
                    alignment: Alignment.topLeft, child: Text(messageContent)),
                // show the time that message was sent
                Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
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

class DismissibleWrapper extends StatelessWidget {
  final String messageType;
  final String documentId;
  final String userName;
  final String userUid;
  final String messageContent;
  final int createdAt;

  DismissibleWrapper(this.messageType, this.documentId, this.userName,
      this.userUid, this.messageContent, this.createdAt);

  // creates reference to messages collection in firestore
  final messagesReference = Firestore.instance.collection('messages');

  @override
  Widget build(BuildContext context) {
    // wrap message bubble in a dismissible so that user can delete own messages
    return Dismissible(
        key: Key(documentId),
        // only allow user to swipe on message bubble from right to left
        direction: DismissDirection.endToStart,
        background: Container(
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                color: Colors.red[300],
                border: Border.all(
                  color: Colors.red[300],
                ),
                borderRadius: BorderRadius.all(const Radius.circular(5))),
            child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(Icons.cancel, color: Colors.white)))),
        onDismissed: (direction) {
          // delete message from firestore
          messagesReference.document(documentId).delete();
        },
        child: MessageBubble(
            messageType, userName, userUid, messageContent, createdAt));
  }
}
