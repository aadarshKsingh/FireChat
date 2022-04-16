import 'package:firebase_auth/firebase_auth.dart';
import 'package:firechat/helper/constants.dart';
import 'package:firechat/modal/chatUser.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import '../screens/allchats.dart';

class Authentications {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ChatUser? _firebaseUser(User? user) {
    return user != null ? ChatUser(userId: user.uid) : null;
  }

  Future mailSignIn(String mail, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: mail, password: password);
      User? chatUser = result.user;
      return _firebaseUser(chatUser);
    } catch (e) {
      print(e);
    }
  }

  Future mailSignUp(String mail, String password) async {
    try {
      UserCredential _result = await _auth.createUserWithEmailAndPassword(
          email: mail, password: password);
      User? user = _result.user;
      return _firebaseUser(user);
    } catch (e) {
      print(e);
    }
  }

  Future forgotPassword(String mail) async {
    try {
      return await _auth.sendPasswordResetEmail(email: mail);
    } catch (e) {
      print(e);
    }
  }

  signInWithGoogle(BuildContext context) async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential result = await _auth.signInWithCredential(credential);
    User? userDetails = result.user;
    Constants.name = userDetails!.displayName;
    Constants.mail = userDetails.email;
    if (result == null) {
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AllChats(name: userDetails.displayName)));
    }
  }

  Future signOut() async {
    try {
      return _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
