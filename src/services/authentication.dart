import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import './database.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password, String displayName);
  Future<String> signInGoogle();
  Future<FirebaseUser> getCurrentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password
    );
    return user.uid;
  }

  Future<String> signUp(String email, String password, String displayName) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    DBService.safeAddUser(user.uid, user.email, displayName);
    return user.uid;
  }

  Future<String> signInGoogle() async {
    try {
      GoogleSignInAccount account = googleSignIn.currentUser;
      if (account == null) {
        account = await googleSignIn.signInSilently();
      }
      if (account == null) {
        account = await googleSignIn.signIn();
      }


      final GoogleSignInAuthentication googleAuth = await account.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      FirebaseUser user = await _firebaseAuth.signInWithCredential(credential);
      DBService.safeAddUser(user.uid, user.email, account.displayName);
      print("Authenticated with google: $user.uid");
      return user.uid;
    }catch(e) {
      print(e);
      return "";
    }
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
  
}