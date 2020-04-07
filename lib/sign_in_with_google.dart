import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:whatsup/main.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class SignInWithGoogle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.white,
            child: Center(
                child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlutterLogo(size: 150),
                SizedBox(height: 50),
                SignInButton(),
              ],
            ))));
  }
}

class SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      child: new Text("Sign in"),
      onPressed: () async {
        await signInWithGoogle();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainContent()),
        );
      },
    );
  }
}

Future signInWithGoogle() async {
  try {
    final GoogleSignInAccount googleSignInAccount =
        await googleSignIn.signIn().catchError((onError) {
      print('Error: $onError');
    });
    if (googleSignInAccount != null) {
      final googleAuth = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      final authResult = await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      // confirms that user is signed in
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);

      Firestore.instance.document('users/${user.uid}').setData({
        'email': user.email,
        'name': user.displayName,
      });
      return currentUser;
    }
    return null;
  } on PlatformException catch (error) {
    print('Error: $error');
  }
}

void signOut() async {
  await _auth.signOut();
  await googleSignIn.signOut();
}
