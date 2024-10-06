import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_trial/Services/database.dart';

class MyUser {
  final String? uid;

  MyUser({this.uid});
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String getCurrentUserUID() {
    return _auth.currentUser!.uid;
  }

  // Create User Object Based on User
  MyUser? _userFromFirebaseUser(User? user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  // Listen to Auth Changes

  Stream<MyUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

// SIGN IN/REGISTER METHODS

  //Sign in or Register with email
  Future<User?> signInOrRegisterWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      try {
        UserCredential result = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        User? user = result.user;
        await Database(uid: user!.uid)
            .createNewUserBaseData({}, {}, user.email!);
        return user;
      } catch (e) {
        return null;
      }
    }
  }

  // Sign in with Google

  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(forceCodeForRefreshToken: true).signIn();
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // Once signed in, save the UserCredential
      UserCredential result =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = result.user;
      await Database(uid: user!.uid).createNewUserBaseData({}, {}, user.email!);
      return user;
    } catch (e) {
      return null;
    }
  }

  // Sign Out
  Future signOut() async {
    try {
      if (await GoogleSignIn().isSignedIn()) {
        GoogleSignIn().signOut();
      }
      return await _auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }
}
