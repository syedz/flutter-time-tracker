import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:meta/meta.dart';

class User {
  User({@required this.uid});
  final String uid;
}

abstract class AuthBase {
  Stream<User> get onAuthStateChanged;
  Future<User> currentUser();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> createUserWithEmailAndPassword(String email, String password);
  Future<User> signInAnonymously();
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<void> signOut();
}

class Auth implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(uid: user.uid);
  }

  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  Future<User> currentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return _userFromFirebase(user);
  }

  Future<User> signInAnonymously() async {
    FirebaseUser user = await FirebaseAuth.instance.signInAnonymously();
    return _userFromFirebase(user);
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return _userFromFirebase(user);
  }

  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return _userFromFirebase(user);
  }

  Future<User> signInWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        FirebaseUser user = await FirebaseAuth.instance
            .signInWithCredential(GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        return _userFromFirebase(user);
      } else {
        throw Exception('Missing Google Auth Token');
      }
    } else {
      throw Exception('Google sign in aborted');
    }
  }

  Future<User> signInWithFacebook() async {
    final facebookLogin = FacebookLogin();
    FacebookLoginResult result = await facebookLogin.logInWithReadPermissions(
      [
        'public_profile',
      ],
    );

    if (result.accessToken != null) {
      FirebaseUser user = await _firebaseAuth
          .signInWithCredential(FacebookAuthProvider.getCredential(
        accessToken: result.accessToken.token,
      ));
      return _userFromFirebase(user);
    } else {
      throw Exception('Missing Facebook Access Token');
    }
  }

  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();

    final facebookLogin = FacebookLogin();
    facebookLogin.logOut();

    return await _firebaseAuth.signOut();
  }
}
